/// @description autosave_save(type)
/// @param type
function autosave_save(argument0) {
	var type = argument0;
	edtAutosaveAvailable = false;

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
	var modelNum = array_length(mBuff);
	var nodeNum = 0;
	if is_struct(rig){ds_list_size(rig.nodeList);}
	var texNum = array_length(texPack);
	if (texNum == 0)
	{	//An exception occurs if there are no textures loaded
		texPack[0] = texWhite;
		texNum = 1;
	}

	var path = "Autosave/";
	var saveBuff = buffer_create(1, buffer_grow, 1);
	switch type
	{
		case edtAutosaveType.Models:
			//Clear out old models first
			var fname = file_find_first(path + "*.mbuff", 0);
			while fname != ""
			{
				file_delete(fname);
				fname = file_find_next();
			}
			file_find_close();
			//Then save models
			for (var i = 0; i < array_length(mBuff); i ++)
			{
				buffer_seek(saveBuff, buffer_seek_start, 0);
				buffer_write(saveBuff, buffer_string, edtSavePath);
				mbuff_write_to_buffer(saveBuff, mBuff[i]);
				buffer_write(saveBuff, buffer_u8, vis[i]); //Write visible
				buffer_write(saveBuff, buffer_u8, texPack[i mod texNum]); //Write texture index
				buffer_save(saveBuff, path + string(i) + ".mbuff");
			}
			break;
		
		case edtAutosaveType.Textures:
			//Clear out old textures
			var fname = file_find_first(path + "*.png", 0);
			while fname != ""
			{
				file_delete(fname);
				fname = file_find_next();
			}
			file_find_close();
			//Then save textures
			for (var i = 0; i < texNum; i ++)
			{
				sprite_save(texPack[i], 0, path + string(texPack[i]) + ".png");
			}
			break;
		
		case edtAutosaveType.BindPose:
			if !is_struct(rig){break;}
			buffer_seek(saveBuff, buffer_seek_start, 0);
			rig_write_to_buffer(saveBuff, rig);
			buffer_save(saveBuff, path + "Rig.rig");
			break;
		
		case edtAutosaveType.SelectedAnimation:
			if (selAnim >= 0 && selAnim < array_length(animArray))
			{
				buffer_seek(saveBuff, buffer_seek_start, 0);
				anim_write_to_buffer(saveBuff, animArray[selAnim]);
				buffer_save(saveBuff, path + string(selAnim) + ".anim");
			}
			break;
		
		case edtAutosaveType.AllAnimations:
			//Clear out old animations first
			var fname = file_find_first(path + "*.anim", 0);
			while fname != ""
			{
				file_delete(fname);
				fname = file_find_next();
			}
			file_find_close();
			for (var i = 0; i < array_length(animArray); i ++)
			{
				buffer_seek(saveBuff, buffer_seek_start, 0);
				anim_write_to_buffer(saveBuff, animArray[i]);
				buffer_save(saveBuff, path + string(i) + ".anim");
			}
			break;
		
		case edtAutosaveType.Everything:
			if (modelNum == 0 && texNum == 0 && nodeNum == 0){break;}
			directory_destroy("Autosave");
			autosave_save(edtAutosaveType.Models);
			autosave_save(edtAutosaveType.Textures);
			autosave_save(edtAutosaveType.BindPose);
			autosave_save(edtAutosaveType.AllAnimations);
			break;
	}
	buffer_delete(saveBuff);


}
