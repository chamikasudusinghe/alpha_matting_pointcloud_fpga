#dependencies - opencv, open3d, shapely, numpy, scipy, pillow, numba
#parameters - area_covered, alpha_value, point_percentage, blur_factor, shrinking_factor

import os
import cv2
import numpy
import numba
import time

import PIL
import PIL.Image
import PIL.ImageOps
import PIL.ImageEnhance
import PIL.ImageDraw

import matplotlib.pyplot as plt

import open3d as o3d
from shapely import geometry
from scipy.spatial import Delaunay
from scipy.optimize import linprog

import sys

#find the boundary edges of a concave hull
def boundary_edges(edges):
    edge_set = edges.copy()
    boundary_list = []
    while len(edge_set) > 0:
        boundary = []
        edge = edge_set.pop()
        boundary.append(edge)
        last_edge = edge
        while len(edge_set) > 0:
            i,j = last_edge
            j_first, j_second = get_edges(j, edge_set)
            if j_first:
                edge_set.remove((j, j_first[0]))
                edge_with_j = (j, j_first[0])
                boundary.append(edge_with_j)
                last_edge = edge_with_j
            elif j_second:
                edge_set.remove((j_second[0], j))
                edge_with_j = (j, j_second[0])
                boundary.append(edge_with_j)
                last_edge = edge_with_j
            if edge[0] == last_edge[1]:
                break
        boundary_list.append(boundary)
    return boundary_list

#generate 2d points from 3d points
def camera_matrix(boundary,iterator):
    mat = numpy.load('p_matrix/world_mat_'+str(iterator)+'.npy').tolist()
    P = numpy.array([[mat[0][0], mat[0][1], mat[0][2], mat[0][3]],
                [mat[1][0], mat[1][1], mat[1][2], mat[1][3]],
                [mat[2][0], mat[2][1], mat[2][2], mat[2][3]],
                [mat[3][0], mat[3][1], mat[3][2], mat[3][3]]])
    start = time.time()
    perspecctive = numpy.asarray(compute_p(P,boundary,iterator))
    end = time.time()
    print("Elaspsed Time for Perspective Generation: ", str(end-start))
    return perspecctive

#computation of area
@numba.njit()
def compute_area(points,vertices,alpha):
    def add_new_edge(edges, i, j):
        if (i, j) in edges or (j, i) in edges:
            assert (j, i) in edges, "Cannot iterate the same edge"
            edges.remove((j, i))
            return
        edges.add((i, j))
    edges = set()
    for ia,ib,ic in vertices:
        pa = points[ia]
        pb = points[ib]
        pc = points[ic]
        a = numpy.sqrt((pa[0] - pb[0]) ** 2 + (pa[1] - pb[1]) ** 2)
        b = numpy.sqrt((pb[0] - pc[0]) ** 2 + (pb[1] - pc[1]) ** 2)
        c = numpy.sqrt((pc[0] - pa[0]) ** 2 + (pc[1] - pa[1]) ** 2)
        s = (a + b + c) / 2.0
        area = numpy.sqrt(s * (s - a) * (s - b) * (s - c))
        if area != 0:
            circum_r = a * b * c / (4.0 * area)
            if circum_r < alpha:
                add_new_edge(edges, ia, ib)
                add_new_edge(edges, ib, ic)
                add_new_edge(edges, ic, ia)
    return edges

def compute_p(P,boundary,iterator):
        coords = []
        coord_x = []
        coord_y = []
        i = 1
        for coordinates in boundary:
            perspect_mat = numpy.array([coordinates[0],coordinates[1],coordinates[2],1])
            p_mat = P.dot(perspect_mat)
            p_mat /= p_mat[2]
            if p_mat[0]<=640 and p_mat[0]>=0 and p_mat[1]<=480 and p_mat[1]>=0:
                coords.append([p_mat[0],p_mat[1]])       
                coord_x.append(p_mat[0])
                coord_y.append(p_mat[1])
            i+=1
        x_cord = numpy.asarray(coord_x)
        y_cord = numpy.asarray(coord_y)
        plt.xlim(-10, 700)
        plt.ylim(-10, 500)
        plt.scatter(x_cord,y_cord,color='black')
        plt.axis('off')
        plt.savefig("mask/init_0"+str(iterator)+".png", bbox_inches='tight', pad_inches=0)
        return coords

#create a concave hull and get the boundary coordinates
def concave_hull(points,alpha,object_type):
    edges = get_alpha(points, alpha=alpha)
    bound = boundary_edges(edges)
    bound.sort(key=len)
    bound.reverse()
    outer = [(points[i,[0,1]][0],points[i,[0,1]][1]) for i, j in bound[0]]
    bounds = []
    if object_type == 2:
        for k in range(1,len(bound)):
            pointer = [(points[i,[0,1]][0],points[i,[0,1]][1]) for i, j in bound[k]]
            area_covered = 0.5 * numpy.abs(sum(x0*y1 - x1*y0 for ((x0, y0), (x1, y1)) in zip(pointer, pointer[1:] + [pointer[0]])))
            #set the minimum area to 200 units
            if area_covered>200:
                bounds.append(pointer)
    return outer,bounds

#calculate the percenage of points covered by a concave hull
def current_shape(points,inside):
    tri = Delaunay(points)
    return (len([i for i in inside if(tri.find_simplex(i)>=0)])/len(inside))*100
    
#draw the image from the points
def draw(point,bounds,iterator):
    image_width = 640
    image_height = 480
    kernel = numpy.ones((3,3), numpy.uint8) #kernel size as 5 should be optimal
    image = PIL.Image.new("RGB", (image_width, image_height))
    draw = PIL.ImageDraw.Draw(image)
    points = tuple(point)
    draw.polygon((points), fill="white")
    img = numpy.asarray(image)
    img_erosion = cv2.erode(img, kernel, iterations=2)
    img_ero = cv2.cvtColor(img_erosion, cv2.COLOR_BGR2RGB)
    erosion = PIL.Image.fromarray(img_ero)
    image = image.convert("RGB")
    erosion = erosion.convert("RGB")
    outer = PIL.Image.blend(image, erosion, 0.5)
    if iterator>9:
        outer.save("mask/0"+str(iterator)+".png","PNG")
    else:
        outer.save("mask/00"+str(iterator)+".png","PNG")
    for pointer in bounds:
        if iterator>9:
            outer = PIL.Image.open("mask/0"+str(iterator)+".png")
        else:
            outer = PIL.Image.open("mask/00"+str(iterator)+".png")
        image = PIL.Image.new("RGB", (image_width, image_height))
        draw = PIL.ImageDraw.Draw(image)
        points = tuple(pointer)
        draw.polygon((points), fill="white")
        draw.polygon((points), fill="white")
        img = numpy.asarray(image)
        img_erosion = cv2.erode(img, kernel, iterations=2)
        img_ero = cv2.cvtColor(img_erosion, cv2.COLOR_BGR2RGB)
        erosion = PIL.Image.fromarray(img_ero)
        image = image.convert("RGB")
        erosion = erosion.convert("RGB")
        inner = PIL.Image.blend(image, erosion, 0.5)
        inner = PIL.ImageOps.invert(inner)
        inner = inner.convert("RGB")
        outer = outer.convert("RGB")
        trimap = PIL.Image.blend(inner, outer, 0.5)
        pixels = trimap.load()
        for i in range(trimap.size[0]):
            for j in range(trimap.size[1]):
                    if pixels[i,j]==(127,127,127):
                        pixels[i,j] = (0,0,0)
                    elif pixels[i,j]==(191,191,191):
                        pixels[i,j] = (127,127,127)
        if iterator>9:
            trimap.save("mask/0"+str(iterator)+".png","PNG")
        else:
            trimap.save("mask/00"+str(iterator)+".png","PNG")

#generate alpha shape
def get_alpha(points,alpha):
    assert points.shape[0] > 3, "Need atleast 4 points"
    tri = Delaunay(points)
    return compute_area(points,tri.vertices,alpha)

#get edges to create the boundary edge set
def get_edges(i, edge_set):
    i_first = [j for (x,j) in edge_set if x==i]
    i_second = [j for (j,x) in edge_set if x==i]
    return i_first,i_second

#generate trimaps
def generate_mask(boundary,object_type,i):
    draw_trimap = True
    points = camera_matrix(boundary,i)
    print("2D perspective: ",str(i)," generated")
    #set initial alpha value to 1
    alpha_value = 1.5
    outer,bounds = concave_hull(points,alpha_value,object_type)
    if draw_trimap:
        draw(outer,bounds,i)
        print("Mask: ",str(i)," is generated with alpha value: ",str(alpha_value-0.5))

#shrinking the boundaries to create the trimap
def shrink(point):
    lines = [[point[i-1], point[i]] for i in range(len(point))]
    #set the shrinking factor to 0.01 (1%)
    shrinking_factor = 0.01
    xs = [i[0] for i in point]
    ys = [i[1] for i in point]
    x_center = 0.5 * min(xs) + 0.5 * max(xs)
    y_center = 0.5 * min(ys) + 0.5 * max(ys)
    min_corner = geometry.Point(min(xs), min(ys))
    max_corner = geometry.Point(max(xs), max(ys))
    center = geometry.Point(x_center, y_center)
    shrink_distance = center.distance(min_corner)*shrinking_factor
    abs(shrink_distance - center.distance(max_corner)) > 0.0001, "Shrink distance is too small"
    polygon = geometry.Polygon(point)
    shrunken_polygon = polygon.buffer(-shrink_distance)
    if shrunken_polygon.geom_type == 'MultiPolygon':
        print("MultiPolygon Detected")
        max_length = 0
        index = 0
        for poly_index in range(len(shrunken_polygon)):
            length = len(list(shrunken_polygon[0].exterior.coords))
            if length>max_length:
                max_length = length
                index = poly_index
        x, y = shrunken_polygon[index].exterior.xy
    else:
        x, y = shrunken_polygon.exterior.xy
    return tuple(zip(x.tolist(), y.tolist()))

#main function
if __name__ == '__main__':     
    object_type = 1
    pcd = o3d.io.read_point_cloud("point_cloud.ply")
    boundary = numpy.asarray(pcd.points)
    print("Point cloud loaded with ",str(len(boundary))," vertices.")
    generate_mask(boundary,object_type,5)
    print("Mask generation completed.")