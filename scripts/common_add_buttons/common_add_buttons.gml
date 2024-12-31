function common_add_buttons() {
	//Add common buttons
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
		var undoIndex = model.UndoIndex;
	}

	//Undo
	xx = window_get_width() - 127;
	yy = 0;
	add_button(xx, 16 * (yy++), sCategory, "Autosave", "", "");
	add_button(xx, 16 * (yy++), sToggle, "Enable autosave", "When autosave is enabled, certain actions may perform slower. \nThis will automatically save changes to the model in a backup folder, \nwhich can be loaded when you restart the program.", "TOGGLEAUTOSAVE");
	add_button(xx, 16 * (yy++), sCategory, "Undo", "", "");
	add_button(xx, 16 * (yy++), sToggle, "Enable undo/redo", "When undo/redo is enabled, certain actions may perform slower, \nsince the system needs to backup the model for each action.\nIt may still be worth it though!", "TOGGLEUNDO");
	if (model < 0)
	{
		add_button(xx, 16 * yy, sButtonHalf, "Undo", "No actions to undo", "UNDO");
		add_button(xx + 64, 16 * (yy++), sButtonHalf, "Redo", "No actions to redo", "REDO");
	}
	else
	{
		var undoText = undoList[| undoIndex-2];
		if is_undefined(undoText){undoText = "No actions to undo";}
		else{undoText = "Undo " + string_copy(undoText, 6, string_pos("_", undoText) - 6);}
		add_button(xx, 16 * yy, sButtonHalf, "Undo", undoText, "UNDO");
		var redoText = undoList[| undoIndex];
		if is_undefined(redoText){redoText = "No actions to redo";}
		else{redoText = "Redo " + string_copy(redoText, 6, string_pos("_", redoText) - 6);}
		add_button(xx + 64, 16 * (yy++), sButtonHalf, "Redo", redoText, "REDO");
	}

	if (global.editMode == eTab.Model || global.editMode == eTab.Skinning)
	{
		xx = 128 + editWidth * 2 + 1;
		yy += .5;
	
		add_button(xx, 16 * (yy++), sCategory, "Submodels", "", "");
		if global.editMode == eTab.Model
		{
			add_button(xx, 16 * (yy++), sButton, "Load model", "Load a new model, deleting all the existing models", "LOADMODEL");
			add_button(xx, 16 * (yy++), sButton, "Add model", "Adds sub models to the current model", "ADDMODEL");
			yy += .5;
		}
	
		var subModelNum = 0;
		if (edtSMFSel >= 0)
		{
			var model = edtSMFArray[edtSMFSel];
			subModelNum = array_length(model.mBuff);
		}
		edtMaxButtons = floor((editHeight * 2) div 24 - yy * 16 / 24 - 3);
		edtModelIndexScroll = max(min(edtModelIndexScroll, subModelNum - edtMaxButtons), 0);
		if subModelNum > 0
		{
			if edtModelIndexScroll
			{
				add_button(xx, 16 * yy, sModelScrollUp, "", "", "MODELSCROLLUP");
			}
			yy ++;
		
			var dy = yy * 16 + 6;
			var i = 0;
			while i < min(edtMaxButtons, subModelNum)
			{
				add_button(xx, dy + i * 24, sModelTab, "         " + string(edtModelIndexScroll + i), "", "SUBMODEL" + string(edtModelIndexScroll + i));
				i ++;
			}
			yy += 24 / 16 * i;
			if subModelNum > edtModelIndexScroll + edtMaxButtons
			{
				add_button(xx, 16 * yy, sModelScrollDown, "", "", "MODELSCROLLDOWN");
			}
			yy ++;
			yy ++;
			add_button(xx, 16 * (yy++), sCategory, "Submodels", "", "");
			add_button(xx, 16 * (yy++), sButton, "Select all", "Adds all sub models to selection", "SELECTALL");
			add_button(xx, 16 * (yy++), sButton, "Unhide all", "Makes all submodels visible", "MAKEVISIBLE");
			add_button(xx, 16 * (yy++), sButton, "Hide selected", "Makes all selected submodels invisible", "MAKESELECTEDINVISIBLE");
			add_button(xx, 16 * (yy++), sButton, "Hide unselected", "Makes all unselected submodels invisible", "MAKEUNSELECTEDINVISIBLE");
			add_button(xx, 16 * (yy++), sButton, "Merge same textures", "Merge all submodels that use the same texture", "MERGESAME");
		}
	}

	xx = 1;
	yy = 0;
	add_button(128 * (xx++), 16 * yy, sTab, "Model [1]", "Import and modify the model", "MODELEDITOR");
	add_button(128 * (xx++), 16 * yy, sTab, "Rigging [2]", "Create a rig for the model", "RIGGING");
	add_button(128 * (xx++), 16 * yy, sTab, "Skinning [3]", "Skin the model", "SKINNING");
	add_button(128 * (xx++), 16 * yy, sTab, "Animation [4]", "Animate the rig", "ANIMATION");

	xx = 0;
	yy = 0;
	add_button(0, 16 * (yy++), sCategory, "Settings", "", "");
	add_button(0, 16 * (yy++), sToggle, "Toggle 3D wireframe", "", "TOGGLEWIREFRAME");
	add_button(0, 16 * (yy++), sToggle, "Toggle texture", "This will toggle texture drawing on the model", "TOGGLETEXTURE");
	add_button(0, 16 * (yy++), sToggle, "Toggle culling", "Toggles backface culling", "TOGGLECULLING");
	add_button(0, 16 * (yy++), sToggle, "Toggle tex repeat", "Toggles repeating textures", "TOGGLEDTEXREPEAT");
	add_button(0, 16 * (yy++), sToggle, "Toggle tex filter", "Toggles texture filtering", "TOGGLEDTEXFILTER");
	add_button(0, 16 * (yy++), sToggle, "Toggle grid", "Toggles drawing grid", "TOGGLEDRAWGRID");
	add_button(0, 16 * (yy++), sToggle, "Toggle shader", "Turn on or off the default SMF shader. \nWhen on, it will render the model with a diffuse light, a slight specular highlight and rim lighting.\nWhen off, it will only animate the model.", "TOGGLESHADER");
	if (global.editMode == eTab.Rigging || global.editMode == eTab.Animation)
	{
		add_button(0, 16 * (yy++), sToggle, "Snap to grid", "Only works in Rigging mode and when moving frames in animation mode", "TOGGLESNAP");
	}
	add_button(0, 16 * (yy++), sToggle, "Draw node indices", "", "TOGGLENODES");
	add_button(0, 16 * (yy++), sToggle, "Node perspective", "", "TOGGLENDOEPERSPECTIVE");
	add_button(0, 16 * (yy++), sToggle, "Draw rig", "", "TOGGLESKELETON");
	add_button(0, 16 * (yy++), sSlider, "", "", "RIGOPACITY");
	add_button(0, 16 * (yy++), sSlider, "", "", "RIGSCALE");
	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "File", "", "");
	add_button(0, 16 * (yy++), sToggle, "Include textures", "Include textures in the model file. \nDisabling this will export the textures as separate files", "INCLUDETEX");
	add_button(0, 16 * (yy++), sButton, "Save", "Save the project to an SMF v7 file", "SAVE");
	add_button(0, 16 * (yy++), sButton, "Save as", "Save the project to a new SMF v7 file", "SAVEAS");
	add_button(0, 16 * (yy++), sButton, "Export SMF v1", "Saves your project to a backwards compatible version of SMF.", "SAVESMFCOMP");

	if edtAutosaveAvailable
	{
		add_button(64 + editWidth, 64 - 8, sButton, "Load autosave", "An autosaved version from previous session is available.\nClick this button to load it..", "LOADAUTOSAVE");
	}

	/*
	add_button(129 + editWidth * 2, 64 + 2 * editHeight - 32, sCategory, "GUI scale", "", "");
	add_button(129 + editWidth * 2, 64 + 2 * editHeight - 16, sSlider, "", "Scale the GUI.", "GUISCALE");
	//add_button(0, 16 * (yy++), sButton, "Export OBJ", "Exports the vertex buffers to an OBJ file. Note, the OBJ file will not be optimized", "EXPORTOBJ");

/* end common_add_buttons */
}
