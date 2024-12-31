function animeditor_perform_actions() {
	var tx, ty;
	tx = camTransform[mouseViewInd, 0];
	ty = camTransform[mouseViewInd, 1];
	var mPos = mouseWorldPos;
	var mVec = mouseWorldVec;

	var animation = -1; 
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
	if selAnim < array_length(animArray)
	{
		animation = animArray[selAnim];;
	}

	if (rig.boneNum == 0){exit;}

	var nodeList = rig.nodeList;
	var bindMap = rig.bindMap;
	var nodeNum = ds_list_size(nodeList);
	var node, nodePos, ray;

	if mouse_check_button(mb_left) && animation >= 0
	{
		edtAnimPlay = false;
		var keyframeGrid = animation.keyframeGrid;
		var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
		model.Sample = anim_generate_sample(rig, animation, keyframeTime, eAnimInterpolation.Keyframe);
	}
	if mouse_check_button(mb_middle) || mouse_check_button(mb_right) || !mouse_check_button(mb_left)
	{
		edtAnimSelectedHandle = -1;
	}
	if (mouse_check_button_pressed(mb_left) || mouse_check_button_released(mb_left) || edtAnimHandleMatrix != camera_get_view_mat(view_camera[mouseViewInd])) && selNode >= 0
	{
		animeditor_update_selecthandle_surface();
	}
	edtAnimMouseoverHandle = -1;
	if (selNode >= 0 && edtAnimSelectedHandle < 0 && edtAnimHandleBuffer >= 0)
	{
		animeditor_mouseover_handle();
	}

	//Select node
	if mouse_check_button_pressed(mb_left)
	{
		//If there is no animation loaded, create one
		if (array_length(animArray) < 1)
		{
			editor_show_message("Create an animation first! Click \"New animation\" -->");
			exit;
		}
		if (edtAnimMouseoverHandle >= 0)
		{
			edtAnimSelectedHandle = edtAnimMouseoverHandle;
			edtAnimRotPrevVec = -1;
		}
		if (nodeNum > 0 && edtAnimSelectedHandle < 0)
		{
			prevNode = selNode;
			selNode = -1;
			model.SelNode = selNode;
			var maxDp = 0;
			for (var i = 0; i < nodeNum; i ++)
			{
				if (selNode < 0 || i == prevNode)
				{
					nodePos = smf_dq_get_translation(sample_get_node_dq(rig, i, model.Sample));
					var s = 10000 * camZoom;
					var ray = smf_cast_ray_sphere(nodePos[0], nodePos[1], nodePos[2], 7 * camZoom * (.5 + .5 * edtRigScale), mPos[0], mPos[1], mPos[2], mPos[0] + mVec[0] * s, mPos[1] + mVec[1] * s, mPos[2] + mVec[2] * s);
					if (!is_array(ray)){continue;}
					var n = [ray[0] - nodePos[0], ray[1] - nodePos[1], ray[2] - nodePos[2]];
					var l = sqrt(sqr(n[0]) + sqr(n[1]) + sqr(n[2]));
					var dp = - (n[0] * mVec[0] + n[1] * mVec[1] + n[2] * mVec[2]) / l;
					if (dp > maxDp)
					{
						maxDp = dp;
						selNode = i;
						model.SelNode = i;
					}
				}
			}
		
			if (selNode < 0)
			{
				selNode = rigeditor_select_node_from_rig();
				model.SelNode = selNode;
			}
			if (selNode > 0)
			{
				//Update sample
				var animInd = animArray[selAnim];
				var keyframeGrid = animInd.keyframeGrid;
				var keyframeTime = keyframeGrid[# 0, selKeyframe]
				model.Sample = anim_generate_sample(rig, animInd, keyframeTime, eAnimInterpolation.Keyframe);
					
				//Move the mouse to the node coordinates to avoid accidentally moving the node as soon as you click it
				if (selectedTool == ANIMOVENODE || selectedTool == ANIDRAGNODE)
				{
					var cam = view_camera[mouseViewInd];
					var nodePos = smf_dq_get_translation(sample_get_node_dq(rig, selNode, model.Sample));
					var pos = smf_convert_3d_to_2d(nodePos[0], nodePos[1], nodePos[2], camera_get_view_mat(cam), camera_get_proj_mat(cam));
					var xx = borderX + editWidth * (mouseViewInd mod 2);
					var yy = borderY + editHeight * ((mouseViewInd-1) div 2);
					window_mouse_set(xx + editWidth * pos[0] / window_get_width(), yy + editHeight * pos[1] / window_get_height());
					exit;
				}
			}
		}
	}

	if (mouse_check_button(mb_left) && selNode >= 0)
	{
		edtAnimPlay = false;
		model.SampleStrip = -1;
		if (selectedTool == ANIMOVENODE)
		{
			var node = nodeList[| selNode];
			if (array_length(edtAnimTempSample) == 0)
			{
				undo_save("Move node IK", edtUndoType.AnimLocal);
				rig_lock_positions(rig, model.Sample);
				array_copy(edtAnimTempSample, 0, model.Sample, 0, array_length(model.Sample));
				edtAnimIKPos = sample_get_node_position(rig, selNode, edtAnimTempSample);
			}
			var newPos = edtAnimIKPos;
			if (mouseViewInd == 1)
			{
				var Nx = dcos(camPos[3]) * dcos(camPos[4]);
				var Ny = dsin(camPos[3]) * dcos(camPos[4]);
				var Nz = dsin(camPos[4]);
				var newPos = cast_ray_plane(edtAnimIKPos[0], edtAnimIKPos[1], edtAnimIKPos[2], Nx, Ny, Nz, mPos[0], mPos[1], mPos[2], mPos[0] + mVec[0] * 100000 * camZoom, mPos[1] + mVec[1] * 100000 * camZoom, mPos[2] + mVec[2] * 100000 * camZoom);
				if snapToGrid
				{
					var scale = 8 * power(2, round(log2(camZoom)));
					newPos[0] = round(newPos[0] / scale) * scale;
					newPos[1] = round(newPos[1] / scale) * scale;
					newPos[2] = round(newPos[2] / scale) * scale;
				}
			}
			else
			{
				var newPos = edtAnimIKPos;
				newPos[tx] = mPos[tx];
				newPos[ty] = mPos[ty];
				if snapToGrid
				{
					var scale = 8 * power(2, round(log2(camZoom)));
					newPos[tx] = round(newPos[tx] / scale) * scale;
					newPos[ty] = round(newPos[ty] / scale) * scale;
				}
			}
			array_copy(model.Sample, 0, edtAnimTempSample, 0, array_length(edtAnimTempSample));
			sample_node_move(rig, selNode, model.Sample, newPos[0], newPos[1], newPos[2], edtAnimMoveFromCurrent, edtAnimTransformChildren);
			animArray[selAnim].update_locked_bones_in_sample(rig, selNode, model.Sample, edtAnimTransformChildren);
		}
		if (selectedTool == ANIDRAGNODE)
		{
			var node = nodeList[| selNode];
			if (array_length(edtAnimTempSample) == 0)
			{
				undo_save("Drag node", edtUndoType.AnimLocal);
				rig_lock_positions(rig, model.Sample);
				array_copy(edtAnimTempSample, 0, model.Sample, 0, array_length(model.Sample));
				edtAnimIKPos = sample_get_node_position(rig, selNode, edtAnimTempSample);
			}
			if (mouseViewInd == 1)
			{
				var Nx = dcos(camPos[3]) * dcos(camPos[4]);
				var Ny = dsin(camPos[3]) * dcos(camPos[4]);
				var Nz = dsin(camPos[4]);
				var newPos = cast_ray_plane(edtAnimIKPos[0], edtAnimIKPos[1], edtAnimIKPos[2], Nx, Ny, Nz, mPos[0], mPos[1], mPos[2], mPos[0] + mVec[0] * 100000 * camZoom, mPos[1] + mVec[1] * 100000 * camZoom, mPos[2] + mVec[2] * 100000 * camZoom);
				if snapToGrid
				{
					var scale = 8 * power(2, round(log2(camZoom)));
					newPos[0] = round(newPos[0] / scale) * scale;
					newPos[1] = round(newPos[1] / scale) * scale;
					newPos[2] = round(newPos[2] / scale) * scale;
				}
			}
			else
			{
				var newPos = edtAnimIKPos;
				newPos[tx] = mPos[tx];
				newPos[ty] = mPos[ty];
				if snapToGrid
				{
					var scale = 8 * power(2, round(log2(camZoom)));
					newPos[tx] = round(newPos[tx] / scale) * scale;
					newPos[ty] = round(newPos[ty] / scale) * scale;
				}
			}
		
			array_copy(model.Sample, 0, edtAnimTempSample, 0, array_length(edtAnimTempSample));
			sample_node_drag(rig, selNode, model.Sample, newPos[0], newPos[1], newPos[2], edtAnimTransformChildren);
			animArray[selAnim].update_locked_bones_in_sample(rig, selNode, model.Sample, edtAnimTransformChildren);
		}
		if (selectedTool == ANIROTATELOCAL && edtAnimSelectedHandle >= 0)
		{
			var node = nodeList[| selNode];
			var boneLength = node[eAnimNode.Length];
			var loopSize = max(boneLength / 2, camZoom * 30);
			var nodeMat = anim_keyframe_get_node_matrix(rig, animArray[selAnim], selKeyframe, selNode);
			nodeMat[12] -= boneLength * nodeMat[0];
			nodeMat[13] -= boneLength * nodeMat[1];
			nodeMat[14] -= boneLength * nodeMat[2];
			var bonePos = [nodeMat[12], nodeMat[13], nodeMat[14]];
			if (mouse_check_button_pressed(mb_left))
			{
				undo_save("Rotate local", edtUndoType.AnimLocal);
				rig_lock_positions(rig, model.Sample);
				array_copy(edtAnimTempSample, 0, model.Sample, 0, array_length(model.Sample));
			}
		
			var N;
			switch edtAnimSelectedHandle{
				case 0:
					N = [nodeMat[8], nodeMat[9], nodeMat[10]];
					break;
				case 1:
					N = [nodeMat[4], nodeMat[5], nodeMat[6]];
					break;
				case 2:
					N = [nodeMat[0], nodeMat[1], nodeMat[2]];
					break;}
			var rotMousePos;
			var s = 100000 * camZoom;
			if abs(smf_vector_dot(smf_vector_normalize(smf_vector_subtract(mPos, bonePos)), N)) > 0.15
			{
				rotMousePos = cast_ray_plane(bonePos[0], bonePos[1], bonePos[2], N[0], N[1], N[2], mPos[0], mPos[1], mPos[2], mPos[0] + mVec[0] * s, mPos[1] + mVec[1] * s, mPos[2] + mVec[2] * s);
			}
			else
			{
				var V =smf_vector_normalize(smf_vector_subtract(mPos, bonePos));
				var l = loopSize * .9;
				rotMousePos = cast_ray_plane(bonePos[0] + V[0] * l, bonePos[1] + V[1] * l, bonePos[2] + V[2] * l, V[0], V[1], V[2], mPos[0], mPos[1], mPos[2], mPos[0] + mVec[0] * s, mPos[1] + mVec[1] * s, mPos[2] + mVec[2] * s);
				if !rotMousePos[6]
				{
					exit;
				}
			}
			if (!is_array(rotMousePos))
			{
				edtAnimSelectedHandle = -1;
				exit;
			}
			edtAnimRotCurrVec =smf_vector_normalize(smf_vector_orthogonalize(N,smf_vector_subtract(rotMousePos, bonePos)));
			if mouse_check_button_pressed(mb_left)
			{
				edtAnimRotStartVec = edtAnimRotCurrVec;
			}
		
			var s =smf_vector_dot(N,smf_vector_cross(edtAnimRotCurrVec, edtAnimRotStartVec));
			var c =smf_vector_dot(edtAnimRotCurrVec, edtAnimRotStartVec); 
			var angle = - arctan2(s, c);
		
			array_copy(model.Sample, 0, edtAnimTempSample, 0, array_length(edtAnimTempSample));
			switch edtAnimSelectedHandle
			{
				case 2: sample_node_roll(rig, selNode, model.Sample, angle, edtAnimTransformChildren); break;	
				case 1: sample_node_pitch(rig, selNode, model.Sample, angle, edtAnimTransformChildren); break;	
				case 0: sample_node_yaw(rig, selNode, model.Sample, angle, edtAnimTransformChildren); break;	
			}
			animArray[selAnim].update_locked_bones_in_sample(rig, selNode, model.Sample, edtAnimTransformChildren);
		}
		if (selectedTool == ANIROTATEGLOBAL && edtAnimSelectedHandle >= 0)
		{
			var node = nodeList[| selNode];
			var boneLength = node[eAnimNode.Length];
			var loopSize = max(boneLength / 2, camZoom * 30);
			var nodeMat = anim_keyframe_get_node_matrix(rig, animArray[selAnim], selKeyframe, selNode);
			nodeMat[12] -= boneLength * nodeMat[0];
			nodeMat[13] -= boneLength * nodeMat[1];
			nodeMat[14] -= boneLength * nodeMat[2];
			var bonePos = [nodeMat[12], nodeMat[13], nodeMat[14]];
			if mouse_check_button_pressed(mb_left)
			{
				undo_save("Rotate global", edtUndoType.AnimLocal);
				rig_lock_positions(rig, model.Sample);
				array_copy(edtAnimTempSample, 0, model.Sample, 0, array_length(model.Sample));
			}
	
			var N;
			switch edtAnimSelectedHandle{
				case 0:
					N = [0, 0, 1];
					break;
				case 1:
					N = [0, 1, 0];
					break;
				case 2:
					N = [1, 0, 0];
					break;}
			var rotMousePos;
			var s = 100000 * camZoom;
			if abs(smf_vector_dot(smf_vector_normalize(smf_vector_subtract(mPos, bonePos)), N)) > 0.15
			{
				rotMousePos = cast_ray_plane(bonePos[0], bonePos[1], bonePos[2], N[0], N[1], N[2], mPos[0], mPos[1], mPos[2], mPos[0] + mVec[0] * s, mPos[1] + mVec[1] * s, mPos[2] + mVec[2] * s);
			}
			else
			{
				var V =smf_vector_normalize(smf_vector_subtract(mPos, bonePos));
				var l = loopSize * .5;
				rotMousePos = cast_ray_plane(bonePos[0] + V[0] * l, bonePos[1] + V[1] * l, bonePos[2] + V[2] * l, V[0], V[1], V[2], mPos[0], mPos[1], mPos[2], mPos[0] + mVec[0] * s, mPos[1] + mVec[1] * s, mPos[2] + mVec[2] * s);
				if !rotMousePos[6]
				{
					exit;
				}
			}
			if (!is_array(rotMousePos))
			{
				edtAnimSelectedHandle = -1;
				exit;
			}
			edtAnimRotCurrVec =smf_vector_normalize(smf_vector_orthogonalize(N,smf_vector_subtract(rotMousePos, bonePos)));
			if mouse_check_button_pressed(mb_left)
			{
				edtAnimRotStartVec = edtAnimRotCurrVec;
				edtAnimRotPrevVec = edtAnimRotCurrVec;
			}
			
			var s =smf_vector_dot(N,smf_vector_cross(edtAnimRotCurrVec, edtAnimRotPrevVec));
			var c =smf_vector_dot(edtAnimRotCurrVec, edtAnimRotPrevVec); 
			var angle = - arctan2(s, c);
			edtAnimRotPrevVec = edtAnimRotCurrVec;
		
			//array_copy(model.Sample, 0, edtAnimTempSample, 0, array_length(edtAnimTempSample));
			sample_node_rotate_axis(rig, selNode, model.Sample, angle, (edtAnimSelectedHandle == 2), (edtAnimSelectedHandle == 1), (edtAnimSelectedHandle == 0), edtAnimTransformChildren);
		}
	}
	if (mouse_check_button_released(mb_left) && array_length(edtAnimTempSample) > 0)
	{
		model.SampleStrip = -1;
		edtAnimTempSample = [];
		anim_keyframe_set_from_sample(rig, animArray[selAnim], selKeyframe, model.Sample);
	}


}
