function skineditor_perform_actions() {
	var tx, ty, nodeNum, newedtSelNode, i, newPos, bonePos, DQ;
	ds_list_clear(edtSkinSelectedList);
	if (mouseViewInd < 1){exit;}
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

	var nodeList, bindMap, node, nodePos, ray;
	nodeList = rig.nodeList;
	bindMap = rig.bindMap;
	nodeNum = ds_list_size(nodeList);

	tx = camTransform[mouseViewInd, 0];
	ty = camTransform[mouseViewInd, 1];
	var mPos = mouseWorldPos;
	var mVec = mouseWorldVec;

	if !mouse_check_button(mb_left){edtSkinPressedButton = false;}
	if mouse_check_button_pressed(mb_left)
	{
		prevNode = selNode;
		var maxDp = 0;
		for (var i = 0; i < nodeNum; i ++)
		{
			nodePos = smf_dq_get_translation(rig_node_get_dq(rig, i));
			var s = 10000 * camZoom;
			var ray = smf_cast_ray_sphere(nodePos[0], nodePos[1], nodePos[2], 7 * camZoom * (.5 + .5 * edtRigScale), mPos[0], mPos[1], mPos[2], mPos[0] + mVec[0] * s, mPos[1] + mVec[1] * s, mPos[2] + mVec[2] * s);
			if (!is_array(ray)){continue;}
			var n = [ray[0] - nodePos[0], ray[1] - nodePos[1], ray[2] - nodePos[2]];
			var l = sqrt(sqr(n[0]) + sqr(n[1]) + sqr(n[2]));
			var dp = - (n[0] * mVec[0] + n[1] * mVec[1] + n[2] * mVec[2]) / l;
			if (dp > maxDp)
			{
				maxDp = dp;
				model.SelNode = i;
				selNode = model.SelNode;
				edtSkinPressedButton = true;
			}
		}
		if (!edtSkinPressedButton && selNode >= 0)
		{
			undo_save("Vertex paint", edtUndoType.Models);	
			edtAutosaveModelChanged = true;
		}
	}

	if (mouseViewInd == 1)
	{
		skineditor_select_points();
		if (bindMap[| selNode] >= 0 && mouse_check_button(mb_left))
		{
			edtSkinTimer += delta_time * 50 / 1000000; //Lock vertex painting to 50 fps
			if (!edtSkinPressedButton && edtSkinTimer > 1)
			{
				edtSkinTimer = 0;
				skineditor_paint_vertices();
			}
		}
	}


}
