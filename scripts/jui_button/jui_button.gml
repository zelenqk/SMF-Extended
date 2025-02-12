// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function jui_button(width, height, text, toggle = true, halign = fa_left) constructor {
	self.width = width;
	self.height = height;
	self.toggle = toggle;
	self.text = text;
	
	self.halign = halign;
	valign = fa_center;
	
	fontSize = (height - height / 6);
	font = fntMain;
	onClick = function(){
			
	}
	
	value = true;
	
	color = c_white;
	fontEffects = {
		"dropShadowEnable": true,
		"dropShadowSoftness": 16,
	}
	
	onStep = function(){
			
	}
	
	unselectedColor = make_color_rgb(32, 32, 32);
	selectedColor = make_color_rgb(64, 64, 64);
	background = selectedColor;
	padding = height / 6;
	textOffsetX = padding

	step = function(){
		alpha = 1;
		if (value) background = selectedColor;
		else if (toggle) background = unselectedColor;
		
		if (toggle){
			var col = draw_get_color();
			draw_set_color(c_yellow);
			draw_roundrect_ext(tx + twidth - theight + padding, ty + padding, twidth - padding, ty + theight - padding, height, height, !value);	
			draw_set_color(col);
		}
		
		if (hovering){
			if (value) alpha = 0.75;
			else{
				alpha = 0.5;
				if (toggle) background = unselectedColor;
			}
			
			if (mouse_check_button(mb_any)){
				alpha -= 0.15;	
			}
			
			if (mouse_check_button_pressed(mb_any)){
				value = !value;
				
				if (toggle){
					if (value) background = selectedColor;
					else background = unselectedColor;
				}
				
				onClick();
			}
		}
		
		onStep();
	}
}