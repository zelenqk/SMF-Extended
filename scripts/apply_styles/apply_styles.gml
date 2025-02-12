// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function apply_styles(style, strc_or_arr){
	if (is_array(strc_or_arr)){
		var names = variable_struct_get_names(style);
		
		for(var i = 0; i < array_length(strc_or_arr); i++){
			var struct = strc_or_arr[i];
			
			for(var u = 0; u < array_length(names); u++){
				struct[$ names[u]] = style[$ names[u]];
			}
		}
	}else{
		var names = variable_struct_get_names(style);

		for(var i = 0; i < array_length(names); i++){
			struct = strc_or_arr;
			
			struct[$ names[i]] = style[$ names[i]];
		}
	}
}