/// @description
if global.editMode == eTab.Rigging
{
	if (edtSMFSel < 0){exit;}
	var model = edtSMFArray[edtSMFSel];
	if model.SelNode >= 0
	{
		undo_save("Delete node", edtUndoType.Everything);
		rigeditor_delete_node(model.SelNode);
		rigeditor_update_skeleton();
		model.SelNode = min(model.SelNode, rig_get_node_number(model.rig)-1);
		model.Sample = [0, 0, 0, 1, 0, 0, 0, 0]; //Clear the sample whenever we modify the rig
	}
}