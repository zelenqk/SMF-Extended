/// @description skineditor_press_buttons()
function animeditor_press_buttons() {
	/*
	Checks for button presses in the skinning tab of the model editor
	*/
	var animation = -1; 
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
	if (selAnim < array_length(animArray))
	{
		animation = animArray[selAnim];
	}
	model.SampleStrip = -1;

	if (rig.boneNum == 0){exit;}

	//Move sliders
	if selectedSlider >= 0
	{
		var sliderValue = median((window_mouse_get_x() - (selectedSlider.x + 5)) / (127 - 10), 0, 1);
		switch selectedSlider.handle
		{
			case "FRAMEMULTIPLIER":
				if (animation < 0){break;}
				var newValue = 1 + round(sliderValue * 19);
				if newValue != anim_get_sample_frame_multiplier(animation)
				{
					anim_set_sample_frame_multiplier(animation, newValue);
				}
				break;
		}
	}

	//Various exit conditions
	if !mouse_check_button_pressed(mb_left){exit;}
	if edtSelButton < 0 || !instance_exists(edtSelButton){exit;}
	if edtSelButton.sprite_index == sCategory{exit;}
	edtAnimPlay = false;

	//Check if the pressed button is an animation index
	if string_count("ANIMINDEX", edtSelButton.handle) > 0
	{
		autosave_save(edtAutosaveType.SelectedAnimation);
		var ind = real(string_delete(edtSelButton.handle, 1, 9));
		var dx = window_mouse_get_x() - edtSelButton.x;
		var animNum = array_length(animArray);
		if (dx > 128 - 20)
		{
			//Duplicate animation
			undo_save("Duplicate animation", edtUndoType.Animation);
			animation = animArray[ind];
			var name = get_string("Duplicate animation: Set the name of the new animation", animation.name + "_2");
			if (name == ""){exit;}
			model.SelAnim = animNum;
			animArray[@ model.SelAnim] = anim_duplicate(animation);
			animation = animArray[model.SelAnim];
			animation.name = name;
			autosave_save(edtAutosaveType.SelectedAnimation);
		}
		else if (dx > 128 - 20 * 2 && selAnim == ind)
		{
			//Move animation up
			if ind <= 0{exit;}
			var temp = animArray[ind];
			animArray[@ ind] = animArray[ind - 1];
			animArray[@ ind - 1] = temp;
			model.SelAnim --;
		}
		else if (dx > 128 - 20 * 3 && model.SelAnim == ind)
		{
			//Move animation down
			if ind >= animNum - 1{exit;}
			var temp = animArray[ind];
			animArray[@ ind] = animArray[ind + 1];
			animArray[@ ind + 1] = temp;
			model.SelAnim ++;
		}
		else if (dx > 128 - 20 * 4 && model.SelAnim == ind)
		{
			//Delete animation
			if !show_question("Are you sure you want to delete this animation?"){exit;}
			undo_save("Delete animation", edtUndoType.Animation);
			anim_delete(animArray[ind]);
			var tempArray = animArray;
			animArray = array_create(animNum - 1);
			for (var i = 0; i < ind; i ++)
			{
				animArray[i] = tempArray[i];
			}
			for (var i = ind + 1; i < animNum; i ++)
			{
				animArray[i - 1] = tempArray[i];
			}
			model.animations = animArray;
			model.SelAnim = min(model.SelAnim, array_length(animArray) - 1);
			autosave_save(edtAutosaveType.AllAnimations);
			buttons_update();
		}
		else if (dx < 128 - 20 * 4 && model.SelAnim == ind)
		{
			//Rename animation
			var oldName = animation.name;
			var newName = get_string("Give this animation a new name", oldName);
			if newName == ""{exit;}
			animation.name = newName;
			buttons_update();
			autosave_save(edtAutosaveType.SelectedAnimation);
			exit;
		}
		else
		{
			model.SelAnim = ind;
			animation = animArray[model.SelAnim];
			var keyframeGrid = animation.keyframeGrid;
			model.SelKeyframe = min(model.SelKeyframe, ds_grid_height(keyframeGrid) - 1);
		}
		if (model.SelAnim < 0)
		{
			model.SelAnim = 0;
			model.Sample = sample_create_bind(rig);
			exit;
		}
		var animation = animArray[model.SelAnim];
		var keyframeGrid = animation.keyframeGrid;
		var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
		model.Sample = anim_generate_sample(rig, animArray[model.SelAnim], keyframeTime, eAnimInterpolation.Keyframe);
		buttons_update();
		exit;
	}

	//Check if the pressed button is a tool
	if string_count("TOOL", edtSelButton.handle) > 0
	{
		selectedTool = real(string_delete(edtSelButton.handle, 1, 4));
		edtAnimSelTool = selectedTool;
		edtSelButton = -1;
		exit;
	}

	//Switch through the possible buttons
	switch edtSelButton.handle
	{
		case "ANIMLOOP": if (animation < 0){break;} anim_set_loop(animation, !anim_get_loop(animation)); break;
		case "ANIMNOINTERPOLATION": if (animation < 0){break;} anim_set_interpolation(animation, eAnimInterpolation.Keyframe); break;
		case "ANIMLINEARINTERPOLATION": if (animation < 0){break;} anim_set_interpolation(animation, eAnimInterpolation.Linear); break;
		case "ANIMQUADRATICNTERPOLATION": if (animation < 0){break;} anim_set_interpolation(animation, eAnimInterpolation.Quadratic); break;
		case "TRANSFORMCHILDREN": edtAnimTransformChildren ^= 1; settings_update(); break;
		case "MOVEFROMCURRENT": edtAnimMoveFromCurrent ^= 1; settings_update(); break;
	
		case "COPYKEYFRAME": 
			if (animation < 0){break;} 
			var str = anim_keyframe_get_string(animation, model.SelKeyframe);
			edtAnimCopiedKeyframe = str;
			clipboard_set_text(str);
			edtAnimKeyframeTool = KEYFRAMEPASTE; 
			editor_show_message("Copied keyframe to clipboard");
			break;
		case "PASTEKEYFRAME": edtAnimKeyframeTool = KEYFRAMEPASTE; break;
		case "ADDKEYFRAME": edtAnimKeyframeTool = KEYFRAMEADDBLANK; break;
		case "INSERTKEYFRAME": edtAnimKeyframeTool = KEYFRAMEINSERT; break;
	
		case "ANIMPLAY": event_perform(ev_keypress, vk_space); break;
		case "ANIMATIONSPEED": 
			if (animation < 0){break;} 
			var oldTime = animation.playTime;
			var newTime = get_integer("Set animation time (in milliseconds)", oldTime); 
			if newTime <= 0{break;}
			animation.playTime = newTime;
			break;
	
		case "CLEARKEYFRAME": 
			if (animation < 0){break;} 
			undo_save("Clear keyframe", edtUndoType.AnimLocal);
			anim_keyframe_clear(animation, model.SelKeyframe); 
			model.Sample = sample_create_bind(rig);
			break;
		case "DELETEKEYFRAME":
			if (animation < 0){break;} 
			if anim_get_keyframe_num(animation) <= 1{
				editor_show_message("Can't delete last frame of animation");
				break;}
			undo_save("Delete keyframe", edtUndoType.Animation);
			anim_delete_keyframe(animation, model.SelKeyframe);
			model.SelKeyframe = max(model.SelKeyframe - 1, 0);
			var animation = animArray[model.SelAnim];
			var keyframeGrid = animation.keyframeGrid;
			var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
			model.Sample = anim_generate_sample(rig, animArray[model.SelAnim], keyframeTime, eAnimInterpolation.Keyframe);
			break;
		
		case "ANIMSCROLLUP": edtAnimIndexScroll --; buttons_update(); break;
		case "ANIMSCROLLDOWN": edtAnimIndexScroll ++; buttons_update(); break;
	
		case "NEWANIM":
			var animNum = array_length(animArray);
			var name = get_string("Name of new animation", "anim" + string(animNum));
			if (name == ""){break;}
			undo_save("New animation", edtUndoType.Animation);
			animArray[@ animNum] = anim_create(name);
			anim_add_keyframe(animArray[@ animNum], 0);
			model.SelAnim = animNum;
			model.SelKeyframe = 0;
			var animation = animArray[model.SelAnim];
			var keyframeGrid = animation.keyframeGrid;
			if (model.SelKeyframe >= ds_grid_height(keyframeGrid))
			{
				model.Sample = sample_create_bind(rig);
				break;
			}
			var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
			model.Sample = anim_generate_sample(rig, animArray[model.SelAnim], keyframeTime, eAnimInterpolation.Keyframe);
			buttons_update();
			autosave_save(edtAutosaveType.SelectedAnimation);
			break;
		case "LOADANIM":
			var fname = get_open_filename("Animation (*.anim)|*.anim;*.ani", "");
			if fname == ""{break;}
			undo_save("Load animation", edtUndoType.Animation);
			var loadBuff = buffer_load(fname);
			var animNum = array_length(animArray);
			model.SelKeyframe = 0;
			var anim = anim_read_from_buffer(loadBuff);
			if (anim >= 0)
			{
				animArray[@ animNum] = anim;
				model.SelAnim = animNum;
				model.Sample = anim_generate_sample(rig, animArray[model.SelAnim], 0, eAnimInterpolation.Keyframe);
				buffer_delete(loadBuff);
			}
			else
			{
				buffer_seek(loadBuff, buffer_seek_start, 0);
				editor_load_rig_and_animation_from_buffer(loadBuff, fname);
				model.Sample = anim_generate_sample(rig, animArray[model.SelAnim], 0, eAnimInterpolation.Keyframe);
				buffer_delete(loadBuff);
			}
			buttons_update();
			autosave_save(edtAutosaveType.SelectedAnimation);
			break;
	
		case "RESETNODE":
			if (animation < 0 || selNode < 0){break;}
			undo_save("Reset node", edtUndoType.Animation);
			var keyframeGrid = animation.keyframeGrid;
			if (model.SelKeyframe >= ds_grid_height(keyframeGrid))
			{
				model.Sample = sample_create_bind(rig);
				break;
			}
			var keyframeTime = keyframeGrid[# 0, selKeyframe];
			var keyframe = keyframeGrid[# 1, selKeyframe];
			keyframe[@ selNode] = [0, 0, 0, 1, 0, 0, 0, 0];
			model.Sample = anim_generate_sample(rig, animation, keyframeTime, eAnimInterpolation.Keyframe);
			break;
		case "LOCKNODE":
			if (animation < 0 || selNode <= 0){break;}
			var i = ds_list_find_index(animation.lockedBonesList, selNode);
			if (i < 0){
				ds_list_add(animation.lockedBonesList, selNode);
			}
			else{
				ds_list_delete(animation.lockedBonesList, i);
			}
			break;
		case "COPYNODE":
			animeditor_copy_node();
			break;
		case "PASTENODE":
			animeditor_paste_node();
			break;
		case "FLIPNODE":
			if (animation < 0 || selNode < 0){break;}
			var keyframeGrid = animation.keyframeGrid;
			if (model.SelKeyframe >= ds_grid_height(keyframeGrid))
			{
				break;
			}
			var keyframeTime = keyframeGrid[# 0, selKeyframe];
			var keyframe = keyframeGrid[# 1, selKeyframe];
			smf_dq_negate(keyframe[selNode]);
			break;
	}


}
