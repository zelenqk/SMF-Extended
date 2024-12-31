/// @description animeditor_modify_timeline()
function animeditor_modify_timeline() {
	if (window_mouse_get_x() < edtTmlPos[0] || window_mouse_get_x() > edtTmlPos[2] || window_mouse_get_y() < edtTmlPos[1] || window_mouse_get_y() > edtTmlPos[3])
	{
		exit;
	}
	if (global.editMode != eTab.Animation)
	{
		exit;
	}
	edtTmlDoubleclickTimer --;

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
	if selAnim < array_length(animArray)
	{
		animation = animArray[selAnim];;
	}

	if (animation < 0){exit;}
	if (rig.boneNum == 0){exit;}

	if (mouse_check_button_pressed(mb_left) && edtAnimPlay)
	{
		edtAnimPlay = false;
		var keyframeGrid = animation.keyframeGrid;
		var keyframeTime = keyframeGrid[# 0, selKeyframe]
		model.Sample = anim_generate_sample(rig, animation, keyframeTime, eAnimInterpolation.Keyframe);
	}

	var tmlWidth = edtTmlPos[2] - edtTmlPos[0];
	var tmlHeight = edtTmlPos[3] - edtTmlPos[1];

	var keyframeGrid = animation.keyframeGrid;
	var mouseTime = clamp((window_mouse_get_x() - edtTmlPos[0]) / tmlWidth, 0, 1);
	if snapToGrid
	{
		mouseTime = round(mouseTime * 200) / 200;
	}

	var frameNum = ds_grid_height(keyframeGrid);
	if (mouse_check_button_pressed(mb_left))
	{
		var prevFrame = model.SelKeyframe;
		for (var i = 0; i < frameNum; i ++)
		{
			if (abs(keyframeGrid[# 0, i] - mouseTime) * tmlWidth < 10)
			{
				edtTmlDoubleclickTimer = -1;
				model.SelKeyframe = i;
				if prevFrame == model.SelKeyframe{edtTmlMove = true;}
				var keyframeGrid = animation.keyframeGrid;
				var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
				model.Sample = anim_generate_sample(rig, animation, keyframeTime, eAnimInterpolation.Keyframe);
				break;
			}
		}
		if (edtTmlMove)
		{
			undo_save("Manipulate timeline", edtUndoType.Animation);
		}
		if (edtTmlDoubleclickTimer > 0)
		{
			edtTmlMove = true;
			switch edtAnimKeyframeTool
			{
				case KEYFRAMEADDBLANK:
					undo_save("Add blank keyframe", edtUndoType.Animation);
					model.SelKeyframe = anim_add_keyframe(animation, mouseTime);
					var keyframeGrid = animation.keyframeGrid;
					var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
					model.Sample = anim_generate_sample(rig, animation, keyframeTime, eAnimInterpolation.Keyframe);
					break;
				case KEYFRAMEINSERT:
					undo_save("Insert keyframe", edtUndoType.Animation);
					if !is_array(model.SampleStrip)
					{
						model.SampleStrip = samplestrip_create(model.rig, animation);
					}
					samplestrip_update_sample(model.SampleStrip, mouseTime, model.Sample, true);
					model.SelKeyframe = anim_add_keyframe(animation, mouseTime);
					anim_keyframe_set_from_sample(rig, animation, model.SelKeyframe, model.Sample);
					var keyframeGrid = animation.keyframeGrid;
					var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
					model.Sample = anim_generate_sample(rig, animation, keyframeTime, eAnimInterpolation.Keyframe);
					break;
				case KEYFRAMEPASTE:
					var str = "";
					if (clipboard_has_text())
					{
						str = clipboard_get_text();
					}
					if (string_copy(str, 1, 8) != "KEYFRAME")
					{
						str = edtAnimCopiedKeyframe;
						clipboard_set_text(str);
						if (str == ""){break;}
					}
					undo_save("Paste keyframe", edtUndoType.Animation);
					var keyframe = anim_add_keyframe(animation, mouseTime);
					if anim_keyframe_set_from_string(animation, keyframe, str)
					{
						model.SelKeyframe = keyframe;
						var keyframeGrid = animation.keyframeGrid;
						var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
						model.Sample = anim_generate_sample(rig, animation, keyframeTime, eAnimInterpolation.Keyframe);
					}
					else
					{
						undo_load(true);
						undo_clear_redo();
						edtTmlMove = false;
					}
					break;
			}
		}
		//Select keyframe
		edtTmlDoubleclickTimer = 20;
	}
	if (mouse_check_button(mb_left))
	{
		if (edtTmlMove && model.SelKeyframe >= 0)
		{
			anim_keyframe_set_time(animation, model.SelKeyframe, clamp(mouseTime, 0, 0.999));
		}
	}
	else if (edtTmlMove)
	{
		edtTmlMove = false;
	}
	if (mouse_check_button(mb_left) && !edtTmlMove)
	{
		if !is_array(model.SampleStrip)
		{
			model.SampleStrip = samplestrip_create(model.rig, animation);
		}
		samplestrip_update_sample(model.SampleStrip, mouseTime, model.Sample, true);
	}
	if (mouse_check_button_released(mb_left))
	{
		var keyframeGrid = animation.keyframeGrid;
		var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
		model.Sample = anim_generate_sample(rig, animation, keyframeTime, eAnimInterpolation.Keyframe);
		model.SampleStrip = -1;
	}


}
