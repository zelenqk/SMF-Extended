// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function radio(width, height, array = [""], styles = {}) constructor{
	display = flex;
	direction = column;
	
	content = [];
	selected = array[0];
	
	var func = function(){
		if (hovering and mouse_check_button_pressed(mb_left)){
			for(var i = 0; i < array_length(parent.content); i++){
				parent.content[i].value = false;
			}
			
			parent.selected = text;
			value = true;
		}
	}
	
	for(var i = 0; i < array_length(array); i++){
		content[i] = new button(width, height, array[i]);
		apply_styles(styles, content[i]);
		content[i].value = (i == 0);
		
		content[i].onClick = method(content[i], func);
	}
}