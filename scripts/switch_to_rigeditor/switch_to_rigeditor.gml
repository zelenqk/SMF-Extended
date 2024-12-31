function switch_to_rigeditor() {
	var model = edtSMFArray[edtSMFSel];
	global.editMode = eTab.Rigging;
	selectedTool = edtRigSelTool;
	buttons_update();
	model.Sample = [0, 0, 0, 1, 0, 0, 0, 0];
	model.SelNode = -1;


}
