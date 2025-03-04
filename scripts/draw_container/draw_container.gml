function draw_container(container, tx = 0, ty = 0){
	if (container[$ "baked"] != true) bake_container(container);
	
	if (container.draw == false) return {
		"width": 0,
		"height": 0,
	}
	
	var bAlpha = draw_get_alpha();
	
	container.tx = tx + container.offsetX + container.marginLeft;
	container.ty = ty + container.offsetY + container.marginTop;
	
	if (container.display == flex){
		container.width = container.twidth;
		container.height = container.theight;	
	
		container.twidth = max(container.twidth, container.minWidth);
		container.theight = max(container.theight, container.minHeight);
		
		container.twidth = min(container.twidth, container.maxWidth);
		container.theight = min(container.theight, container.maxHeight);
	}
	
	if (container.hidden == false){
		container.boundary = {
			"x": container.tx,
			"y": container.ty,
			"width": container.width,
			"height": container.height,
		}
	}
	
	var bFont = draw_get_font();

	draw_set_alpha(container.transparency);
	if (container.background > -1) draw_rectangle_color(container.tx, container.ty, container.tx + container.width - 1, container.ty + container.height - 1, container.background, container.background, container.background, container.background, false);
	
	var startx = tx;
	var starty = ty;
	
	var scissor = gpu_get_scissor();
	if (container.overflow == fa_hidden){
		if (container.hidden){
			container.boundary.x = max(container.tx, container.boundary.x);
			container.boundary.y = max(container.ty, container.boundary.y);
			container.boundary.width = min(container.tx + container.width, container.boundary.x + container.boundary.width) - container.boundary.tx;	
			container.boundary.height = min(container.ty + container.height, container.boundary.y + container.boundary.height) - container.boundary.ty;
		}
		
		gpu_set_scissor(container.boundary.x, container.boundary.y, container.boundary.width, container.boundary.height);
	}
	
	container.mouse = (mouse_in_rectangle(container.boundary.x, container.boundary.y, container.boundary.width, container.boundary.height));
	container.hover = (container.mouse > -1);
	
	switch(container.alignItems){
	case fa_center:
		startx += (container.width / 2) - container.twidth / 2;
		break;
	case fa_right:
		startx += (container.width) - container.twidth;
		break;
	}
	
	switch(container.justifyContent){
	case fa_center:
		starty += (container.height / 2) - container.theight / 2;
		break;
	case fa_bottom:
		starty += (container.height) - container.theight;
		break;
	}
	
	tx = startx;
	ty = starty;
	
	var t = draw_element(tx, ty, container, container.content);
		
	tx = t.tx;
	ty = t.ty;
		
	draw_set_font(container.font);
	container.step();
	
	draw_set_alpha(bAlpha);
	if (container.font != -1) font_enable_effects(container.font, true, container.fontEffects);

	var txtScale = (container.fontSize / string_height(container.text));
	var bhalign = draw_get_halign();
	var bvalign = draw_get_valign();
	
	draw_set_halign(container.halign);
	draw_set_valign(container.valign);
	
	draw_text_transformed_color(container.tx + container.textOffsetX, container.ty + container.textOffsetY,
								container.text, txtScale, txtScale, 0,
								container.color, container.color, container.color, container.color, container.alpha);
	
	draw_set_halign(bhalign);
	draw_set_valign(bvalign);
	if (container.font != -1) font_enable_effects(container.font, false, resetFontEffects);
	
	container.twidth = max(container.twidth, tx - startx, string_width(container.text) * txtScale);
	container.theight = max(container.theight, ty - starty, string_height(container.text) * txtScale);
	
	gpu_set_scissor(scissor);
	draw_set_font(bFont);
	
	return {
		"width": container.width + container.marginLeft + container.marginRight,	
		"height": container.height + container.marginTop + container.marginBottom,	
	}
}

function draw_element(tx, ty, container, element){
	if (is_array(element)) {
		var elmN = array_length(element);
		var hspacing = 0;
		var vspacing = 0;
		
		switch (container.alignItems){
		case fa_spacebetween:
			hspacing = (container.width - container.twidth) / (array_length(element));
			break;
		}

		for (var i = 0; i < elmN; i++) {
			var t = draw_element(tx, ty, container, element[i]);
			
			tx = t.tx + hspacing;
			ty = t.ty + vspacing;
		}
	}else{
		element.boundary = container.boundary;
		element.hidden = (container.overflow == fa_hidden or container.hidden);
		element.child = true;
		element.parent = container;

		var next = draw_container(element, tx, ty);

		switch (container.direction) {
		case column:
			ty += next.height;
			if (container.twidth < next.width) container.twidth = next.width;
			break;
		case row:
			tx += next.width;
			if (container.theight < next.height) container.theight = next.height;
			break;
		}
	}
	
	return {"tx": tx, "ty": ty};
}
