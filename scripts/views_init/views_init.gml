/// @description views_init()
function views_init() {
	globalvar borderX, borderY, camPos, camZoom, editWidth, editHeight;
	view_enabled = true;
	borderX = 128;
	borderY = 80;
	camPos = [0, 0, 0, 45, 30];
	camZoom = 1;
	var w = window_get_width();
	var h = window_get_height();
	editWidth = (w - borderX * 2) / 2;
	editHeight = (h - borderY) / 2;
	view_set_visible(0, true);
	view_set_wport(0, w);
	view_set_hport(0, h);
	for (var i = 1; i < 5; i ++)
	{
		view_set_visible(i, true);
		view_set_camera(i, camera_create());
		view_set_xport(i, borderX + editWidth * (i mod 2));
		view_set_yport(i, borderY + editHeight * ((i - 1) div 2));
		view_set_wport(i, editWidth);
		view_set_hport(i, editHeight);
	}
	//Initialize mouse movement
	mouseX = 0;
	mouseY = 0;
	mouseDx = 0;
	mouseDy = 0;
	mousePrevX = 0;
	mousePrevY = 0;
	mouseViewInd = 0;
	mouseWorldPrevPos[2] = 0;
	mouseWorldPos[2] = 0;
	mouseWorldVec[2] = 0;
	tooltipHover = noone;
	tooltipPrevHover = noone;
	scalePos[2] = 0;

	//The camTransform array defines how the 2D mouse position will be interpreted in each view
	//0 translates to x, 1 to y, 2 to z. 3 and 4 are special for the 3D view, and rotate the camera
	camTransform[1, 0] = 3;
	camTransform[1, 1] = 4;
	camTransform[2, 0] = 0;
	camTransform[2, 1] = 1;
	camTransform[3, 0] = 1;
	camTransform[3, 1] = 2;
	camTransform[4, 0] = 0;
	camTransform[4, 1] = 2;


}
