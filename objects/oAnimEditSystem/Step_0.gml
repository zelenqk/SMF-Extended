//Check if the window has been resized, and if so, adapt the application surface and GUI
window_resize();

//Update mouse values
mouseX = (window_mouse_get_x() - borderX);
mouseY = (window_mouse_get_y() - borderY);
mouseDx = mouseX - mousePrevX;
mouseDy = mouseY - mousePrevY;
mousePrevX = mouseX;
mousePrevY = mouseY;

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
}

if is_struct(model)
{
	if mouse_check_button_pressed(mb_left) && !array_equals(edtModelTransformM, matrix_build_identity()) && ds_list_size(selList)
	{
		var num = ds_list_size(selList);
		for (var i = 0; i < num; i ++)
		{
			var ind = selList[| i];
			mbuff_transform(mBuff[ind], edtModelTransformM);
			modeleditor_update_wireframe(ind);
			vbuff_delete(vBuff[ind]);
			vBuff[@ ind] = vbuff_create_from_mbuff(mBuff[ind]);
		}
		edtModelTransformM = matrix_build_identity();
		editor_show_message("Applied transformation");
		edtAutosaveModelChanged = true;
		model.Bbox = -1;
	
		//Clear the triangle index model, if it exists
		skineditor_clear_tri_ind_model();
	
		//Clear model selection buffer
		if edtModelSelectBuffer >= 0
		{
			buffer_delete(edtModelSelectBuffer);
			edtModelSelectBuffer = -1;
		}
	}
}
//If the mouse is over one of the 3D views
if edtTmlMove && !mouse_check_button(mb_left)
{
	edtTmlMove = false;
}
if editorScrollmenuActive
{
	press_scroll_menu();
}
else if (mouseX > 0 and mouseY > 0 and mouseX < editWidth * 2 and mouseY < editHeight * 2 and !edtTmlMove)
{
	mousePrevInd = mouseViewInd;
	mouseViewInd = median(1, 4, 2 - (mouseX div editWidth) + 2 * (mouseY div editHeight));
	move_camera();
	perform_actions();
}
else
{
	press_buttons();
	animeditor_modify_timeline();
}

//Animate the model
if (global.editMode == eTab.Animation && edtAnimPlay && is_struct(model))
{
	var animInd = animArray[selAnim];;
	edtAnimPlayTime = frac(edtAnimPlayTime + 1000 / (animInd.playTime * game_get_speed(gamespeed_fps)));
	if !is_array(model.SampleStrip)
	{
		model.SampleStrip = samplestrip_create(model.rig, animInd);
	}
	samplestrip_update_sample(model.SampleStrip, edtAnimPlayTime, model.Sample, true);
	sample_normalize(model.Sample);
}