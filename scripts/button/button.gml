function button(width, height, text, halign = fa_center, valign = fa_center) constructor{
	self.width = width;
	self.height = height;
	self.text = text;
	self.halign = halign;
	self.valign = valign;
	
	value = 0;
	
	switch (halign){
	case fa_center:
		textOffsetX = width / 2;
		break;
	case fa_right:
		textOffsetX = width;
		break;
	}
	switch (valign){
	case fa_center:
		textOffsetY = height / 2;
		break;
	case fa_bottom:
		textOffsetY = height;
		break;
	}
	
	background = c_black;
	
	onClick = function(){
		
	}
	
	onStep = function(){
		
	}
	
	previous = noone;
	
	onHold = function(){
		background = c_gray;	
	}
	
	onHover = function(){
		background = c_dkgray;
	}
	
	ifNot = function(){
		if (previous != noone){
			previous = json_parse(previous);
			var names = variable_struct_get_names(previous);
			
			for(var i = 0; i < array_length(names); i++){
				var name = names[i];
				
				self[$ name] = previous[$ name];
			}
			
			previous = noone;
		}
	}
	
	step = function(){
		if (hover){
			if (previous = noone) previous = json_stringify(self);
			onHover();
			
			if (mouse_check_button_pressed(mb_any)) onClick();
			if (mouse_check_button(mb_any)) onHold();
		}else ifNot();
		
		onStep();
	}
}