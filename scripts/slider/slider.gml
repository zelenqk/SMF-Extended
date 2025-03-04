#macro defaultKnob {}

function slider(width, height, knobStyle = {}){
	self.width = width;
	self.height = height;
	
	vertical = (height > width);
	value = 0;
	
	step = function(){
		if (hover){
			if (mouse_check_button_pressed(mb_any)){
				knob.tx = device_mouse_x_to_gui(mouse) * !vertical;	
				knob.ty = device_mouse_y_to_gui(mouse) * vertical;
				
				var val = (vertical) ? knob.ty : knob.tx;
				var lb = (vertical) ? ty : tx;
				var ub = (vertical) ? height : width;
				
				value = map_value(val, lb, lb + ub, 0, 1);
			}
		}
		
		if (vertical){
			var space = height * value;
			knob.ty = ty + space;
		}else{
			var space = width * value;
			knob.tx = tx + space;
		}
	}
}