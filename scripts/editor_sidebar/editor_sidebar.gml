function editor_sidebar() constructor{
	width = round(display_get_gui_width() / 6) + 2;
	height = display_get_gui_height();
	
	background = c_dkgray;
	
	var scale = width / sprite_get_width(sToggle);
	var toggleButton = new button(width, sprite_get_height(sToggle) * scale, "test", fa_left);
	toggleButton.onClick = function(){
		
	};
	toggleButton.textOffsetX += 2 * scale;
	toggleButton.timer = 0;
	toggleButton.font = fntMain;
	toggleButton.background = noone;
	toggleButton.description = "";
	
	toggleButton.ifNot = function(){
		transparency = 1;
		alpha = 1;
	}
	
	toggleButton.onHover = function(){
		transparency = 0.85;	
		alpha = 0.95;
		
		timer += (delta_time / (1 / 60)) / 1000000;
	}
	
	toggleButton.onHold = function(){
		transparency = 0.65;	
		alpha = 1;
	}

	
	toggleButton.onStep = function(){
		draw_set_alpha(transparency);
		draw_sprite_stretched(sToggle, value, tx, ty, width, height);	
		draw_set_alpha(1);
	};
	
	content = copy_style(toggleButton, 1);
}