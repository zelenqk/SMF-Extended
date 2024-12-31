function editor_load_rig_and_animation_from_buffer(argument0, argument1) {
	var loadBuff = argument0;
	var fname = argument1;
	var animName = fname;
	animName = string_delete(animName, 1, string_length(filename_change_ext(filename_name(edtSavePath), "")) + 1);

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

	var boneNum = buffer_read(loadBuff, buffer_u8);
	var keyframeNum = buffer_read(loadBuff, buffer_u8);
	var nodeList = rig.nodeList;
	var currNodeNum = ds_list_size(nodeList);
			
	//Load rig
	for (var i = 0; i < boneNum; i ++)
	{
		var Q = array_create(8);
		Q[0] = buffer_read(loadBuff, buffer_f32);
		Q[1] = buffer_read(loadBuff, buffer_f32);
		Q[2] = buffer_read(loadBuff, buffer_f32);
		Q[3] = buffer_read(loadBuff, buffer_f32);
		Q[4] = buffer_read(loadBuff, buffer_f32);
		Q[5] = buffer_read(loadBuff, buffer_f32);
		Q[6] = buffer_read(loadBuff, buffer_f32);
		Q[7] = buffer_read(loadBuff, buffer_f32);
		var parent = buffer_read(loadBuff, buffer_u8);
		var attached = buffer_read(loadBuff, buffer_u8);
				
		if (i < currNodeNum)
		{
			continue;
		}
		var node = array_create(eAnimNode.Num, 0);
		nodeList[| i] = node;
		node[@ eAnimNode.Name] = "Node " + string(i);
		node[@ eAnimNode.IsBone] = attached;
		node[@ eAnimNode.Parent] = parent;
		node[@ eAnimNode.WorldDQ] = Q;
		_anim_rig_update_node(rig, i);
	}
	_anim_rig_update_bindmap(rig);
	rigeditor_update_skeleton();

	var anim = anim_create(filename_name(filename_change_ext(animName, "")));
	var keyframeGrid = anim.keyframeGrid;
	for (var i = 0; i < keyframeNum; i ++)
	{
		var time = buffer_read(loadBuff, buffer_f32);
		var keyframeInd = anim_add_keyframe(anim, time);
		var keyframe = keyframeGrid[# 1, keyframeInd];
		for (var j = 0; j < boneNum; j ++)
		{
			var Q = array_create(8);
			Q[0] = buffer_read(loadBuff, buffer_f32);
			Q[1] = buffer_read(loadBuff, buffer_f32);
			Q[2] = buffer_read(loadBuff, buffer_f32);
			Q[3] = buffer_read(loadBuff, buffer_f32);
			Q[4] = buffer_read(loadBuff, buffer_f32);
			Q[5] = buffer_read(loadBuff, buffer_f32);
			Q[6] = buffer_read(loadBuff, buffer_f32);
			Q[7] = buffer_read(loadBuff, buffer_f32);
			var node = nodeList[| j];
			smf_dq_multiply(node[eAnimNode.LocalDQConjugate], Q, Q);
			if (Q[3] < 0)
			{
				Q[0]*=-1; 
				Q[1]*=-1; 
				Q[2]*=-1; 
				Q[3]*=-1; 
				Q[4]*=-1; 
				Q[5]*=-1; 
				Q[6]*=-1; 
				Q[7]*=-1;
			}
			if node[eAnimNode.IsBone]
			{
				Q[@ 4] = 0;
				Q[@ 5] = Q[2] * node[eAnimNode.Length];
				Q[@ 6] = -Q[1] * node[eAnimNode.Length];
				Q[@ 7] = 0;
			}
			keyframe[@ j] = Q;
		}
	}
	var animNum = array_length(animArray);
	animArray[@ animNum] = anim;
	model.SelAnim = animNum;
	model.SelKeyframe = 0;
	var keyframeTime = keyframeGrid[# 0, 0];
	model.Sample = anim_generate_sample(rig, animArray[model.SelAnim], keyframeTime, eAnimInterpolation.Keyframe);


}
