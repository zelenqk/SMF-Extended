function rigeditor_perform_actions() {
	var tx, ty, nodeNum, newedtSelNode, i, newPos, bonePos;
	if mouseViewInd < 1{exit;}

	//Model settings
	var model = -1;
	if (edtSMFSel >= 0)
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
	else
	{
		exit;
	}

	var nodeList = rig.nodeList;
	var bindMap = rig.bindMap;
	var nodeNum = ds_list_size(nodeList);

	tx = camTransform[mouseViewInd, 0];
	ty = camTransform[mouseViewInd, 1];
	var mPos = mouseWorldPos;
	var mVec = mouseWorldVec;


	if mouse_check_button_released(mb_left)
	{
		if selectedTool == RIGADDBONE and selNode >= 0
		{
			selectedTool = RIGMOVEAFTERPLACE;
			exit;
		}
	}


	if (selNode >= 0 && mouse_check_button(mb_left) && edtRigShowPrimaryAxis)
	{
		var cNode = nodeList[| selNode]
		var pNode = nodeList[| cNode[eAnimNode.Parent]];
		var gNode = nodeList[| pNode[eAnimNode.Parent]];
		if (cNode[eAnimNode.IsBone] && pNode[eAnimNode.IsBone])
		{
			var gPos = smf_dq_get_translation(gNode[eAnimNode.WorldDQ]);
			var s = 10000 * camZoom;
			var size = max(camZoom * 20, cNode[eAnimNode.Length] * .3);
			var ray = smf_cast_ray_sphere(gPos[0], gPos[1], gPos[2], size, mPos[0], mPos[1], mPos[2], mPos[0] + mVec[0] * s, mPos[1] + mVec[1] * s, mPos[2] + mVec[2] * s);
			if (is_array(ray))
			{
				if mouse_check_button_pressed(mb_left)
				{
					edtRigSetAxis = true;
				}
				if edtRigSetAxis
				{
					var pAxisX = ray[0] - gPos[0];
					var pAxisY = ray[1] - gPos[1];
					var pAxisZ = ray[2] - gPos[2];
					var l = 1 / sqrt(sqr(pAxisX) + sqr(pAxisY) + sqr(pAxisZ));
					var pAxis = cNode[eAnimNode.PrimaryAxis];
					pAxis[@ 0] = pAxisX * l;
					pAxis[@ 1] = pAxisY * l;
					pAxis[@ 2] = pAxisZ * l;
				}
			}
		}
	}
	else
	{
		edtRigSetAxis = false;
	}
	if edtRigSetAxis
	{
		exit;
	}

	/////////////////////////////////////////
	//Select node
	if mouse_check_button_pressed(mb_left)
	{
		prevNode = selNode;
		if (edtBoneModel >= 0)
		{
			selNode = -1;
			model.SelNode = selNode;
			var maxDp = 0;
			for (var i = 0; i < nodeNum; i ++)
			{
				var node = nodeList[| i];
				var nodePos = smf_dq_get_translation(node[eAnimNode.WorldDQ]);
				var s = 10000 * camZoom;
				var ray = smf_cast_ray_sphere(nodePos[0], nodePos[1], nodePos[2], 7 * camZoom * (.5 + .5 * edtRigScale), mPos[0], mPos[1], mPos[2], mPos[0] + mVec[0] * s, mPos[1] + mVec[1] * s, mPos[2] + mVec[2] * s);
				if (!is_array(ray)){continue;}
				var n = [ray[0] - nodePos[0], ray[1] - nodePos[1], ray[2] - nodePos[2]];
				var l = sqrt(sqr(n[0]) + sqr(n[1]) + sqr(n[2]));
				var dp = - (n[0] * mVec[0] + n[1] * mVec[1] + n[2] * mVec[2]) / l;
				if (dp > maxDp)
				{
					maxDP = dp;
					selNode = i;
					model.SelNode = selNode;
				}
			}
			if (selNode < 0)
			{
				selNode = rigeditor_select_node_from_rig();
				model.SelNode = selNode;
			}
			if (selNode >= 0)
			{
				var num = array_length(rigSubDivs);
				if (selectedTool == subRigsELECTBONE)
				{
					//First delete the node from other subRigs
					for (var i = 0; i < num; i ++)
					{
						var ind = smf_get_array_index(rigSubDivs[i], selNode);
						if (ind >= 0)
						{
							rigSubDivs[i] = _array_delete(rigSubDivs[i], ind);
						}
					}
					//Then add the node to the current subrig
					if (rigSelSubDiv < num)
					{
						var sub = rigSubDivs[rigSelSubDiv];
						sub[@ array_length(sub)] = selNode;
					}
					buttons_update();
					rigeditor_update_skeleton();
				}
				else
				{
					//Select the correct subrig
					for (var i = 0; i < num; i ++)
					{
						if smf_get_array_index(rigSubDivs[i], selNode) >= 0
						{
							rigSelSubDiv = i;
							break;
						}
					}
				}
				//Move the mouse to the node coordinates to avoid accidentally moving the node as soon as you click it
				var cam = view_camera[mouseViewInd];
				var node = nodeList[| selNode]
				var nodePos = smf_dq_get_translation(node[eAnimNode.WorldDQ]);
				var pos = smf_convert_3d_to_2d(nodePos[0], nodePos[1], nodePos[2], camera_get_view_mat(cam), camera_get_proj_mat(cam));
				var xx = borderX + editWidth * (mouseViewInd mod 2);
				var yy = borderY + editHeight * ((mouseViewInd-1) div 2);
				window_mouse_set(xx + editWidth * pos[0] / window_get_width(), yy + editHeight * pos[1] / window_get_height());
			}
		}
	}

	/////////////////////////////////////////
	//Add nodes to rig
	if mouse_check_button_pressed(mb_left)
	{
		if (selNode != prevNode || selNode < 0) && selectedTool == RIGMOVEAFTERPLACE
		{
			selectedTool = RIGADDBONE;
		}
	
		//Add bones
		if (selectedTool == RIGADDBONE && selNode < 0 && mouseViewInd > 1 && (prevNode >= 0 || nodeNum == 0))
		{
			newPos = camPos;
			if prevNode < 0 && nodeNum > 0{prevNode = 0;}
			if prevNode >= 0
			{
				node = nodeList[| prevNode];
				newPos = smf_dq_get_translation(node[eAnimNode.WorldDQ]);
			}
			newPos[tx] = mouseWorldPos[tx];
			newPos[ty] = mouseWorldPos[ty];
			if snapToGrid
			{
				var scale = 8 * power(2, round(log2(camZoom)));
				newPos[tx] = round(newPos[tx] / scale) * scale
				newPos[ty] = round(newPos[ty] / scale) * scale
			}
			undo_save("Add bone", edtUndoType.BindPose);
			selNode = rig_add_node(rig, newPos, prevNode, true);
			node = nodeList[| selNode]
			model.SelNode = selNode;
			selectedTool = RIGMOVEAFTERPLACE;
			rigeditor_update_skeleton();
			edtAutosaveRigChanged = true;
		}
		rigScale = [1, 1, 1];
	}

	/////////////////////////////////////////
	//Modify rig
	if mouse_check_button(mb_left)
	{
		if mouseViewInd != 1
		{
			if selectedTool == RIGMOVE
			{
				if mouse_check_button_pressed(mb_left){undo_save("Move rig", edtUndoType.BindPose);}
				newPos = [0, 0, 0];
				newPos[tx] = mouseDx * camZoom;
				newPos[ty] = mouseDy * camZoom;
				if mouseViewInd != 2{
					newPos[ty] *= -1;
					if mouseViewInd == 3{newPos[tx] *= -1;}}
				var Q = smf_dq_create(0, 1, 0, 0, newPos[0], newPos[1], newPos[2]);
				rig_transform(rig, Q, 1, 1, 1);
				rigeditor_update_skeleton();
				edtAutosaveRigChanged = true;
			}
			if selectedTool == RIGSCALE
			{
				if mouse_check_button_pressed(mb_left){undo_save("Scale rig", edtUndoType.BindPose);}
				scale = [1, 1, 1];
				scale[tx] += 4 * mouseDx / editWidth;
				scale[ty] -= 4 * mouseDy / editWidth;
				rig_transform(rig, smf_dq_create_identity(), scale[0], scale[1], scale[2]);
				rigeditor_update_skeleton();
				edtAutosaveRigChanged = true;
			}
			if selectedTool == RIGROTATE
			{
				if mouse_check_button_pressed(mb_left){undo_save("Rotate rig", edtUndoType.BindPose);}
				axis = [1, 1, 1];
				axis[tx] = 0;
				axis[ty] = 0;
				angle = mouseDx / editWidth * 5;
				rig_transform(rig, smf_dq_create(angle, axis[0], axis[1], axis[2], 0, 0, 0), 1, 1, 1);
				rigeditor_update_skeleton();
				edtAutosaveRigChanged = true;
			}
		}
	}

	/////////////////////////////////////////
	//Modify bone
	if mouse_check_button(mb_left) and selNode >= 0
	{
		if (selectedTool == RIGMOVEAFTERPLACE || selectedTool == RIGMOVEBONE) && mouseViewInd > 1
		{
			if mouse_check_button_pressed(mb_left){undo_save("Move node", edtUndoType.BindPose);}
			if mouseViewInd != mousePrevInd
			{
				selNode = -1;
				model.SelNode = selNode;
				exit;
			}
			var node = nodeList[| selNode]
			newPos = smf_dq_get_translation(node[eAnimNode.WorldDQ]);
			newPos[tx] = mouseWorldPos[tx];
			newPos[ty] = mouseWorldPos[ty];
			if snapToGrid
			{
				scale = 8 * power(2, floor(log2(camZoom)));
				newPos[tx] = round(newPos[tx] / scale) * scale
				newPos[ty] = round(newPos[ty] / scale) * scale
			}
			rig_move_node(rig, selNode, newPos[0], newPos[1], newPos[2]);
			rigeditor_update_skeleton();
			edtAutosaveRigChanged = true;
		}
		if (selectedTool == RIGROTATEBONE)
		{
			rig_rotate_node(rig, selNode, mouseDx / 40);
			rigeditor_update_skeleton();
			edtAutosaveRigChanged = true;
		}
	}


}
