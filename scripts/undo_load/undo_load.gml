/// @description undo_redo_load(undo)
/// @param undo
function undo_load(argument0) {
	if !editorUndoEnabled{exit;}
	skineditor_clear_tri_ind_model();

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
		var undoList = model.UndoList;
	}
	else
	{
		exit;
	}
	if ds_list_size(undoList) == 0{exit;}

	var undo = argument0;
	var ind = model.UndoIndex + (undo ? -2 : 2);
	if (ind < 0 || ind >= ds_list_size(undoList)){exit;}
	var name = undoList[| ind];
	var type = undoList[| ind+1];

	if (undo && model.UndoIndex == ds_list_size(undoList))
	{
		undo_save(name, type);
		model.UndoIndex -= 2;
	}

	var loadBuff = buffer_load(name);
	switch type
	{
		case edtUndoType.Models:
			//Clear all old models
			mbuff_delete(mBuff);
			//Load models
			mBuff = mbuff_read_from_buffer(loadBuff);
			model.mBuff = mBuff;
			modeleditor_update_wireframe();
			if (array_length(vis) < array_length(mBuff))
			{
				vis[@ array_length(mBuff)-1] = true;
			}
			modeleditor_update_wireframe();
			vbuff_delete(vBuff);
			model.vBuff = vbuff_create_from_mbuff(mBuff);
			var texNum = buffer_read(loadBuff, buffer_u16);
			for (var i = 0; i < texNum; i ++)
			{
				var spr = buffer_read(loadBuff, buffer_u16);
				if (sprite_exists(spr))
				{
					texPack[@ i] = spr;
				}
				else
				{
					texPack[@ i] = texWhite;
				}
			}
			edtModelTransformM = matrix_build_identity();
			break;
		
		case edtUndoType.BindPose:
			rig_delete(rig);
			rig = rig_read_from_buffer(loadBuff);
			model.rig = rig;
			rigeditor_update_skeleton();
			if (global.editMode == eTab.Animation)
			{
				var animInd = animArray[selAnim];;
				var keyframeGrid = animInd.keyframeGrid;
				var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
				model.Sample = anim_generate_sample(rig, animArray[selAnim], keyframeTime, eAnimInterpolation.Keyframe);
			}
			model.SelNode = -1;
			break;
		
		case edtUndoType.AnimLocal:
			model.SelAnim = buffer_read(loadBuff, buffer_u16);
			if (model.SelAnim == 9999)
			{
				model.SelAnim = -1;
				break;
			}
			model.SelKeyframe = buffer_read(loadBuff, buffer_u8);
			animArray[@ model.SelAnim] = anim_read_from_buffer(loadBuff);
			if (global.editMode == eTab.Animation)
			{
				var animInd = animArray[model.SelAnim];
				var keyframeGrid = animInd.keyframeGrid;
				var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
				model.Sample = anim_generate_sample(rig, animInd, keyframeTime, eAnimInterpolation.Keyframe);
			}
			break;
		
		case edtUndoType.Animation:
			var num = array_length(animArray);
			for (var i = 0; i < num; i ++)
			{
				anim_delete(animArray[i]);
			}
			num = buffer_read(loadBuff, buffer_u8);
			animArray = array_create(num);
			for (var i = 0; i < num; i ++)
			{
				animArray[i] = anim_read_from_buffer(loadBuff);
			}
			selAnim = min(selAnim, num - 1);
			model.animations = animArray;
			model.SelAnim = selAnim;
			model.SelKeyframe = min(model.SelKeyframe, anim_get_keyframe_num(animArray[selAnim]) - 1);
			if (global.editMode == eTab.Animation)
			{
				var animInd = animArray[selAnim];;
				var keyframeGrid = animInd.keyframeGrid;
				var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
				model.Sample = anim_generate_sample(rig, animArray[selAnim], keyframeTime, eAnimInterpolation.Keyframe);
			}
			break;
		
		case edtUndoType.Everything:
			//Clear all old models
			mbuff_delete(mBuff);
			//Load models
			mBuff = mbuff_read_from_buffer(loadBuff);
			model.mBuff = mBuff;
			modeleditor_update_wireframe();
			if array_length(vis) < array_length(mBuff)
			{
				vis[@ array_length(mBuff)-1] = true;
			}
			modeleditor_update_wireframe();
			vbuff_delete(vBuff);
			vBuff = vbuff_create_from_mbuff(mBuff);
			model.vBuff = vBuff;
			edtModelTransformM = matrix_build_identity();
			//Load textures 
			var texNum = buffer_read(loadBuff, buffer_u16);
			for (var i = 0; i < texNum; i ++)
			{
				var spr = buffer_read(loadBuff, buffer_u16);
				if sprite_exists(spr)
				{
					texPack[@ i] = spr;
				}
				else
				{
					texPack[@ i] = texWhite;
				}
			}
			//Load rig
			rig_delete(rig);
			rig = rig_read_from_buffer(loadBuff);
			model.rig = rig;
			rigeditor_update_skeleton();
			model.SelNode = -1;
			//Load animations
			var num = array_length(animArray);
			for (var i = 0; i < num; i ++)
			{
				anim_delete(animArray[i]);
			}
			num = buffer_read(loadBuff, buffer_u8);
			if (num > 0)
			{
				for (var i = 0; i < num; i ++)
				{
					animArray[@ i] = anim_read_from_buffer(loadBuff);
				}
				selAnim = min(selAnim, num - 1);
				model.SelAnim = selAnim;
				model.SelKeyframe = min(model.SelKeyframe, anim_get_keyframe_num(animArray[selAnim]) - 1);
				if global.editMode == eTab.Animation
				{
					var animInd = animArray[selAnim];;
					var keyframeGrid = animInd.keyframeGrid;
					var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
					model.Sample = anim_generate_sample(rig, animArray[selAnim], keyframeTime, eAnimInterpolation.Keyframe);
				}
			}
			break;
	}
	buffer_delete(loadBuff);

	model.UndoIndex = clamp(model.UndoIndex + 2 * (1 - 2 * undo), 0, ds_list_size(undoList));
	model.SampleStrip = -1;
	buttons_update();
}
