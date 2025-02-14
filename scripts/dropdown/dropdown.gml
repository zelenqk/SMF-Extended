// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function dropdown(width, height, text, icon, content = []) constructor{
	self.width = width;
	self.height = height;
	foldedHeight = height;
	expandedHeight = height;
	background = c_dkgray;
	
	drawContent = false;
	direction = column;
	
	for(var i = 0; i < array_length(content); i++){
		var next = draw_container(content[i]);
		
		expandedHeight += next.height;
	}
	
	self.content = content;
	contentOffsetY = height;
	
	step = function(){
		if (mouse_check_button_pressed(mb_left) and hovering){
			drawContent = !drawContent;
		}
	}
}