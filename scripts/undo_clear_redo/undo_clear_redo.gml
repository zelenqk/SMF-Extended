/// @description undo_clear_redo()
function undo_clear_redo() {
	if !editorUndoEnabled{exit;}

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

	var ind = model.UndoIndex;
	if ind < 0 || ind >= ds_list_size(undoList){exit;}
	for (var i = ds_list_size(undoList) - 1; i >= ind; i --)
	{
		ds_list_delete(undoList, i);
	}


}
