function animeditor_copy_node() {
	var model = edtSMFArray[edtSMFSel];
	var selNode = model.SelNode;
	if (selNode < 0){exit;}
	var rig = model.rig;
	var sample = model.Sample;

	var str = "NODE" + string(selNode) + ",";
	var Q = sample_get_node_dq(rig, selNode, sample, global.AnimTempQ1);
	for (var i = 0; i < 8; i ++)
	{
		str += string_format(Q[i], 1, 20) + ",";
	}

	clipboard_set_text(str);
	edtAnimCopiedNode = str;
	editor_show_message("Copied node " + string(selNode));


}
