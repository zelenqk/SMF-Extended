function draw_container(container, tx = 0, ty = 0){
	if (container[$ "baked"] != true) bake_container(container);
	
	if (container.draw == false) return {
		"width": 0,
		"height": 0,
	}
	
	var bAlpha = draw_get_alpha();
	
	container.tx = tx + container.offsetX;
	container.ty = ty + container.offsetY;
	
	if (container.display != flex){
		container.twidth = container.width;
		container.theight = container.height;
	}
	
	if (container.hidden == false){
		container.boundary = {
			"x": container.tx,
			"y": container.ty,
			"width": container.twidth,
			"height": container.theight,
		}
	}
	
	var blend = gpu_get_blendmode();
	var bFont = draw_get_font();
	

	draw_set_alpha(container.transparency);
	if (container.background >= 0) draw_rectangle_color(container.tx, container.ty, container.tx + container.width - 1, container.ty + container.height - 1, container.background, container.background, container.background, container.background, false);
	draw_set_alpha(bAlpha);

	
	draw_set_font(container.font);
	container.step();

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
	draw_set_font(bFont);

	var startx = tx;
	var starty = ty;
	
	var scissor = gpu_get_scissor();
	if (container.overflow == fa_hidden){
		if (container.hidden){
			container.boundary.x = max(container.tx, container.boundary.x);
			container.boundary.y = max(container.ty, container.boundary.y);
			container.boundary.width = min(container.tx + container.twidth, container.boundary.x + container.boundary.width) - container.boundary.tx;	
			container.boundary.height = min(container.ty + container.theight, container.boundary.y + container.boundary.height) - container.boundary.ty;
		}
		
		gpu_set_scissor(container.boundary.x, container.boundary.y, container.boundary.width, container.boundary.height);
	}
	
	container.hover = (mouse_in_rectangle(container.boundary.x, container.boundary.y, container.boundary.width, container.boundary.height));

	tx = startx;
	ty = starty;
	
	for(var i = 0; i < array_length(container.content); i++){
		container.content[i].boundary = container.boundary;
		container.content[i].hidden = (container.overflow == fa_hidden or container.hidden);
		
		var next = draw_container(container.content[i]);
		
		switch (container.direction){
		case column:
			ty += next.height;
			break;
		case row:
			tx += next.width;
			break;
		}
	}
	
	gpu_set_blendmode(blend);
	
	if (container.display == flex){
		container.twidth = tx - startx;
		container.theight = ty - starty;
	}
	
	gpu_set_scissor(scissor);
	
	return {
		"width": container.twidth,	
		"height": container.theight,	
	}
}