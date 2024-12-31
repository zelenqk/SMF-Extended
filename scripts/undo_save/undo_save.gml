/// @description undo_save(text, type)
/// @param text
/// @param type
function undo_save(argument0, argument1) {
	if !editorUndoEnabled{exit;}

	//Model settings
	var model = -1;
	if edtSMFSel >= 0
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

	var name = "Undo" + string(edtSMFSel) + "/" + string(argument0) + "_" + string(model.UndoIndex div 2);
	var type = argument1;

	//If we're saving a new undo image, delete all undone changes
	while (ds_list_size(undoList) > model.UndoIndex)
	{
		ds_list_delete(undoList, model.UndoIndex);
	}

	//Add this image to the undo list
	ds_list_add(undoList, name, type);

	//Save the relevant file
	var saveBuff = buffer_create(1, buffer_grow, 1);
	switch type
	{
		case edtUndoType.Models:
			mbuff_write_to_buffer(saveBuff, mBuff);
			var texNum = array_length(texPack);
			buffer_write(saveBuff, buffer_u16, texNum);
			for (var i = 0; i < texNum; i ++){			
				buffer_write(saveBuff, buffer_u16, texPack[i]);}
			break;
		
		case edtUndoType.BindPose:
			rig_write_to_buffer(saveBuff, rig);
			break;
		
		case edtUndoType.AnimLocal:
			if (selAnim < 0 || array_length(animArray) <= 0)
			{
				buffer_write(saveBuff, buffer_u16, 9999);
			}
			else
			{
				buffer_write(saveBuff, buffer_u16, selAnim);
				buffer_write(saveBuff, buffer_u8, selKeyframe);
				anim_write_to_buffer(saveBuff, animArray[selAnim]);
			}
			break;
		
		case edtUndoType.Animation:
			var num = array_length(animArray);
			buffer_write(saveBuff, buffer_u8, num);
			for (var i = 0; i < num; i ++)
			{
				anim_write_to_buffer(saveBuff, animArray[i]);
			}
			break;
		
		case edtUndoType.Everything:
			//Save models
			mbuff_write_to_buffer(saveBuff, mBuff);
			//Save textures
			var texNum = array_length(texPack);
			buffer_write(saveBuff, buffer_u16, texNum);
			for (var i = 0; i < texNum; i ++)
			{			
				buffer_write(saveBuff, buffer_u16, texPack[i]);
			}
			//Save rig
			rig_write_to_buffer(saveBuff, rig);
			//Save animations
			var num = array_length(animArray);
			buffer_write(saveBuff, buffer_u8, num);
			for (var i = 0; i < num; i ++)
			{
				anim_write_to_buffer(saveBuff, animArray[i]);
			}
			break;
	}
	buffer_save(saveBuff, name);
	buffer_delete(saveBuff);

	model.UndoIndex = ds_list_size(undoList);

	buttons_update();


}
