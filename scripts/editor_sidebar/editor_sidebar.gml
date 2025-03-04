function editor_sidebar() constructor{
	width = (display_get_gui_width() / 6);
	minHeight = display_get_gui_height();
	display = flex;
	
	background = c_dkgray;
	
	//prepare some presets
	var scale = (width / sprite_get_width(sToggle));
	var toggleButton = new button(round(sprite_get_width(sToggle) * scale), round(sprite_get_height(sToggle) * scale), "Toggle ", fa_left);
	toggleButton.textOffsetX += 6 * scale;
	toggleButton.timer = 0;
	toggleButton.font = fntMain;
	toggleButton.value = true;
	toggleButton.background = noone;
	toggleButton.marginBottom = 2;
	toggleButton.description = "";
	toggleButton.ifNot = function(){
		transparency = 1;
		alpha = 1;
	}
	toggleButton.onHover = function(){
		transparency = 0.75;
		alpha = 0.95;
		
		timer += ((delta_time / (1 / 60)) / 1000000) / 100;
	}
	toggleButton.onHold = function(){
		transparency = 0.5;
		alpha = 1;
	}
	toggleButton.onStep = function(){
		draw_sprite_stretched(sToggle, value, tx, ty, width, height);	
	};
	toggleButton.fontEffects = {
		"outlineEnable": true,
		"outlineDistance": 3,
		"outlineColour": c_black,
		"outlineAlpha": 1,
	}
	
	//create settings wrapper
	var settingsHeader = {
		"background": noone,
		"direction": row,
		"marginV": 4,
		"font": fntMain,
		"display": flex,
		"content": [{
			"background": noone,
			"direction": row,
			"textOffsetX": 3,
			"fontSize": 24,
			"text": "Settings",
			"font": fntMain,
			"display": flex,	
		}]
	}
	
	var toggleSettings = copy_style(toggleButton, 10);
	toggleSettings[0].text += "3D wireframe";
	toggleSettings[1].text += "texture";
	toggleSettings[2].text += "culling";
	toggleSettings[3].text += "texture repeat";
	toggleSettings[4].text += "texture filter";
	toggleSettings[5].text += "grid";
	toggleSettings[6].text += "shader";
	toggleSettings[7].text = "Draw node indices";
	toggleSettings[8].text = "Node perspective";
	toggleSettings[9].text = "Draw rig";
	
	var toggleAll = {
		"display": flex,
		"text": "Toggle All",
		"toggle": toggleSettings,
		"settingsN": array_length(toggleSettings),
		"value": true,
		"step": function(){
			value = true;
			for(var i = 0; i < settingsN; i++){
				if (toggle[i].value == false) value = false;	
			}
			
			if (hover){
				if (device_mouse_check_button_pressed(mouse, mb_any)){
					for(var i = 0; i < settingsN; i++){
						toggle[i].value = !value;	
					}
				}
			}
			
			color = c_white * value;
		}
	}
	
	settingsHeader.content[1] = toggleAll;
	
	settings = {	//settings container wrapper
		"display": flex,
		"background": make_color_rgb(12, 12, 12),
		"content": [
			settingsHeader,
			toggleSettings,
		]
	}
	
	//assign subcontainers to the main (the sidebar) container
	content = [
		settings,	//the settings wrapper
	]
}