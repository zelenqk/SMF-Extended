function mouse_in_rectangle(tx, ty, width, height){
	for(var i = 0; i < 10; i++){
	
		var pir = point_in_rectangle(device_mouse_x_to_gui(i), device_mouse_y_to_gui(i),
		    tx, ty,
		    tx + width, ty + height);
		
		if (pir) return i;
	}
	
	return -1;
}
