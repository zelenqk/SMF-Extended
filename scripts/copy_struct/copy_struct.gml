//link to forum page with this script https://forum.gamemaker.io/index.php?threads/how-to-copy-a-struct.82580/

function copy_struct(struct){	//from 31Nf4ChZ4H73N in GM forums thx 
    var key, value;
    var newCopy = {};
    var keys = variable_struct_get_names(struct);
	
    for (var i = 0; i < array_length(keys); i++) {
		key = keys[i];
		value = struct[$ key];
		
		if (is_method(value)) value = method(struct, value);
		
		newCopy[$ key] = value;
    }
	
    return newCopy;
}
