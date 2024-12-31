/// @description skineditor_press_buttons()
function skineditor_press_buttons() {
	/*
	Checks for button presses in the skinning tab of the model editor
	*/
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
			case "AUTOSKINPOWER":
				edtSkinPower = 1 + round(sliderValue * 9);
				settings_update();
				break;
			case "NORMALWEIGHTING":
				edtSkinNormalWeighting = sliderValue;
				settings_update();
				break;
			case "PAINTRADIUS":
				edtSkinPaintBrushSize = floor(sliderValue * 20);
				settings_update();
				break;
			case "PAINTWEIGHT":
				edtSkinPaintWeight = sliderValue;
				settings_update();
				break;
			case "PAINTSIZE":
				edtSkinPaintVertScale = sqr(sliderValue * 2);
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
		edtSkinSelTool = selectedTool;
		edtSelButton = -1;
		exit;
	}

	//Switch through the possible buttons
	switch edtSelButton.handle
	{
		//Skinning
		case "TOGGLEVERTPAINTTYPE":
			edtSkinVertPaintType ^= 1;
			buttons_update();
			settings_update();
			skineditor_clear_tri_ind_model();
			break;
		case "TOGGLEVERTVISIBLE": 
			edtSkinVertVisible ^= 1; 
			settings_update(); 
			buttons_update();
			break;
		case "AUTOSKINMODEL":
			var modelNum = ds_list_size(selList);
			if (modelNum == 0)
			{
				editor_show_message("No model selected");
				break;
			}
			editor_show_message("Autoskinned model");
			undo_save("Autoskin model", edtUndoType.Models);
			mbuff_autoskin(edtSkinPower, edtSkinNormalWeighting);
			//Update the vertex buffer
			if is_array(vBuff){vbuff_delete(vBuff);}
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			edtAutosaveModelChanged = true;
			break;
		case "SKINAUTONORMALIZE":
			edtSkinAutoNormalize = !edtSkinAutoNormalize;
			settings_update();
			break;
		case "ASSIGNTOBONE":
			if (selNode < 0){break;}
			var bindMap = rig.bindMap;
			var bone = bindMap[| selNode];
			if (bone < 0){break;}
			editor_show_message("Assigned selected models to selected bone");
			undo_save("Set bone influence", edtUndoType.Models);
			var weight = edtSkinPaintWeight * 255;
			var num = ds_list_size(selList);
			for (var i = 0; i < num; i ++)
			{
				if !vis[selList[| i]]{continue;}
				skineditor_set_bone_weight(mBuff[selList[| i]], bone, weight);
			}
			if is_array(vBuff){vbuff_delete(vBuff);}
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			edtAutosaveModelChanged = true;
			break;
	}


}
