/// @description combine_textures()
function combine_textures() {
	/*
	var extendEdges = TexpageExtendEdges;
	var maxSize = TexpageMaxSize;

	//GPU settings
	matrix_set(matrix_view, matrix_build_identity());
	matrix_set(matrix_world, matrix_build_identity());
	gpu_set_zwriteenable(false);
	gpu_set_cullmode(cull_noculling);
	gpu_set_blendmode_ext(bm_one, bm_zero);
	gpu_set_texrepeat(false);
	draw_set_color(c_white);
	draw_set_alpha(1);

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Index batched models
	var priority, modelIndex, matArray, modArray, matInd, texInd, nomInd, Visible, matNum, nomDefault, tex, texW, texH, sepTexPage;
	var textureList;
	var texPagePriority = ds_priority_create();
	var compiledTexMap = ds_map_create();
	var spriteName = string_replace_all(editorModelName, " ", "");

	//Tesselate model and index textures
	for (var m = 0; m < array_length(animationModelList); m ++){
		if !modelVisible[m]{continue;}
		var texName = editorTextureIndex[m];
		if string_count(editorModelName, texName){
			newName = "Tex" + string(irandom(99999999));
			editorTextureMap[? newName] = editorTextureMap[? texName];
			ds_map_delete(editorTextureMap, texName);
			for (var mm = 0; mm < array_length(animationModelList); mm ++){
				if editorTextureIndex[m] == texName{
					editorTextureIndex[m] = newName;}}
			texName = newName;}
		//tesselate_uvs(m, false);
		var material = editorMaterialIndex[m];
		if is_undefined(ds_priority_find_priority(texPagePriority, texName)){
			var tex = editorTextureMap[? texName];
			ds_priority_add(texPagePriority, texName, sprite_get_width(tex) + sprite_get_height(tex));}}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Create texture pages
	texNum = ds_priority_size(texPagePriority);
	if texNum > 0
	{
		var image_list, texPages, texName, tex, texPageW, texPageH, freeSpace, expandAxis;
		image_list = ds_list_create();
		texPages = 1;
		texName = ds_priority_find_max(texPagePriority);
		tex = editorTextureMap[? texName];
		texPageW[0] = sprite_get_width(tex) + 2*extendEdges;
		texPageH[0] = sprite_get_height(tex) + 2*extendEdges;
		freeSpace[0] = ds_list_create();
		ds_list_add(freeSpace[0], 0, 0, texPageW[0], texPageH[0]);

		//Create necessary data structures
		while ds_priority_size(texPagePriority)
		{		
			texName = ds_priority_delete_max(texPagePriority);
			tex = editorTextureMap[? texName];
			texW = sprite_get_width(tex) + 2*extendEdges;
			texH = sprite_get_height(tex) + 2*extendEdges;
			texWritten = false;
			//Loop through existing texture pages to see if the sprite can be fit in somewhere
			for (var i = 0; i < texPages; i ++)
			{
				var num = ds_list_size(freeSpace[i]);
				for (var n = 0; n < num; n += 4)
				{
					spaceLeft = ds_list_find_value(freeSpace[i], n);
					spaceUpper = ds_list_find_value(freeSpace[i], n+1);
					spaceRight = ds_list_find_value(freeSpace[i], n+2);
					spaceLower = ds_list_find_value(freeSpace[i], n+3);
				
					spaceW = spaceRight - spaceLeft;
					spaceH = spaceLower - spaceUpper;
					//If the sprite fits in the free space, great! We can end the search process here then
					if spaceW >= texW and spaceH >= texH
					{
						ds_list_add(image_list, texName, i, spaceLeft + extendEdges, spaceUpper + extendEdges);
						texWritten = true;
						repeat 4{ds_list_delete(freeSpace[i], n);}
						if texW < spaceW{ds_list_add(freeSpace[i], spaceLeft + texW, spaceUpper, spaceRight, spaceUpper + texH);}
						if texH < spaceH{ds_list_add(freeSpace[i], spaceLeft, spaceUpper + texH, spaceRight, spaceLower);}
						break;
					}
				}
				if texWritten{break;}
			
				//The sprite does not fit in any of the free areas. We need to expand!
				if texPageH[i] >= texPageW[i]{
					//First, search through and see if any free regions can be expanded just slightly to fit the sprite
					num = ds_list_size(freeSpace[i]);
					for (var n = 0; n < num; n += 4){
						spaceLeft = ds_list_find_value(freeSpace[i], n);
						spaceUpper = ds_list_find_value(freeSpace[i], n+1);
						spaceRight = ds_list_find_value(freeSpace[i], n+2);
						spaceLower = ds_list_find_value(freeSpace[i], n+3);
						spaceH = spaceLower - spaceUpper;
						if (spaceRight >= texPageW[i] and spaceH >= texH){
							spaceRight = spaceLeft + texW;
							if spaceRight > maxSize{break;}
							//Expand free areas
							for (var nn = 0; nn < ds_list_size(freeSpace[i]); nn += 4){
								var __Right = ds_list_find_value(freeSpace[i], nn+2);
								if (__Right == texPageW[i]){
									ds_list_set(freeSpace[i], nn+2, spaceRight);}}
							//Create new free areas where sprites touch the old border
							for (var nn = 0; nn < ds_list_size(image_list); nn += 4){
								if image_list[| nn+1] != i{continue;}
								var __texName = image_list[| nn];
								var __tex = editorTextureMap[? __texName];
								var __Right = image_list[| nn+2] + sprite_get_width(__tex) + extendEdges;
								if (__Right <= texPageW[i] - 1){continue;}
								ds_list_add(freeSpace[i], __Right, image_list[| nn+3] - extendEdges, spaceRight, image_list[| nn+3] + sprite_get_height(__tex) + extendEdges);}
							//Resize texpage
							texPageW[i] = spaceRight;
							//Add sprite to texpage
							ds_list_add(image_list, texName, i, spaceLeft + extendEdges, spaceUpper + extendEdges);
							texWritten = true;
							repeat 4{ds_list_delete(freeSpace[i], n);}
							//Add free space below the sprite
							if texH < spaceH{ds_list_add(freeSpace[i], spaceLeft, spaceUpper + texH, spaceRight, spaceLower);}
							break;}}
					if !texWritten{
						//If no regions could be expanded, we'll have to expand in the entire width of the sprite
						if texPageW[i] + texW > maxSize{continue;}
						texWritten = true;
						ds_list_add(image_list, texName, i, texPageW[i] + extendEdges, extendEdges);
						if texH < texPageH[i]{ds_list_add(freeSpace[i], texPageW[i], texH, texPageW[i] + texW, texPageH[i]);}
						texPageW[i] += texW;
						}
					}
				else{
					//First, search through and see if any free regions can be expanded just slightly to fit the sprite
					num = ds_list_size(freeSpace[i]);
					for (var n = 0; n < num; n += 4){
						spaceLeft = ds_list_find_value(freeSpace[i], n);
						spaceUpper = ds_list_find_value(freeSpace[i], n+1);
						spaceRight = ds_list_find_value(freeSpace[i], n+2);
						spaceLower = ds_list_find_value(freeSpace[i], n+3);
						spaceW = spaceRight - spaceLeft;
						if (spaceLower >= texPageH[i] and spaceW >= texW){
							spaceLower = spaceUpper + texH;
							if spaceLower > maxSize{break;}
							//Expand free areas
							for (var nn = 0; nn < ds_list_size(freeSpace[i]); nn += 4){
								var __Lower = ds_list_find_value(freeSpace[i], nn+3);
								if (__Lower == texPageH[i]){
									ds_list_set(freeSpace[i], nn+3, spaceLower);}}
							//Create new free areas where sprites touch the old border
							for (var nn = 0; nn < ds_list_size(image_list); nn += 4){
								if image_list[| nn+1] != i{continue;}
								var __texName = image_list[| nn];
								var __tex = editorTextureMap[? __texName];
								var __Lower = image_list[| nn+3] + sprite_get_height(__tex) + extendEdges;
								if (__Lower <= texPageH[i] - 1){continue;}
								ds_list_add(freeSpace[i], image_list[| nn+2] - extendEdges, __Lower, image_list[| nn+2] + sprite_get_width(__tex) + extendEdges, spaceLower);}
							//Resize texpage
							texPageH[i] = spaceLower;
							//Add sprite to texpage
							ds_list_add(image_list, texName, i, spaceLeft + extendEdges, spaceUpper + extendEdges);
							texWritten = true;
							repeat 4{ds_list_delete(freeSpace[i], n);}
							if texW < spaceW{ds_list_add(freeSpace[i], spaceLeft + texW, spaceUpper, spaceRight, spaceLower);}
							break;}}
					if !texWritten{
						//If no regions could be expanded, we'll have to expand in the entire height of the sprite
						if texPageH[i] + texH > maxSize{continue;}
						texWritten = true;
						ds_list_add(image_list, texName, i, extendEdges, texPageH[i] + extendEdges);
						if texW < texPageW[i]{ds_list_add(freeSpace[i], texW, texPageH[i], texPageW[i], texPageH[i] + texH);}
						texPageH[i] += texH;
						}
					}
				if texWritten{break;}
			}
			if !texWritten
			{
				ds_list_add(image_list, texName, texPages, extendEdges, extendEdges);
				texPageW[texPages] = sprite_get_width(tex) + 2*extendEdges;
				texPageH[texPages] = sprite_get_height(tex) + 2*extendEdges;
				freeSpace[texPages] = ds_list_create();
				texPages ++;
				texWritten = true;
			}
		}
	
		gpu_set_blendmode(bm_normal)
		//Create surface
		for (var i = 0; i < texPages; i ++)
		{
			var s = surface_create(texPageW[i], texPageH[i]);
			surface_set_target(s);
			draw_clear_alpha(c_white, 0);
			//Draw sprites to surface
			for (var t = 0; t < ds_list_size(image_list); t += 4)
			{
				if image_list[| t+1] != i{continue;}
				texName = image_list[| t];
				tex = editorTextureMap[? texName];
				texExtendEdgesX = extendEdges / sprite_get_width(tex);
				texExtendEdgesY = extendEdges / sprite_get_height(tex);
				draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(tex, 0));
				texUVs = texture_get_uvs(sprite_get_texture(tex, 0));
				texUVs[2] = texture_get_width(sprite_get_texture(tex, 0));
				texUVs[3] = texture_get_height(sprite_get_texture(tex, 0));
				draw_vertex_texture(image_list[| t+2]-extendEdges, image_list[| t+3]-extendEdges, texUVs[0] - texUVs[2] * texExtendEdgesX, texUVs[1] - texUVs[3] * texExtendEdgesY);
				draw_vertex_texture(image_list[| t+2]+sprite_get_width(tex)+extendEdges, image_list[| t+3]-extendEdges, texUVs[0] + texUVs[2] * (1+texExtendEdgesX), texUVs[1] - texUVs[3] * texExtendEdgesY);
				draw_vertex_texture(image_list[| t+2]-extendEdges, image_list[| t+3]+sprite_get_height(tex)+extendEdges, texUVs[0] - texUVs[2] * texExtendEdgesX, texUVs[1] + texUVs[3] * (1+texExtendEdgesY));
				draw_vertex_texture(image_list[| t+2]+sprite_get_width(tex)+extendEdges, image_list[| t+3]+sprite_get_height(tex)+extendEdges, texUVs[0] + texUVs[2] * (1+texExtendEdgesX), texUVs[1] + texUVs[3] * (1+texExtendEdgesY));
				draw_primitive_end();
			}
			//Draw free areas as white rectangles
			var num = ds_list_size(freeSpace[i]);
			for (var n = 0; n < num; n += 4)
			{
				spaceLeft = ds_list_find_value(freeSpace[i], n);
				spaceUpper = ds_list_find_value(freeSpace[i], n+1);
				spaceRight = ds_list_find_value(freeSpace[i], n+2);
				spaceLower = ds_list_find_value(freeSpace[i], n+3);
				draw_rectangle(spaceLeft, spaceUpper, spaceRight, spaceLower, true);
			}
			surface_reset_target();
			texName = spriteName + string(i);
			editorTextureMap[? texName] = sprite_create_from_surface(s, 0, 0, texPageW[i], texPageH[i], 0, 0, 0, 0);
			surface_free(s);
		}
	
		//Now, to combine the models that use the same textures and materials
		var tempModelList = ds_list_create();
	
		for (var m = 0; m < array_length(animationModelList); m ++)
		{
			if !modelVisible[m]{continue;}
			oldTexName[m] = editorTextureIndex[m];
			var t = ds_list_find_index(image_list, oldTexName[m]);
			if t < 0{continue;} //<-- If this texture hasn't been added to the texpage
		
			//Modify the UVs to fit the tex page
			var texPage, texX, texY, texW, texH, u, v, j;
			texPage = image_list[| t+1];
			texX = image_list[| t+2] / texPageW[texPage];
			texY = image_list[| t+3] / texPageH[texPage];
			texW = sprite_get_width(editorTextureMap[? oldTexName[m]]) / texPageW[texPage];
			texH = sprite_get_height(editorTextureMap[? oldTexName[m]]) / texPageH[texPage];
			for (j = 6 * 4; j < buffer_get_size(modelBufferList[m]); j += SMF_format_bytes)
			{
				u = clamp(buffer_peek(modelBufferList[m], j, buffer_f32), 0, 1);
				v = clamp(buffer_peek(modelBufferList[m], j+4, buffer_f32), 0, 1);
				buffer_poke(modelBufferList[m], j, buffer_f32, texX + texW * u);
				buffer_poke(modelBufferList[m], j+4, buffer_f32, texY + texH * v);
			}
		
			//If this object's material uses normal maps, create a texpage for the normal map
			var material = editorMaterialMap[? editorMaterialIndex[m]];
			if material[| SMF_mat.NormalMapEnabled]
			{
				var name = spriteName + string(texPage) + "Normal";
				s = surface_create(texPageW[texPage], texPageH[texPage]);
				surface_set_target(s);
				draw_clear(c_white);
				ind = editorTextureMap[? name];
				if !is_undefined(ind){
					draw_sprite(ind, 0, 0, 0);}
				texW = sprite_get_width(editorTextureMap[? oldTexName[m]]);
				texH = sprite_get_height(editorTextureMap[? oldTexName[m]]);
				texExtendEdgesX = extendEdges / texW;
				texExtendEdgesY = extendEdges / texH;
				texUVs = texture_get_uvs(sprite_get_texture(editorTextureMap[? material[| SMF_mat.NormalMap]], 0));
				texUVs[2] = texture_get_width(sprite_get_texture(editorTextureMap[? material[| SMF_mat.NormalMap]], 0));
				texUVs[3] = texture_get_height(sprite_get_texture(editorTextureMap[? material[| SMF_mat.NormalMap]], 0));
				draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(editorTextureMap[? material[| SMF_mat.NormalMap]], 0));
				draw_vertex_texture(image_list[| t+2]-extendEdges, image_list[| t+3]-extendEdges, texUVs[0] - texUVs[2] * texExtendEdgesX, texUVs[1] - texUVs[3] * texExtendEdgesY);
				draw_vertex_texture(image_list[| t+2]+sprite_get_width(tex)+extendEdges, image_list[| t+3]-extendEdges, texUVs[0] + texUVs[2] * (1+texExtendEdgesX), texUVs[1] - texUVs[3] * texExtendEdgesY);
				draw_vertex_texture(image_list[| t+2]-extendEdges, image_list[| t+3]+sprite_get_height(tex)+extendEdges, texUVs[0] - texUVs[2] * texExtendEdgesX, texUVs[1] + texUVs[3] * (1+texExtendEdgesY));
				draw_vertex_texture(image_list[| t+2]+sprite_get_width(tex)+extendEdges, image_list[| t+3]+sprite_get_height(tex)+extendEdges, texUVs[0] + texUVs[2] * (1+texExtendEdgesX), texUVs[1] + texUVs[3] * (1+texExtendEdgesY));
				draw_primitive_end();
				surface_reset_target();
			
				editorTextureMap[? name] = sprite_create_from_surface(s, 0, 0, texPageW[texPage], texPageH[texPage], 0, 0, 0, 0);
				surface_free(s);
				if !is_undefined(ind){
					sprite_delete(ind);}
			}
		
			//Combine vertex buffers using the same texture and material
			name = string(texPage) + "," + string(material);
			newInd = ds_list_find_index(tempModelList, name);
			if newInd < 0
			{
				animationModelList[m] = vertex_create_buffer_from_buffer(modelBufferList[m], SMF_format);
				vertex_freeze(animationModelList[m]);
				ds_list_add(tempModelList, name, m);
				editorTextureIndex[m] = spriteName + string(texPage);
			}
			else
			{
				mergeModel = tempModelList[| newInd + 1];
				//rig_merge_models(mergeModel, m);
				m --;
			}
		}
		//Update the normal map references
		for (var m = 0; m < array_length(animationModelList); m ++)
		{
			if !modelVisible[m]{continue;}
			var t = ds_list_find_index(image_list, oldTexName[m]);
			if t < 0{continue;} //<-- If this texture hasn't been added to the texpage
		
			//If this object's material uses normal maps, create a texpage for the normal map
			var material = editorMaterialMap[? editorMaterialIndex[m]];
			if material[| SMF_mat.NormalMapEnabled]{
				material[| SMF_mat.NormalMap] = spriteName + string(image_list[| t+1]) + "Normal";}
		}
		modeleditor_update_wireframe();
		buttons_update();
	}

/* end combine_textures */
}
