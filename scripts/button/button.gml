function button(width, height, text) constructor{
	self.width = width;
	self.height = height;
	self.text = text;
	
	textOffsetX = width / 2;
	textOffsetY = height / 2;
	
	halign = fa_center;
	valign = fa_center;
	
	background = c_black;
	
	onClick = function(){
		
	}
	
	onHold = function(){
		background = c_gray;	
	}
	
	onHover = function(){
		background = c_dkgray;
	}
	
	ifNot = function(){
		background = c_black;
	}
	
	step = function(){
		if (hover){
			onHover();
			
			if (mouse_check_button_pressed(mb_any)) onClick();
			if (mouse_check_button(mb_any)) onHold();
		}else ifNot();
	}
}