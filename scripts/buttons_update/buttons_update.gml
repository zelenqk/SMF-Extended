///description buttons_update()
function buttons_update() {
	with oAnimEditButton{instance_destroy();}

	common_add_buttons();
	switch global.editMode
	{
		case eTab.Model:
			modeleditor_add_buttons();
			break;
		case eTab.Rigging:
			rigeditor_add_buttons();
			break;
		case eTab.Skinning:
			skineditor_add_buttons();
			break;
		case eTab.Animation:
			animeditor_add_buttons();
			break;
	}


}
