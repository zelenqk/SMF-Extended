/// @description texpack_load_mtl(fname, mtlNames)
/// @param fname
/// @param mtlNames
function texpack_load_mtl(fname, materials) {
	var texpack = array_create(array_length(materials), array_create(material.transmission, -1));
	var buffer = buffer_load(fname);
	
	if (buffer == -1){
		show_debug_message("Couldnt loat material list (mtl) " + string(fname));
		return texpack;	
	}
	
	var content = buffer_read(buffer, buffer_text);
	content = string_replace_all(content, "\r\n", "\n");
	
	var lines = string_split(content, "\n");
	var linesN = array_length(lines);
	
	var currentMaterial = 0;
	
	for(var i = 0; i < linesN; i++){
		var line = lines[i];
		
		var tokens = string_split(line, " ");
		
		switch (string_lower(tokens[0])){
		case "newmtl":		//find submodel's material index
			currentMaterial = array_get_index(materials, tokens[1]);
			if (currentMaterial == -1){
				currentMaterial = 0;
			}
			
			texpack[currentMaterial][material.name] = tokens[1];
			break;
		case "map_kd":		//diffuse
			texpack[currentMaterial][material.diffuse] = texpack_load_sprite(tokens[1]);
			break;
		case "map_ke":		//emission
			texpack[currentMaterial][material.emission] = texpack_load_sprite(tokens[1]);
			break;
		case "map_kn":		//normal
		case "map_bump":
			texpack[currentMaterial][material.normal] = texpack_load_sprite(tokens[1]);
			break;
		case "disp":		//displacement
			texpack[currentMaterial][material.displacement] = texpack_load_sprite(tokens[1]);
			break;
		case "map_pr":		//roughness
			texpack[currentMaterial][material.roughness] = texpack_load_sprite(tokens[1]);
			break;
		case "map_pm":		//metallic
			texpack[currentMaterial][material.metallic] = texpack_load_sprite(tokens[1]);
			break;
		case "map_ks":		//specular
			texpack[currentMaterial][material.specular] = texpack_load_sprite(tokens[1]);
			break;
		case "map_ns":		//glossiness
			texpack[currentMaterial][material.glossiness] = texpack_load_sprite(tokens[1]);
			break;
		case "map_ao":		//ambient occlusion
			texpack[currentMaterial][material.occlusion] = texpack_load_sprite(tokens[1]);
			break;
		case "map_ps":		//ambient occlusion
			texpack[currentMaterial][material.sheen] = texpack_load_sprite(tokens[1]);
			break;
		case "map_tr":		//transmission
			texpack[currentMaterial][material.transmission] = texpack_load_sprite(tokens[1]);
			break;
		}
	}
	
	return texpack;
}
