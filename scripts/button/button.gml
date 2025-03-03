function button(width, height, text, halign = fa_center, valign = fa_center) constructor{
	self.width = width;
	self.height = height;
	self.text = text;
	self.halign = halign;
	self.valign = valign;
	
	fontSize = height - (height / 3);
	
	value = 0;
	
	textOffsetX = 0;
	textOffsetY = 0;
	
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

	}
	
	step = function(){
		if (hover){
			onHover();
			
			if (mouse_check_button_pressed(mb_any)){
				value = !value;
				onClick();
			}
			
			if (mouse_check_button(mb_any)) onHold();
		}else ifNot();
		
		onStep();
	}
}