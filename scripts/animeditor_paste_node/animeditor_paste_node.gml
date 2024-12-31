function animeditor_paste_node() {
	var str = "";
	if (clipboard_has_text())
	{
		str = clipboard_get_text();
	}
	if (string_copy(str, 1, 4) != "NODE")
	{
		str = edtAnimCopiedNode;
		if str == ""{exit;} //Exit if the clipboard string does not contain info about nodes
	} 
	clipboard_set_text(str);

	var model = edtSMFArray[edtSMFSel];
	var rig = model.rig;
	var nodeList = rig.nodeList;
	var sample = model.Sample;
	var animArray = model.animations;
	var anim = animArray[model.SelAnim];
	var selKeyframe = model.SelKeyframe;
	var keyframeGrid = anim.keyframeGrid;
	var keyframeTime = keyframeGrid[# 0, selKeyframe]
	var pos = string_pos(",", str);
	var selNode = real(string_copy(str, 5, pos - 5));
	if (selNode < 0 || selNode >= ds_list_size(nodeList))
	{
		exit;
	}
	model.SelNode = selNode;

	var Q = global.AnimTempQ1;
	for (var i = 0; i < 8; i ++)
	{
		str = string_delete(str, 1, pos);
		pos = string_pos(",", str);
		Q[@ i] = real(string_copy(str, 1, pos - 1));
	}
	undo_save("Paste node", edtUndoType.AnimLocal);
	editor_show_message("Pasted node " + string(selNode));
	anim_keyframe_set_node_dq(rig, anim, selKeyframe, selNode, Q, edtAnimMoveFromCurrent, edtAnimTransformChildren);
	model.SampleStrip = -1;
	model.Sample = anim_generate_sample(rig, anim, keyframeTime, eAnimInterpolation.Keyframe);


}
