function draw_container(container, tx = 0, ty = 0){
	if (container[$ "baked"] == undefined) container = bake_container(container);
	if (container.draw == false) return {
		"width": 0,
		"height": 0,
	}
	
	var bColor = draw_get_color();
	var bAlpha = draw_get_alpha();
	var bFont  = draw_get_font();
	
	var bHalign = draw_get_halign();
	var bValign = draw_get_valign();
	
	container.tx = tx + container.offsetx + container.marginLeft;
	container.ty = ty + container.offsety + container.marginTop;
	
	if (container.display = fixed){
		container.twidth = container.width;
		container.theight = container.height;
	}else{
		container.width = container.twidth;
		container.height = container.theight;
	}	
	
	if (container.wrapped == false){
		container.boundaries = {
			"x": container.tx, 	
			"y": container.ty, 	
			"width": container.twidth, 	
			"height": container.theight, 	
		}
	}
	
	if (container.background != noone){
		draw_set_color(container.background);
		draw_set_alpha(container.alpha);
		
		draw_rectangle(container.tx, container.ty, container.tx + container.twidth - 1, container.ty + container.theight - 1, false);
		draw_set_alpha(bAlpha);
	}
	
	//collision detection
	var x1 = container.tx;
	var y1 = container.ty;
	var x2 = x1 + container.twidth;
	var y2 = y1 + container.theight;
	
	if (container.wrapped){
		x1 = clamp(x1,  container.boundaries.x, container.boundaries.x + container.boundaries.width);
		y1 = clamp(y1,  container.boundaries.y, container.boundaries.y + container.boundaries.height);
		
		x2 = clamp(x2,  container.boundaries.x, container.boundaries.x + container.boundaries.width);
		y2 = clamp(y2,  container.boundaries.y, container.boundaries.y + container.boundaries.height);
	}
	
	var pir = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x1, y1, x2, y2);
	container.hovering = pir;
	
	if (is_method(container[$ "step"])) container.step();
	
	var childN = array_length(container.content) * container.drawContent;
	var startx = container.tx;
	var starty = container.ty;
	
	var cx = container.tx;
	var cy = container.ty;
	
	for(var i = 0; i < childN; i++){
		var subContainer = container.content[i];
		subContainer.wrapped = true;
		subContainer.boundaries = container.boundaries;
		subContainer.parent = container;
		
		var next = draw_container(subContainer, cx, cy);
		
		if (container.direction == row){
			cx += next.width;	
		}else{
			cy += next.height;	
		}
	}
	
	//draw text
	var textx = container.tx + container.textOffsetX;
	var texty = container.ty + container.textOffsetY;
	
	draw_set_color(container.color);
	draw_set_font(container.font);
	
	var textScale = (container.fontSize / string_height(container.text));
	
	switch (container.halign){
	case fa_center:
		textx += (container.twidth / 2) - (string_width(container.text) * textScale) / 2;
		break;
	case fa_right:
		textx += container.twidth - (string_width(container.text) * textScale);
		break;
	}
	
	switch (container.valign){
	case fa_center:
		texty += (container.theight / 2) - (string_height(container.text) * textScale) / 2;
		break;
	case fa_right:
		texty += container.theight - (string_height(container.text) * textScale);
		break;
	}
	
	if (font_exists(container.font)) font_enable_effects(container.font, true, container.fontEffects);
	draw_text_transformed(textx, texty, container.text, textScale, textScale, 0);
	if (font_exists(container.font)) font_enable_effects(container.font, false);

	if (container.display == flex){
		container.twidth = cx - startx;	
		container.theight = cy - starty;	
	}

	draw_set_color(bColor);
	draw_set_alpha(bAlpha);
	draw_set_font(bFont);
	
	draw_set_halign(bHalign);
	draw_set_valign(bValign);
	
	return {
		"width": (container.marginLeft + container.twidth + container.marginRight) * (container.position == relative),
		"height": (container.marginTop + container.theight + container.marginBottom) * (container.position == relative),
	}
}