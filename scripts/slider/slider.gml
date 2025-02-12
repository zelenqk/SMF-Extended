// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function slider(width, height, text = "", defaultValue = 1, minVal = 0, maxVal = 1, moveOnClick = true) constructor{
	self.width = width;
	self.height = height;
	self.text = text;
	
	fontSize = height - 6;
	font = fntMain;
	
	value = defaultValue;
	horizontal = (width > height);
	self.minVal = minVal;
	self.maxVal = maxVal;
	self.moveOnClick = moveOnClick;
	
	knob = {
		"width": width / 12,
		"height": height,
		"background": c_black,
		"active": false,
		"mouseOffset": 0,
		"step": function(){
			if (active){
				if (parent.horizontal) offsetx = device_mouse_x_to_gui(0) - mouseOffset;
				else offsety = device_mouse_y_to_gui(0) - mouseOffset;
				
				if (parent.horizontal) offsetx = clamp(offsetx, 0, parent.width - width);
				else offsety = clamp(offsety, height, parent.height - height);
			
				if (mouse_check_button_released(mb_left)){
					active = false;
				}
				
				if (parent.horizontal) parent.value = map_value(parent.value, 0, parent.width - width, parent.minVal, parent.maxVal);
				else parent.value = map_value(parent.value, 0, parent.height - height, parent.minVal, parent.maxVal);
			}
			
			if (hovering and mouse_check_button_pressed(mb_left)){
				active = true;
				
				if (parent.horizontal) mouseOffset = device_mouse_x_to_gui(0) - tx;
				else mouseOffset = device_mouse_y_to_gui(0) - ty;
			}
		}
	}
	
	if (horizontal) knob.offsetx = map_value(value, minVal, maxVal, 0, width - knob.width);
	else knob.offsety = map_value(value, minVal, maxVal, 0, height - knob.height);
	
	step = function(){
		if (mouse_check_button_pressed(mb_left) and moveOnClick == true and hovering){
			if (horizontal) value = map_value(value, 0, width - knob.width, minVal, maxVal);
			else value = map_value(value, 0, height - knob.height, minVal, maxVal);
		}
	}
	
	content = [
		knob
	];
	
}