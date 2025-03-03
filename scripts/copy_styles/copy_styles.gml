function copy_style(style, n = 1){
	var content = [];
	var names = variable_struct_get_names(style);
	var namesN = array_length(names);
	
	for(var i = 0; i < n; i++){
		var struct = {};
		
		for(var u = 0; u < namesN; u++){
			var name = names[u];
			var variable = style[$ name];
			
			if (is_callable(variable)){
				struct[$ name] = method(struct, variable);
			}else{
				struct[$ name] = variable;
			}
		}
		
		content[array_length(content)] = struct;
	}
	
	return content;
}