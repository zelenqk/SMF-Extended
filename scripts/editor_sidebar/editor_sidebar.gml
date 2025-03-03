function editor_sidebar() constructor{
	width = round(display_get_gui_width() / 6) + 2;
	height = display_get_gui_height();
	
	background = c_dkgray;
	
	//prepare some presets
	var scale = width / sprite_get_width(sToggle);
	var toggleButton = new button(width, sprite_get_height(sToggle) * scale, "Toggle ", fa_left);
	toggleButton.onClick = function(){
		
	};
	toggleButton.textOffsetX += 6 * scale;
	toggleButton.timer = 0;
	toggleButton.font = fntMain;
	toggleButton.background = noone;
	toggleButton.marginBottom = 2;
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
	
	//create settings wrapper
	var settingsHeader = {
		"background": noone,
		"text": "Settings",
		"fontEffects": {
			"outlineEnable": true,
			"outlineDistance": 2,
			"outlineColour": c_black	
		},
		"textOffsetX": 3,
		"marginBottom": 3,
		"fontSize": 32,
		"font": fntMain,
		"display": flex,
	}
	
	var toggleSettings = copy_style(toggleButton, 3);
	toggleSettings[0].text += "wireframe";
	toggleSettings[1].text += "culling";
	toggleSettings[2].text += "shader";
	
	array_insert(toggleSettings, 0, settingsHeader);
	
	settings = {	//settings container wrapper
		"display": flex,
		"content": array_concat(toggleSettings, []),
		"background": make_color_rgb(12, 12, 12),
	}
	
	//assign subcontainers to the main (the sidebar) container
	content = [
		settings,	//the settings wrapper
	]
}