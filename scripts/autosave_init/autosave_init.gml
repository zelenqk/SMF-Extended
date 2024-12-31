/// @description autosave_init()
function autosave_init() {
	globalvar edtAutosaveEnabled, edtAutosaveModelChanged, edtAutosaveTexturesChanged, edtAutosaveRigChanged, edtAutosaveAvailable;
	edtAutosaveEnabled = true;
	edtAutosaveModelChanged = false;
	edtAutosaveTexturesChanged = false;
	edtAutosaveRigChanged = false;
	edtAutosaveAvailable = false;

	var fname = file_find_first("Autosave/*.mbuff", 0);
	file_find_close();
	if (fname != "")
	{
		edtAutosaveAvailable = true;
	}

	enum edtAutosaveType
	{
		Textures,
		Models,
		BindPose,
		SelectedAnimation,
		AllAnimations,
		Everything
	}


}
