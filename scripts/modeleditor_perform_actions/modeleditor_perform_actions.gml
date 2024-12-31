function modeleditor_perform_actions() {
	//Model settings
	var model = edtSMFArray[edtSMFSel];
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

	var tx, ty, nodeNum, newSelectedBone, i, newPos, bonePos, DQ;
	tx = camTransform[mouseViewInd, 0];
	ty = camTransform[mouseViewInd, 1];
	var mPos = mouseWorldPos;
	var mVec = mouseWorldVec;

	if (mouse_check_button_pressed(mb_left) && mouseViewInd == 1)
	{
		var selModel = modeleditor_select_model();
		if !keyboard_check(vk_shift) && !keyboard_check(vk_control)
		{
			ds_list_clear(selList);
		}
		var ind = ds_list_find_index(selList, selModel);
		if (ind >= 0)
		{
			if keyboard_check(vk_control)
			{
				ds_list_delete(selList, ind);
			}
		}
		else
		{
			ds_list_add(selList, selModel);
		}
	
		if (edtModelIndexScroll > selModel){edtModelIndexScroll = selModel;}
		if (edtModelIndexScroll <= selModel - edtMaxButtons){edtModelIndexScroll = selModel - edtMaxButtons + 1;}
	
		buttons_update();
		selectModelFade = 1;
	}

	if mouse_check_button(mb_left)
	{
		//Modify model
		if mouseViewInd != 1 && mouseViewInd == mousePrevInd
		{
			if selectedTool == eMOD.Move
			{
				if mouse_check_button_pressed(mb_left)
				{
					undo_save("Move model", edtUndoType.Models);
				}
				newPos[0] = edtModelTransformM[12];
				newPos[1] = edtModelTransformM[13];
				newPos[2] = edtModelTransformM[14];
				newPos[tx] += mouseWorldPos[tx] - mouseWorldPrevPos[tx];
				newPos[ty] += mouseWorldPos[ty] - mouseWorldPrevPos[ty];
				edtModelTransformM[12] = newPos[0];
				edtModelTransformM[13] = newPos[1];
				edtModelTransformM[14] = newPos[2];
			}
			if selectedTool == eMOD.Scale
			{
				var scale = 1 + 5 * mouseDx / editWidth;
				if mouse_check_button_pressed(mb_left)
				{
					undo_save("Scale model", edtUndoType.Models);
					scalePos[2] = 0;
					scalePos[tx] = mouseWorldPos[tx];
					scalePos[ty] = mouseWorldPos[ty];
				}
				edtModelTransformM = matrix_multiply(edtModelTransformM, matrix_build(-scalePos[0], -scalePos[1], -scalePos[2], 0, 0, 0, 1, 1, 1));
				edtModelTransformM = matrix_multiply(edtModelTransformM, matrix_build(0, 0, 0, 0, 0, 0, scale, scale, scale));
				edtModelTransformM = matrix_multiply(edtModelTransformM, matrix_build(scalePos[0], scalePos[1], scalePos[2], 0, 0, 0, 1, 1, 1));
			}
			if selectedTool == eMOD.Rotate
			{
				if mouse_check_button_pressed(mb_left)
				{
					undo_save("Rotate model", edtUndoType.Models);
					scalePos[2] = 0;
					scalePos[tx] = mouseWorldPos[tx];
					scalePos[ty] = mouseWorldPos[ty];
				}
				var axis = [1, 1, 1];
				axis[tx] = 0;
				axis[ty] = 0;
				var scale = 1 + 5 * mouseDx / editWidth;
				edtModelTransformM = matrix_multiply(edtModelTransformM, matrix_build(-scalePos[0], -scalePos[1], -scalePos[2], 0, 0, 0, 1, 1, 1));
				edtModelTransformM = matrix_multiply(edtModelTransformM, smf_mat_create_from_axisangle(axis[0], axis[1], axis[2], mouseDx / 3));
				edtModelTransformM = matrix_multiply(edtModelTransformM, matrix_build(scalePos[0], scalePos[1], scalePos[2], 0, 0, 0, 1, 1, 1));
			}
		}
	}


}
