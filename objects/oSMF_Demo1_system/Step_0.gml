/// @description
/////////////////////////////////////////////////////////
//-------------------Delta time------------------------//
/////////////////////////////////////////////////////////
//Simulate 60 fps even though the framerate is unlimited
var timeStep = delta_time * 60 / 1000000;

/////////////////////////////////////////////////////////
//-------------------Move camera-----------------------//
/////////////////////////////////////////////////////////
camUpdateTimer += timeStep;
if (camUpdateTimer >= 1 || fps < 70) //Only update the mouse movement every 1/60th second
{
	var mousedx = window_mouse_get_x() - window_get_width() / 2;
	var mousedy = window_mouse_get_y() - window_get_height() / 2;
	window_mouse_set(window_get_width() / 2, window_get_height() / 2);
	camUpdateTimer = 0;
	camYaw += mousedx * .1;
	camPitch = clamp(camPitch - mousedy * .1, -80, -2);
}
var d = 40;
var camX = - d * dcos(camYaw) * dcos(camPitch);
var camY = - d * dsin(camYaw) * dcos(camPitch);
var camZ = - d * dsin(camPitch);
camera_set_view_mat(view_camera[0], matrix_build_lookat(camX, camY, camZ, 0, 0, 7, 0, 0, 1));

/////////////////////////////////////////////////////////
//-----------------Update instance---------------------//
/////////////////////////////////////////////////////////
mainInst.step(timeStep);