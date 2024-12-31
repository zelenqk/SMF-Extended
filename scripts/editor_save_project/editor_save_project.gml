/// @description editor_save_project(fname)
/// @param fname
function editor_save_project(argument0) {
	var fname = filename_change_ext(argument0, "");
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
	else
	{
		exit;
	}

	//Save model buffers
	var modelNum = array_length(mBuff);
	if modelNum > 0
	{
		var saveBuff = buffer_create(1, buffer_grow, 1);
		mbuff_write_to_buffer(saveBuff, mBuff)
		buffer_save(saveBuff, fname + ".mbuff");
		buffer_delete(saveBuff);
	}
					
	//Save textures
	var texNum = min(array_length(texPack), modelNum);
	for (var i = 0; i < texNum; i ++)
	{
		sprite_save(texPack[i], 0, string(i) + ".png");
		file_copy(game_save_id + string(i) + ".png", fname + "_" + string(i) + ".png");
		file_delete(string(i) + ".png");
	}
					
	var nodeNum = rig_get_node_number(rig);
	if nodeNum > 0
	{
		//Save rig
		var saveBuff = buffer_create(1, buffer_grow, 1);
		rig_write_to_buffer(saveBuff, rig);
		buffer_save(saveBuff, fname + ".rig");
		buffer_delete(saveBuff);
						
		//Save animations
		var animNum = array_length(animArray);
		for (var i = 0; i < animNum; i ++)
		{
			var saveBuff = buffer_create(1, buffer_grow, 1);
			var animInd = animArray[i];
			anim_write_to_buffer(saveBuff, animInd);
			buffer_save(saveBuff, fname + "_" + animInd.name + ".anim");
			buffer_delete(saveBuff);
		}
	}


}
