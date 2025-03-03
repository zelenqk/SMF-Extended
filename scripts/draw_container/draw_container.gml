function draw_container(container, tx = 0, ty = 0){
	if (container[$ "baked"] != true) bake_container(container);
	
	if (container.draw == false) return {
		"width": 0,
		"height": 0,
	}
	
	container.tx = tx + container.offsetX;
	container.ty = ty + container.offsetY;
	
	if (container.overflow == fa_hidden and hidden == false){
		container.boundary = {
			"x": container.tx,
			"y": container.ty,
			"width": container.twidth,
			"height": container.theight,
		}
	}
	
	var blend = gpu_get_blendmode();
	container.step();
	
	draw_set_alpha(container.transparency);
	if (container.background >= 0) draw_rectangle_color(container.tx, container.ty, container.tx + container.width, container.ty + container.height, container.background, container.background, container.background, container.background, false);
	draw_set_alpha(bAlpha);

	var txtScale = (string_height(container.text) / container.fontSize);
	
	draw_text_transformed_color(container.tx + container.textOffsetX, container.ty + container.textOffsetY,
								container.text, txtScale, txtScale, 0,
								container.color, container.color, container.color, container.color, container.alpha);
	
	container.hover = mouse_in_rectangle(container.boundary.x, container.boundary.y,
		container.boundary.x + container.boundary.width,
		container.boundary.y + container.boundary.height,
	) != noone;
	
	var startx = tx;
	var starty = ty;
	
	var scissor = gpu_get_scissor();
	if (container.overflow == fa_hidden){
		if (container.hidden){
			container.boundary.x = max(container.tx, container.boundary.x);
			container.boundary.y = max(container.ty, container.boundary.y);
			container.boundary.width = min(container.tx + container.twidth, container.boundary.x + container.boundary.width) - container.boundary.x;	
			container.boundary.height = min(container.ty + container.theight, container.boundary.y + container.boundary.height) - container.boundary.y;
		}
		
		gpu_set_scissor(container.boundary.x, container.boundary.y, container.boundary.width, container.boundary.height);
	}

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