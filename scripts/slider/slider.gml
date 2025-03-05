#macro defaultKnob {}

function slider(width, height, defaultValue = 0, knobStyle = defaultKnob) constructor {
	self.width = width;
	self.height = height;
	
	vertical = (height > width);
	value = defaultValue;
	
	knob = knobStyle;
	
	var size = (vertical) ? width : height;
	knob.width = size;
	knob.height = size;
	
	background = c_white;
	content = knob;

	controlling = noone;
	
	onStep = function(){
		
	}
	
	onHover = function(){
		
	}
	
	onClick = function(){
		
	}
	
	onHold = function(){
		
	}

	step = function() {
		if (controlling != noone and device_mouse_check_button_released(controlling, mb_any)) controlling = noone;
		
		if (hover){
			onHover();
			
			if (device_mouse_check_button_pressed(mouse, mb_any) and controlling == noone){
				controlling = mouse;
				onClick();
			}
		}
		
		if (controlling != noone) {
			// Convert mouse position
			var mousex = device_mouse_x_to_gui(controlling);
			var mousey = device_mouse_y_to_gui(controlling);

			// Constrain the knob movement
			if (vertical) {
				knob.offsetY = clamp(mousey, ty, ty + height - knob.height);
				value = (knob.offsetY - ty) / (height - knob.height);
			}else{
				knob.offsetX = clamp(mousex, tx, tx + width - knob.width);
				value = (knob.offsetX - tx) / (width - knob.width);
			}
			
			onStep();
		}

		// Keep knob in the correct position
		if (vertical) {
			knob.offsetY = ty + (height - knob.height) * value;
		} else {
			knob.offsetX = tx + (width - knob.width) * value;
		}
	};
}
