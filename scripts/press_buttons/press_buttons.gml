function press_buttons() {
	var mouseWheel = mouse_wheel_down() - mouse_wheel_up();
	if mouseWheel != 0
	{
		var btn = collision_point(window_mouse_get_x(), window_mouse_get_y(), oAnimEditButton, false, false);
		if btn >= 0
		{
			if string_count("SUBMODEL", btn.handle) > 0
			{
				edtModelIndexScroll += mouseWheel;
				buttons_update();
				exit;
			}
			if string_count("ANIMINDEX", btn.handle) > 0
			{
				edtAnimIndexScroll += mouseWheel;
				buttons_update();
				exit;
			}
		}
		exit;
	}

	if mouse_check_button_pressed(mb_right)
	{
		btn = collision_point(window_mouse_get_x(), window_mouse_get_y(), oAnimEditButton, false, false);
		if btn >= 0
		{
			if string_count("SUBMODEL", btn.handle) > 0
			{
				var model = edtSMFArray[edtSMFSel];
				var selList = model.SelModelList;
				edtSelButton = btn;
				var ind = real(string_delete(edtSelButton.handle, 1, 8));
				if ds_list_find_index(selList, ind) < 0
				{
					ds_list_add(selList, ind);
				}
				var _dropdown = ds_list_create();
				ds_list_add(_dropdown, "Move to top", -1, 0);
				ds_list_add(_dropdown, "Move to bottom", -1, 0);
				ds_list_add(_dropdown, "Merge selected", -1, 0);
				ds_list_add(_dropdown, "Delete selected", -1, 0);
				show_scroll_menu("SUBMODELRIGHTCLICK", _dropdown);
			}
		}
		exit;
	}

	if !mouse_check_button(mb_left){exit;}
	var model = edtSMFArray[edtSMFSel];
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

	if (mouse_check_button_pressed(mb_left))
	{
		selectedSlider = -1;
		edtPrevButton = edtSelButton;
		edtSelButton = collision_point(window_mouse_get_x(), window_mouse_get_y(), oAnimEditButton, false, false);
		if (edtSelButton >= 0)
		{
			if edtSelButton.sprite_index == sSlider
			{
				selectedSlider = edtSelButton;
			}
		}
		if (edtSelButton >= 0 and instance_exists(edtSelButton))
		{
			//Check if the pressed button is a model index
			if (string_count("SUBMODEL", edtSelButton.handle))
			{
				edtAutosaveTexturesChanged = true;
				edtAutosaveModelChanged = true;
				if (edtModelSelectBuffer >= 0)
				{
					buffer_delete(edtModelSelectBuffer);
				}
				edtModelSelectBuffer = -1;
				selectModelFade = 1;
				var ind = real(string_delete(edtSelButton.handle, 1, 8));
				var dx = window_mouse_get_x() - edtSelButton.x;
				var selected = (ds_list_find_index(selList, ind) >= 0);
				if (dx > 128 - 20)
				{
					//Toggle submodel visibility
					vis[@ ind] ^= 1;
					model.vis = vis;
					skineditor_clear_tri_ind_model();
				}
				else if (dx > 128 - 20 * 2 && selected)
				{
					var modelNum = array_length(mBuff);
					for (var m = 1; m < modelNum; m ++)
					{
						//If this model is not selected, continue the loop
						var selInd = ds_list_find_index(selList, m);
						if (selInd < 0){continue;}
					
						//If the model above this one is selected, continue the loop
						if (ds_list_find_index(selList, m-1) >= 0){continue;}
					
						//Switch places between this model and the model above it
						var _vis = vis[m - 1];
						var _mbuff = mBuff[m - 1];
						var _vbuff = vBuff[m - 1];
						var _wire = wire[m - 1];
						mBuff[@ m - 1] = mBuff[m];
						mBuff[@ m] = _mbuff;
						vBuff[@ m - 1] = vBuff[m];
						vBuff[@ m] = _vbuff;
						wire[@ m - 1] = wire[m];
						wire[@ m] = _wire;
						vis[@ m - 1] = vis[m];
						vis[@ m] = _vis;
				
						var texNum = array_length(texPack);
						if (texNum > 0)
						{
							var tex = texPack[(m - 1 + texNum) mod texNum];
							texPack[@ (m - 1 + texNum) mod texNum] = texPack[m mod texNum];
							texPack[@ m mod texNum] = tex;
						}
						selList[| selInd] --;
					}
					skineditor_clear_tri_ind_model();
					exit;
				}
				else if (dx > 128 - 20 * 3 && selected)
				{
					var modelNum = array_length(mBuff);
					for (var m = modelNum - 2; m >= 0; m --)
					{
						//If this model is not selected, continue the loop
						var selInd = ds_list_find_index(selList, m);
						if (selInd < 0){continue;}
					
						//If the model below this one is selected, continue the loop
						if (ds_list_find_index(selList, m+1) >= 0){continue;}
					
						//Switch places between this model and the model below it
						var _mbuff = mBuff[m + 1];
						var _vbuff = vBuff[m + 1];
						var _wire = wire[m + 1];
						var _vis = vis[m + 1];
						mBuff[@ m + 1] = mBuff[m];
						mBuff[@ m] = _mbuff;
						vBuff[@ m + 1] = vBuff[m];
						vBuff[@ m] = _vbuff;
						wire[@ m + 1] = wire[m];
						wire[@ m] = _wire;
						vis[@ m + 1] = vis[m];
						vis[@ m] = _vis;
				
						var texNum = array_length(texPack);
						if (texNum > 0)
						{
							var tex = texPack[(m + 1) mod texNum];
							texPack[@ (m + 1) mod texNum] = texPack[m mod texNum];
							texPack[@ m mod texNum] = tex;
						}
						selList[| selInd] ++;
					}
					skineditor_clear_tri_ind_model();
					exit;
				}
				else if (dx < 22) //Select texture
				{
					var model = edtSMFArray[edtSMFSel];
					var texPack = model.texPack;
					var _dropdown = ds_list_create();
					var texNum = array_length(texPack);
					ds_list_add(_dropdown, "-Add new-", -1, 0);
					for (var i = 0; i < texNum; i ++)
					{
						if (ds_list_find_index(_dropdown, texPack[i]) < 0)
						{
							ds_list_add(_dropdown, i, texPack[i], 0);
						}
					}
					show_scroll_menu("SELECTTEXTURE", _dropdown);
					if (!keyboard_check(vk_shift) && !keyboard_check(vk_control))
					{
						ds_list_clear(selList);
						ds_list_add(selList, ind);
					}
					else if (!selected){ds_list_add(selList, ind);}
					exit;
				}
				if (!keyboard_check(vk_shift) && !keyboard_check(vk_control))
				{
					ds_list_clear(selList);
				}
				if (keyboard_check(vk_control) && selected)
				{
					ind = ds_list_find_index(selList, ind);
					ds_list_delete(selList, ind);
					buttons_update();
					exit;
				}
				if (ds_list_find_index(selList, ind) < 0)
				{
					ds_list_add(selList, ind);
				}
				buttons_update();
				exit;
			}
			switch edtSelButton.handle
			{
				//Settings
				case "TOGGLESKELETON": drawSkeleton ^= 1; settings_update(); break;
				case "TOGGLEWIREFRAME": drawWireframe ^= 1; settings_update(); break;
				case "TOGGLENODES": drawNodeIndices ^= 1; settings_update(); break;
				case "TOGGLENDOEPERSPECTIVE": enableNodePerspective ^= 1; settings_update(); break;
				case "TOGGLESNAP": snapToGrid ^= 1; settings_update(); break;
				case "TOGGLETEXTURE": drawTexture ^= 1; settings_update(); break;
				case "TOGGLELIGHT": lightFollowCam ^= 1; settings_update(); break;
				case "TOGGLECULLING": culling ^= 1; settings_update(); break;
				case "TOGGLEDRAWGRID": drawGrid ^= 1; settings_update(); break;
				case "TOGGLEDTEXREPEAT": enableTexRepeat ^= 1; settings_update(); break;
				case "TOGGLEDTEXFILTER": enableTexFilter ^= 1; settings_update(); break;
				case "USECOMPRESSION": useCompression ^= 1; settings_update(); break;
				case "INCLUDETEX": IncludeTex ^= 1; settings_update(); break;
				case "TOGGLESHADER": enableShader ^= 1; settings_update(); break;
			
				//Scroll
				case "MODELSCROLLUP": edtModelIndexScroll --; buttons_update(); break;
				case "MODELSCROLLDOWN": edtModelIndexScroll ++; buttons_update(); break;
			
				case "MAKEVISIBLE": 
					if (model < 0){break;}
					model.vis = array_create(array_length(vis), 1); 
					buffer_delete(edtModelSelectBuffer);
					edtModelSelectBuffer = -1;
					edtAutosaveModelChanged = true;
					break;
				case "MAKESELECTEDINVISIBLE":
					if (model < 0){break;}
					var num = ds_list_size(selList);
					for (var i = 0; i < num; i ++)
					{
						var m = selList[| i];
						vis[@ m] = false;
					}
					buffer_delete(edtModelSelectBuffer);
					edtModelSelectBuffer = -1;
					edtAutosaveModelChanged = true;
					break;
				case "MAKEUNSELECTEDINVISIBLE":
					if (model < 0){break;}
					var num = array_length(mBuff);
					for (var i = 0; i < num; i ++)
					{
						if ds_list_find_index(selList, i) < 0
						{
							vis[@ i] = false;
						}
					}
					buffer_delete(edtModelSelectBuffer);
					edtModelSelectBuffer = -1;
					edtAutosaveModelChanged = true;
					break;
				case "SELECTALL":
					if (model < 0){break;}
					ds_list_clear(selList);
					for (var i = array_length(mBuff) - 1; i >= 0; i --)
					{
						selList[| i] = i;
					}
					buttons_update();
					break;
				case "CLEARSELECTION": 
					if (model < 0){break;}
					ds_list_clear(selList);	
					break;
			
				//Export model
				case "COMPRESS":
					useCompression = !useCompression;
					break;
				case "SAVE":
				case "SAVEAS":
					var fname = edtSavePath;
					if (fname == "" || edtSelButton.handle == "SAVEAS")
					{
						fname = get_save_filename("smf|*.smf", filename_change_ext(edtSavePath, ".smf"));
					}
					if fname == ""{break;}
					edtSavePath = fname;
					smf_model_save(model, edtSavePath, IncludeTex);
					if !IncludeTex
					{
						//Save textures
						var texNum = min(array_length(texPack), array_length(mBuff));
						for (var i = 0; i < texNum; i ++)
						{
							sprite_save(texPack[i], 0, filename_change_ext(edtSavePath, "_" + string(texPack[i]) + ".png"));
						}
					}
					editor_show_message("Saved project");
					break;
				case "SAVESMFCOMP":
					edtSavePath = get_save_filename("smf|*.smf", filename_change_ext(edtSavePath, ".smf"));
					if edtSavePath == ""{break;}
					editor_export_smf_v1(edtSavePath);
					break;
				case "EXPORTOBJ":
					var fname = get_save_filename("Model files (*.smf, *.obj)|*.smf;*.obj", edtModelName + ".smf");
					break;
				
				//Autosave system
				case "TOGGLEAUTOSAVE":
					if edtAutosaveEnabled{
						if !show_question("Are you sure you want to disable the autosave function?"){
							break;}}
					edtAutosaveEnabled ^= 1;
		
				//Undo system
				case "TOGGLEUNDO":
					if editorUndoEnabled{
						if !show_question("Are you sure you want to disable the undo/redo function?\nAny changes done to the model afterwards will be irreversible"){
							break;}}
					editorUndoEnabled ^= 1;
					break;
				case "UNDO":
					edtModelTransformM = matrix_build_identity();
					undo_load(true);
					break;
				case "REDO":
					edtModelTransformM = matrix_build_identity();
					undo_load(false);
					break;
			
				//Load autosave
				case "LOADAUTOSAVE":
					autosave_load();
					edtAutosaveAvailable = false;
					buttons_update();
					editor_show_message("Loaded autosave");
					for (var i = 0; i < array_length(model.mBuff); i ++)
					{	//Add all models to selected list
						selList[| i] = i;
					}
					break;
				
				//Change modes
				case "MODELEDITOR":
					switch_to_modeleditor();
					break;
				case "RIGGING":
					switch_to_rigeditor();
					break;
				case "SKINNING":
					switch_to_skineditor();
					break;
				case "ANIMATION":
					switch_to_animeditor();
					break;
			}
		}
	}
	if !instance_exists(selectedSlider){selectedSlider = -1;}

	if mouse_check_button(mb_left)
	{
		//Move sliders
		if selectedSlider >= 0
		{
			var sliderValue = median((window_mouse_get_x() - (selectedSlider.x + 5)) / (127 - 10), 0, 1);
			switch selectedSlider.handle
			{
				case "RIGOPACITY":
					edtRigOpacity = lerp(.2, 1., sliderValue);
					break;
				case "RIGSCALE":
					edtRigScale = sliderValue * sliderValue;
					break;
				case "GUISCALE":
					edtGUIScale = power(2, lerp(1, -1, sliderValue));
					display_set_gui_size(window_get_width(), window_get_height());
					window_resize();
					break;
			}
		}
	}

	switch global.editMode
	{
		case eTab.Model:
			modeleditor_press_buttons();
			break;
		case eTab.Rigging:
			rigeditor_press_buttons();
			break;
		case eTab.Skinning:
			skineditor_press_buttons();
			break;
		case eTab.Animation:
			animeditor_press_buttons();
			break;
	}


}
