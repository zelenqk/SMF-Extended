function perform_actions() {
	var tx, ty, nodeNum, newSelectedBone, i, newPos, bonePos, DQ;
	if mouseViewInd < 1{exit;}
	if selectedSlider >= 0
	{
		if !mouse_check_button(mb_left){selectedSlider = -1;}
		else{exit;}
	}

	switch global.editMode
	{
		case eTab.Model:
			modeleditor_perform_actions();
			break;
		case eTab.Rigging:
			rigeditor_perform_actions();
			break;
		case eTab.Skinning:
			skineditor_perform_actions();
			break;
		case eTab.Animation:
			animeditor_perform_actions();
			break;
	}


}
