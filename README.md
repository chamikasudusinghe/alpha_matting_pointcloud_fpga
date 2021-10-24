# alpha_matting_pointcloud_fpga
Point clouds represent data points of 3D objects in space. Generating an alpha matte for a camera perspective is an initial step of the 3D reconstruction of an object. Although there are various techniques to generate alpha mattes, one of the main issues is the time consumption due to having a large number of points in a 3D object. Hence utilizing an FPGA to do the required computation for alpha matte generation will drastically reduce the time consumed. In this project, we will compute the 2D points of the camera perspectives of a 3D point cloud. It will significantly improve the speed of the process of 3D reconstruction.
