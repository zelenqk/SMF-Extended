function editor_sidebar() constructor{
	width = (display_get_gui_width() / 6);
	minHeight = display_get_gui_height();
	display = flex;
	
	background = c_dkgray;
	
	//prepare some presets
	var toggleButton = new button(width, sprite_get_height(sToggle) * 2, "Toggle ", fa_left);
	toggleButton.textOffsetX += 6;
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
		var sprW = sprite_get_width(sToggle) * 2;
		var w = width - (sprW * 2)
		
		var a = draw_get_alpha();
		var selected = (value * 3);
		
		draw_sprite_ext(sToggle, selected + 0, tx, ty, 2, 2, 0, c_white, a);
		draw_sprite_ext(sToggle, selected + 2, tx + sprW + w, ty, 2, 2, 0, c_white, a);
		
		draw_sprite_stretched_ext(sToggle, selected + 1, tx + sprW, ty, w, sprite_get_height(sToggle) * 2, c_white, a);
		
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
		"font": fntMain,
		"width": width,
		"height": 32,
		"textOffsetX": 6,
		"fontSize": 24,
		"alignItems": fa_right,
		"justifyContent": fa_center,
		"text": "Settings",
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
		"text": "Toggle All",
		"toggle": toggleSettings,
		"settingsN": array_length(toggleSettings),
		"textOffsetX": 3,
		"font": fntMain,
		"paddingH": 6,
		"paddingV": 3,
		"background": -1,
		"display": flex,
		"value": true,
		"step": function(){
			value = true;
			
			for(var i = 0; i < settingsN; i++){
				if (toggle[i].value == false) value = false;	
			}
			
			if (hover){
				transparency = 0.85
				
				if (device_mouse_check_button_pressed(mouse, mb_any)){
					for(var i = 0; i < settingsN; i++){
						toggle[i].value = !value;	
					}
				}
				
				if (device_mouse_check_button(mouse, mb_any)){
					transparency = 0.5
				}
				
			}else{
				transparency = 1;
			}
			
			var sprW = sprite_get_width(sToggle);
			var sprH = sprite_get_height(sToggle);
			
			var scale = height / sprH;
			sprW *= scale;
			sprH *= scale;
			
			var w = width - (sprW * 2);

			paddingRight = sprW;
			
			var a = draw_get_alpha();
			var selected = (value * 3);
			
			draw_sprite_ext(sToggle, selected + 0, tx, ty, scale, scale, 0, c_white, a);
			draw_sprite_ext(sToggle, selected + 2, tx + sprW + w, ty, scale, scale, 0, c_white, a);
			
			draw_sprite_stretched_ext(sToggle, selected + 1, tx + sprW, ty, w, height, c_white, a);
		}
	}
	
	settingsHeader.content = toggleAll;
	
	//slider settings
	var rigOpacitySlider = new slider(width, width / 12, 1);
	var rigThicknessSlider = new slider(width, width / 12, 0.5);
	
	rigOpacitySlider.text = "Rig opacity - 1";
	
	rigOpacitySlider.onStep = function(){
		text = "Rig opacity - " + string(value);	
	}
	
	var sliderSettings = [rigOpacitySlider, rigThicknessSlider];
	
	settings = {	//settings container wrapper
		"display": flex,
		"background": make_color_rgb(12, 12, 12),
		"content": [
			//general settings
			settingsHeader,
			toggleSettings,
			sliderSettings
		]
	}
	
	//assign subcontainers to the main (the sidebar) container
	content = [
		settings,	//the settings wrapper
	]
}