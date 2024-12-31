function switch_to_skineditor() {
	var model = edtSMFArray[edtSMFSel];
	if (edtAutosaveTexturesChanged)
	{
		autosave_save(edtAutosaveType.Textures);
		edtAutosaveTexturesChanged = false;
	}
	if (edtAutosaveRigChanged)
	{
		autosave_save(edtAutosaveType.BindPose);
		edtAutosaveRigChanged = false;
	}
	global.editMode = eTab.Skinning;
	selectedTool = edtSkinSelTool;
	buttons_update();
	model.Sample = sample_create_bind(model.rig);
	model.SelNode = -1;
	if (edtAutosaveModelChanged)
	{
		skineditor_clear_tri_ind_model();
	}


}
