/// @description window_resize()
function window_resize() {
	screenWidth = window_get_width();
	screenHeight = window_get_height();
	if screenWidth <= 0 or screenHeight <= 0{exit;}
	if (screenWidth == surface_get_width(application_surface) && screenHeight == surface_get_height(application_surface)){exit;}

	surface_resize(application_surface, screenWidth, screenHeight);
	display_set_gui_size(screenWidth, screenHeight);
	view_set_wport(0, screenWidth);
	view_set_hport(0, screenHeight);
	
	//Update the smaller windows
	editWidth = (screenWidth - borderX * 2) / 2;
	editHeight = (screenHeight - borderY) / 2;
	for (var i = 1; i < 5; i ++)
	{
		view_set_xport(i, borderX + editWidth * (i mod 2));
		view_set_yport(i, borderY + editHeight * ((i - 1) div 2));
		view_set_wport(i, editWidth);
		view_set_hport(i, editHeight);
	}
	
	move_camera();
	buttons_update();
	
	//Update timeline size
	edtTmlPos = [borderX + 128, borderY - 32, borderX + editWidth * 2 - 16, borderY];



}
