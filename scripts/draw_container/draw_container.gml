function draw_container(container, tx = 0, ty = 0){
	if (container[$ "baked"] != true) bake_container(container);
	
	if (container.draw == false) return {
		"width": 0,
		"height": 0,
	}
	
	container.tx = 0;
	container.ty = 0;
	
	var startx = (container.overflow == fa_hidden) ? 0 : tx;
	var starty = (container.overflow == fa_hidden) ? 0 : ty;
	
	tx = startx;
	ty = starty;
	
	for(var i = 0; i < array_length(container.content); i++){
		var next = draw_container(container.content[i]);
		
		switch (container.direction){
		case row:
		
			break;
		}
	}
	
	return {
		"width": container.twidth,	
		"height": container.theight,	
	}
}