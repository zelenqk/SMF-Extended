/// @description Save/save as
//Load model settings
if keyboard_check(vk_control)
{
	if (edtSMFSel < 0){exit;}
	var model = edtSMFArray[edtSMFSel];
	if (edtSavePath == "" || keyboard_check(vk_shift))
	{
		edtSavePath = get_save_filename("smf|*.smf", filename_change_ext(edtSavePath, ".smf"));
		if edtSavePath == ""{exit;}
	}
	smf_model_save(model, edtSavePath, IncludeTex);
	if !IncludeTex
	{
		//Save textures
		var mBuff = model.texPack;
		var texPack = model.texPack;
		var texNum = min(array_length(texPack), array_length(mBuff));
		for (var i = 0; i < texNum; i ++)
		{
			sprite_save(texPack[i], 0, string(i) + ".png");
			file_copy(game_save_id + string(texPack[i]) + ".png", filename_change_ext(edtSavePath, "_" + string(texPack[i]) + ".png"));
			file_delete(string(i) + ".png");
		}
	}
	editor_show_message("Saved project");
}