/// @description modeleditor_press_buttons()
function modeleditor_press_buttons() {
	/*
	Checks for button presses in the model editor tab
	*/

	//Model settings
	var model = -1;
	if (edtSMFSel >= 0)
	{
		model = edtSMFArray[edtSMFSel];
		var mBuff = model.mBuff;
		var vBuff = model.vBuff;
		var vis = model.vis;
		var texPack = model.texPack;
		var wire = model.Wire;
		var selList = model.SelModelList;
		var selNode = model.SelNode;
		var animArray = model.animations;
		var selAnim = model.SelAnim;
		var selKeyframe = model.SelKeyframe;
		var rig = model.rig;
	}

	//Move sliders
	if selectedSlider >= 0
	{
		var sliderValue = median((window_mouse_get_x() - (selectedSlider.x + 5)) / (127 - 10), 0, 1);
		switch selectedSlider.handle
		{
			case "TEXPAGEMAXSIZE":
				TexpageMaxSize = power(2, 4 + round(sliderValue * 8));
				settings_update();
				break;
			case "TEXPAGEEXTEND":
				TexpageExtendEdges = floor(sliderValue * 10);
				settings_update();
				break;
		}
	}

	//Various exit conditions
	if !mouse_check_button_pressed(mb_left){exit;}
	if edtSelButton < 0 || !instance_exists(edtSelButton){exit;}
	if edtSelButton.sprite_index == sCategory{exit;}

	//Check if the pressed button is a tool
	if string_count("TOOL", edtSelButton.handle) > 0
	{
		selectedTool = real(string_delete(edtSelButton.handle, 1, 4));
		edtModSelTool = selectedTool;
		edtSelButton = -1;
		exit;
	}

	//Switch through the possible buttons
	switch edtSelButton.handle
	{
		//Saving and loading
		case "ADDMODEL":
		case "LOADMODEL":
			var file = get_open_filename("Model files (obj, zip, smf, mbuff)|*.obj;*.mbuff;*.zip;*.smf;*.sbf", "");
			if file == ""{break;}
			var handle = edtSelButton.handle;
			undo_save("Load model", edtUndoType.Everything);
			file = string_lower(file);
			var ext = filename_ext(file);
			if (ext == ".fbx")
			{
				editor_show_message("FBX is not supported at this time");
			}
			if (handle == "LOADMODEL" || edtSMFSel < 0)
			{
				edtModelName = string_copy(filename_name(file), 1, string_length(filename_name(file)) - 4);
				var model = edt_smf_create_model();
				var mBuff = model.mBuff;
				var vBuff = model.vBuff;
				var vis = model.vis;
				var texPack = model.texPack;
				var wire = model.Wire;
				var selList = model.SelModelList;
				var selNode = model.SelNode;
				var animArray = model.animations;
				var selAnim = model.SelAnim;
				var selKeyframe = model.SelKeyframe;
				var rig = model.rig;
				edtSMFSel = array_length(edtSMFArray);
				edtSMFArray[edtSMFSel] = model;
			}
			if ext == ".zip"
			{
				var obj = mbuff_load_zip_ext(file, true);
				if !is_array(obj){break;}
				mBuff = mbuff_add(mBuff, obj[0]);
				model.mBuff = mBuff;
				model.vis = array_create(array_length(model.mBuff), 1);
				texpack_add_texpack(texPack, obj[1]);
			}
			else if ext == ".obj"
			{
				edtSavePath = "";
				var obj = mbuff_load_obj_from_buffer(buffer_load(file), true);
				if !is_array(obj){break;}
				mBuff = mbuff_add(mBuff, obj[0]);
				model.mBuff = mBuff;
				model.vis = array_create(array_length(model.mBuff), 1);
				texpack_add_texpack(texPack, obj[1]);
			}
			else if ext == ".mbuff"
			{
				//When loading a file with the extension .mbuff, it will attempt to load all files in the folder
				edtSavePath = file;
				var folder = filename_path(file);

				//Load model buffer
				var loadBuff = buffer_load(file);
				mBuff = mbuff_add(mBuff, mbuff_read_from_buffer(loadBuff));
				model.mBuff = mBuff;
				model.vis = array_create(array_length(model.mBuff), 1);
				buffer_delete(loadBuff);
			
				//Load textures
				var num = 0;
				var spr = sprite_add(filename_change_ext(file, "_" + string(num) + ".png"), 1, 0, 0, 0, 0);
				var newTexPack = [];
				while (spr >= 0)
				{
					newTexPack[num] = spr;
					spr = sprite_add(filename_change_ext(file, "_" + string(++num) + ".png"), 1, 0, 0, 0, 0);
				}
				if (num == 0)
				{
					newTexPack = array_create(array_length(mBuff), sprite_duplicate(texWhite));
				}
				texpack_add_texpack(texPack, newTexPack);
			
				//Load rig
				var loadBuff = buffer_load(filename_change_ext(file, ".rig"));
				if loadBuff >= 0
				{
					model.rig = rig_read_from_buffer(loadBuff);
					buffer_delete(loadBuff);
				
					//Load animations
					var file = file_find_first(folder + "*.anim", 0);
					while file != ""
					{
						loadBuff = buffer_load(folder + file);
						animArray[@ array_length(animArray)] = anim_read_from_buffer(loadBuff);
						buffer_delete(loadBuff);
						file = file_find_next();
					}
				}
			}
			else if ext == ".smf"
			{
				edtSavePath = file;
				rig_delete(model.rig);
				var smf = smf_model_load(file);
				if is_struct(smf)
				{
					model.rig = smf.rig;
					var _texArray = smf.texPack;
					var _mBuffArray = smf.mBuff;
					var _vBuffArray = smf.vBuff;
					var _animArray = smf.animations;
					var modelNum = array_length(mBuff);
					array_copy(vBuff, modelNum, _vBuffArray, 0, array_length(_vBuffArray));
					array_copy(mBuff, modelNum, _mBuffArray, 0, array_length(_mBuffArray));
					array_copy(texPack, modelNum, _texArray, 0, array_length(_texArray));
					array_copy(animArray, array_length(animArray), _animArray, 0, array_length(_animArray));
					array_copy(vBuff, modelNum, _vBuffArray, 0, array_length(_vBuffArray));
					array_copy(model.vis, modelNum, smf.vis, 0, array_length(smf.vis));
				}
				else
				{
					var anim = file_find_first(filename_change_ext(edtSavePath, "") + "*.ani", 0);
					if anim == ""
					{
						show_message("Attempting to load old version of the SMF format. To make sure the skin is mapped properly to a rig, you must also load a .ani animation that belongs to this model");
						anim = get_open_filename("SMF animation format (*.ani)|*.ani", "");
					}
					if (anim == "")
					{
						model.rig = new smf_rig();
					}
					while anim != ""
					{
						var loadBuff = buffer_load(filename_path(edtSavePath) + anim);
						editor_load_rig_and_animation_from_buffer(loadBuff, anim);
						buffer_delete(loadBuff);
						anim = file_find_next();
					}
					file_find_close();
				
					var animArray = model.animations;
					if array_length(animArray) > 0
					{
						var smf = editor_load_smf_v1(file);
						mBuff = mbuff_add(mBuff, [smf]);
						model.mBuff = mBuff;
					}
				}
			}
			else if ext == ".fbx"
			{
				editor_show_message("FBX is not supported at this time");
				break;
			}
			else if ext == ".dae" 
			{
				//var obj = ColladaLoad(file, true);
				if !is_array(obj){break;}
				mBuff = mbuff_add(mBuff, obj[0]);
				model.mBuff = mBuff;
			}
			else
			{
				break;
			}
			var modelNum = array_length(mBuff);
			ds_list_clear(selList);
			for (var i = 0; i < modelNum; i ++)
			{
				selList[| i] = i;
			}
			model.Vertices = mbuff_get_vertices(mBuff);
			model.Triangles = model.Vertices div 3;
		
			var bbox = edt_model_get_size();
			camPos[0] = (bbox[0] + bbox[3]) * .5;
			camPos[1] = (bbox[1] + bbox[4]) * .5;
			camPos[2] = (bbox[2] + bbox[5]) * .5;
			var size = max(bbox[3] - bbox[0], bbox[4] - bbox[1], bbox[5] - bbox[2]);
			camZoom = 2 * size / editWidth;
			move_camera();
			//Clear the triangle index model, if it exists
			skineditor_clear_tri_ind_model();
			//Update skeleton model
			rigeditor_update_skeleton();
			//Update wireframe model
			modeleditor_update_wireframe();
		
			if (is_array(vBuff)){vbuff_delete(vBuff);}
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			buttons_update();
		
			if (array_length(texPack) < array_length(mBuff))
			{
				var spr = sprite_duplicate(texWhite);
				for (var i = array_length(texPack); i < array_length(mBuff); i ++)
				{
					texPack[@ i] = spr;
				}
			}
			autosave_save(edtAutosaveType.Everything);
			break;
		
		//Edit model
		case "NUMERICALSCALE":
			var scale = get_integer("Set scale percentage", 100) / 100;
			if (scale == 0){break;}
			undo_save("Scale", edtUndoType.Models);
			mbuff_transform(mBuff, matrix_build(0, 0, 0, 0, 0, 0, scale, scale, scale));
			if is_array(vBuff){vbuff_delete(vBuff);}
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			modeleditor_update_wireframe();
			//Clear the triangle index model, if it exists
			skineditor_clear_tri_ind_model();
			edtAutosaveModelChanged = true;
			model.Bbox = -1;
			break;
		case "FLIPTRIANGLES":
			var num = ds_list_size(selList);
			var tempArray = array_create(num);
			for (var i = 0; i < num; i ++){
				tempArray = mBuff[selList[| i]];}
			mbuff_flip_triangles(tempArray);
			if is_array(vBuff){vbuff_delete(vBuff);}
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			//Clear the triangle index model, if it exists
			skineditor_clear_tri_ind_model();
			edtAutosaveModelChanged = true;
			break;
		case "TESSELATE":
			var num = ds_list_size(selList);
			var tempArray = array_create(num);
			for (var i = 0; i < num; i ++){
				tempArray[i] = mBuff[selList[| i]];}
			undo_save("Tesselate", edtUndoType.Models);
			mbuff_tesselate_uvs(tempArray); 
			modeleditor_update_wireframe();
			if is_array(vBuff){vbuff_delete(vBuff);}
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			//Clear the triangle index model, if it exists
			skineditor_clear_tri_ind_model();
			edtAutosaveTexturesChanged = true;
			edtAutosaveModelChanged = true;
			break;
		case "TEXFORCEPOWTWO": TexForcePowerOfTwo = !TexForcePowerOfTwo; settings_update(); break;
		case "COMBINETOTEXPAGES":
			var oldMbuff = mBuff;
			var oldTexArray = texPack;
			var oldVisible = vis;
			var separateModels = [];
			var separateTextures = [];
			//Make sure only visible models are included
			var num = ds_list_size(selList);
			if num <= 1
			{
				editor_show_message("Only one model is selected! Select more models to combine them");
				break;
			}
			var tempMbuff = array_create(num);
			var tempTexArray = array_create(num);
			for (var i = 0; i < num; i ++)
			{
				var m = selList[| i];
				tempMbuff[i] = mBuff[m];
				tempTexArray[i] = texPack[m mod array_length(mBuff)];
			}
			undo_save("Combine to texpage", edtUndoType.Models);
			obj = mbuff_combine_to_texpage(tempMbuff, tempTexArray, TexpageExtendEdges, TexpageMaxSize, TexForcePowerOfTwo);
			model.mBuff = obj[0];
			model.texPack = obj[1];
			mBuff = model.mBuff;
			texPack = model.texPack;
			//Copy over invisible models that should not be included in the process
			var num = array_length(oldMbuff);
			for (var i = 0; i < num; i ++)
			{
				if (ds_list_find_index(selList, i) >= 0){continue;}
				var m = array_length(mBuff);
				mBuff[@ m] = oldMbuff[i];
				texPack[@ m] = oldTexArray[i];
				vis[@ m] = oldVisible[i];
			}
			//Clean up
			var num = array_length(tempMbuff);
			for (var i = 0; i < num; i ++)
			{
				buffer_delete(tempMbuff[i]);
			}
			modeleditor_update_wireframe();
			if is_array(vBuff){vbuff_delete(vBuff);}
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			buttons_update();
			ds_list_clear(selList);
			edtAutosaveTexturesChanged = true;
			edtAutosaveModelChanged = true;
			break;
		case "SPINX": 
			if edtPrevButton != edtSelButton{undo_save("Spin model", edtUndoType.Models);}
			edtModelTransformM = matrix_multiply(edtModelTransformM, matrix_build(0, 0, 0, 90, 0, 0, 1, 1, 1)); 
			model.Bbox = -1;
			break;
		case "SPINY": 
			if edtPrevButton != edtSelButton{undo_save("Spin model", edtUndoType.Models);}
			edtModelTransformM = matrix_multiply(edtModelTransformM, matrix_build(0, 0, 0, 0, 90, 0, 1, 1, 1)); 
			model.Bbox = -1;
			break;
		case "SPINZ":
			if edtPrevButton != edtSelButton{undo_save("Spin model", edtUndoType.Models);}
			edtModelTransformM = matrix_multiply(edtModelTransformM, matrix_build(0, 0, 0, 0, 0, 90, 1, 1, 1)); 
			model.Bbox = -1;
			break;
		case "FLATNORMALS":
			var num = ds_list_size(selList);
			if (num == 0){break;}
			var tempArray = array_create(num);
			for (var i = 0; i < num; i ++){
				tempArray[i] = mBuff[selList[| i]];}
			undo_save("Flat normals", edtUndoType.Models);
			mbuff_create_flat_normals(tempArray);
			skineditor_clear_tri_ind_model();
			vbuff_delete(vBuff);
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			edtAutosaveModelChanged = true;
			break;
		case "FLATTANGENTS":
			var num = ds_list_size(selList);
			if (num == 0){break;}
			var tempArray = array_create(num);
			for (var i = 0; i < num; i ++){
				tempArray[i] = mBuff[selList[| i]];}
			undo_save("Flat tangents", edtUndoType.Models);
			mbuff_create_flat_normals(tempArray);
			skineditor_clear_tri_ind_model();
			vbuff_delete(vBuff);
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			edtAutosaveModelChanged = true;
			break;
		case "SMOOTHNORMALS":
			var num = ds_list_size(selList);
			if (num == 0){break;}
			var tempArray = array_create(num);
			for (var i = 0; i < num; i ++){
				tempArray[i] = mBuff[selList[| i]];}
			undo_save("Smooth normals", edtUndoType.Models);
			mbuff_create_smooth_normals(tempArray);
			skineditor_clear_tri_ind_model();
			vbuff_delete(vBuff);
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			edtAutosaveModelChanged = true;
			break;
		case "SMOOTHTANGENTS":
			var num = ds_list_size(selList);
			if (num == 0){break;}
			var tempArray = array_create(num);
			for (var i = 0; i < num; i ++){
				tempArray[i] = mBuff[selList[| i]];}
			undo_save("Smooth tangents", edtUndoType.Models);
			mbuff_create_smooth_tangents(tempArray);
			skineditor_clear_tri_ind_model();
			vbuff_delete(vBuff);
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			edtAutosaveModelChanged = true;
			break;
			
		case "MERGESAME":
			undo_save("Merge same textures", edtUndoType.Models);
			var ind1, ind2, texNum;
			ds_list_sort(selList, true);
			for (var i = ds_list_size(selList) - 1; i >= 0; i --)
			{
				ind1 = selList[| i];
				for (var j = i-1; j >= 0; j --)
				{
				
					ind2 = selList[| j];
					texNum = array_length(texPack);
					if texPack[ind1 mod texNum] == texPack[ind2 mod texNum]
					{
						mbuff_combine(mBuff[ind2], mBuff[ind1]);
						model.mBuff = mbuff_remove(mBuff, ind1);
						mBuff = model.mBuff;
						if ind1 < texNum
						{
							model.texPack = texpack_remove_sprite(texPack, ind1);
						}
						ds_list_delete(selList, i);
						break;
					}
				}
				if j >= 0{continue;}
			}
			skineditor_clear_tri_ind_model();
			vbuff_delete(vBuff);
			model.vBuff = vbuff_create_from_mbuff(model.mBuff);
			buttons_update();
			modeleditor_update_wireframe();
			edtAutosaveTexturesChanged = true;
			edtAutosaveModelChanged = true;
			break;
	}


}
