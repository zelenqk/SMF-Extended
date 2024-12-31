/// @description switch_to_modeleditor()
function switch_to_modeleditor() {
	var model = edtSMFArray[edtSMFSel];
	if (edtAutosaveRigChanged)
	{
		autosave_save(edtAutosaveType.BindPose);
		edtAutosaveRigChanged = false;
	}
	global.editMode = eTab.Model;
	selectedTool = edtModSelTool;
	buttons_update();
	model.Sample = [0, 0, 0, 1, 0, 0, 0, 0];


}
