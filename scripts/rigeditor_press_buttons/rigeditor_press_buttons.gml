function rigeditor_press_buttons() {
	//Apply any transformations

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

	if mouse_check_button_pressed(mb_left)
	{
		selectedSlider = -1;
		with oAnimEditButton
		{
			if sprite_index != sSlider{continue;}
			if collision_point(window_mouse_get_x(), window_mouse_get_y(), id, false, false)
			{
				selectedSlider = id;
				break;
			}
		}
	}
	if !instance_exists(selectedSlider){selectedSlider = -1;}
	if selectedSlider >= 0
	{
		var sliderValue = median((window_mouse_get_x() - (selectedSlider.x + 5)) / (127 - 10), 0, 1);
		switch selectedSlider.handle
		{
			case "AUTOSKINPOWER":
				autoskinPower = 1 + round(sliderValue * 9);
				settings_update();
				break;
			case "NORMALWEIGHTING":
				autoskinNormalWeighting = sliderValue;
				settings_update();
				break;
		}
	}

	if !mouse_check_button_pressed(mb_left){exit;}
	if (edtSelButton < 0 || !instance_exists(edtSelButton)){exit;}
	if edtSelButton.sprite_index == sCategory{exit;}

	//Switch through the possible buttons
	var handle = edtSelButton.handle;

	//Check if the pressed button is a tool
	if string_count("TOOL", handle) > 0
	{
		selectedTool = real(string_delete(handle, 1, 4));
		edtRigSelTool = selectedTool;
		edtSelButton = -1;
		exit;
	}
	if string_count("SUBRIG", handle) > 0
	{
		rigSelSubDiv = real(string_delete(handle, 1, 6));
		edtSelButton = -1;
		exit;
	}

	switch edtSelButton.handle
	{
		case "TOGGLEPRIMARYAXIS":
			edtRigShowPrimaryAxis ^= 1;
			settings_update();
			break;
		
		//Edit rig
		case "INSERTNODE":
			if (model < 0 || selNode < 0){break;}
			undo_save("Insert node", edtUndoType.Everything);
			rigeditor_insert_node(selNode);
			rigeditor_update_skeleton();
			model.Sample = [0, 0, 0, 1, 0, 0, 0, 0]; //Clear the sample whenever we modify the rig
			edtAutosaveRigChanged = true;
			break;
		case "DELETENODE":
			if (model < 0 || selNode < 0){break;}
			undo_save("Delete node", edtUndoType.Everything);
			rigeditor_delete_node(selNode);
			rigeditor_update_skeleton();
			model.SelNode = min(selNode, rig_get_node_number(rig)-1);
			model.Sample = [0, 0, 0, 1, 0, 0, 0, 0]; //Clear the sample whenever we modify the rig
			edtAutosaveRigChanged = true;
			break;
		case "DETACHNODE":
			if (model < 0 || selNode < 0){break;}
			undo_save("Detach node", edtUndoType.Everything);
			if rig_node_get_bone(rig, selNode)
			{
				rigeditor_detach_node(selNode, true);
				rig_node_set_bone(rig, selNode, false);
			}
			else
			{
				rig_node_set_bone(rig, selNode, true);
				rigeditor_detach_node(selNode, false);
			}
			rigeditor_update_skeleton();
			model.Sample = [0, 0, 0, 1, 0, 0, 0, 0]; //Clear the sample whenever we modify the rig
			edtAutosaveRigChanged = true;
			break;
		case "LOCKNODE":
			if (model < 0 || selNode < 0){break;}
			rig_node_set_locked(rig, selNode, !rig_node_get_locked(rig, selNode));
			break;
		case "DESELECTNODE":
			model.SelNode = -1;
			break;
	
		case "LOADRIG":
			if (model < 0){break;}
			var fname = get_open_filename("Rig (*.rig;*.smf)|*.rig;*.smf", "");
			if fname == ""{break;}
			var loadBuff = buffer_load(fname);
			if (string_lower(filename_ext(fname)) == ".smf")
			{
				var _model = smf_model_load_from_buffer(loadBuff, fname);
				if is_struct(_model.rig)
				{
					model.rig.destroy();
					model.rig = _model.rig;
					_model.rig = new smf_rig();
					_model.destroy();
				}
			}
			else
			{		
				rig_delete(rig);
				model.rig = rig_read_from_buffer(loadBuff);
			}
			buffer_delete(loadBuff);
			rigeditor_update_skeleton();
			edtAutosaveRigChanged = true;
			break;
		case "CLEARRIG":
			if (model < 0){break;}
			rig_clear(rig);
			rigeditor_update_skeleton();
			model.SelNode = -1;
			edtAutosaveRigChanged = true;
			break;
		case "SPINRIGX":
			if (model < 0){break;}
			rig_transform(rig, smf_dq_create(-pi/2, 1, 0, 0, 0, 0, 0), 1, 1, 1);
			rigeditor_update_skeleton();
			edtAutosaveRigChanged = true;
			break;
		case "SPINRIGY":
			if (model < 0){break;}
			rig_transform(rig, smf_dq_create(-pi/2, 0, 1, 0, 0, 0, 0), 1, 1, 1);
			rigeditor_update_skeleton();
			edtAutosaveRigChanged = true;
			break;
		case "SPINRIGZ":
			if (model < 0){break;}
			rig_transform(rig, smf_dq_create(-pi/2, 0, 0, 1, 0, 0, 0), 1, 1, 1);
			rigeditor_update_skeleton();
			edtAutosaveRigChanged = true;
			break;
		
		//Sub rigs
		case "ADDLIMB":
			rigSubDivs[array_length(rigSubDivs)] = [];
			rigSelSubDiv = array_length(rigSubDivs) - 1;
			selectedTool = subRigsELECTBONE;
			buttons_update();
			edtAutosaveRigChanged = true;
			break;
		case "DELLIMB":
			if (rigSelSubDiv < 0 || rigSelSubDiv >= array_length(rigSubDivs)){break;}
			rigSubDivs = _array_delete(rigSubDivs, rigSelSubDiv);
			rigSelSubDiv = min(rigSelSubDiv, array_length(rigSubDivs) - 1);
			buttons_update();
			edtAutosaveRigChanged = true;
			break;
	}


}
