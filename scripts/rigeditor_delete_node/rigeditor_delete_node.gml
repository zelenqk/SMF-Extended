/// @description rigeditor_delete_node(nodeInd)
/// @param nodeInd
function rigeditor_delete_node(argument0) {
	/*
		Deletes a node in all the currently loaded animations
	*/
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

	var animNum = array_length(animArray);
	var nodeInd = argument0;
	var nodeList = rig.nodeList;
	var nodeNum = ds_list_size(nodeList);

	for (var a = 0; a < animNum; a ++)
	{
		var animInd = animArray[a];
		var keyframeGrid = animInd.keyframeGrid;
		var frameNum = ds_grid_height(keyframeGrid);
		for (var f = 0; f < frameNum; f ++)
		{
			var oldKeyframe = keyframeGrid[# 1, f];
			var newKeyframe = array_create(nodeNum - 1);
			var oldNodeNum = array_length(oldKeyframe);
			for (var i = 0; i < min(nodeInd, nodeNum - 1, oldNodeNum); i ++)
			{	//Copy over keyframes for bones before the selected bone
				newKeyframe[i] = oldKeyframe[i];
			}
			for (/**/; i < min(oldNodeNum, nodeNum - 1); i ++)
			{	//Copy over keyframes after the selected bone
				newKeyframe[i] = oldKeyframe[i + 1];
			}
			for (/**/; i < nodeNum - 1; i ++)
			{	//Add blank keyframes for keyframes that didn't exist
				newKeyframe[i] = [0, 0, 0, 1, 0, 0, 0, 0];
			}
			keyframeGrid[# 1, f] = newKeyframe;
		}
	}

	//Update skinning... this is slow, but there's no way around it...
	var modelNum = array_length(mBuff);
	if (modelNum <= 0){exit;}
	var bindMap = rig.bindMap;
	var nodeList = rig.nodeList;
	var boneInd = bindMap[| nodeInd];
	var node = nodeList[| nodeInd];
	var childArray = node[eAnimNode.Children];
	if (array_length(childArray) > 0)
	{
		var newBoneInd = max(bindMap[| childArray[0]] - 1, 0); //Subtract one from child index, since the currently selected bone will be deleted
	}
	else
	{
		var newBoneInd = max(bindMap[| node[eAnimNode.Parent]], 0); //DO NOT subtract one from the parent index, since it will remain unchanged
	}
	if (boneInd >= 0)
	{
		for (var m = 0; m < modelNum; m ++)
		{
			var buff = mBuff[m];
			var buffSize = buffer_get_size(buff);
			for (i = mBuffBytesPerVert - 8; i < buffSize; i += mBuffBytesPerVert)
			{
				for (var j = 0; j < 4; j ++)
				{
					var b = buffer_peek(buff, i + j, buffer_u8);
					if (b > boneInd)
					{
						buffer_poke(buff, i + j, buffer_u8, b-1);
					}
					else if (b == boneInd)
					{
						buffer_poke(buff, i + j, buffer_u8, newBoneInd);
					}
				}		
			}
		}
	}
	vbuff_delete(vBuff);
	model.vBuff = vbuff_create_from_mbuff(mBuff);
	modeleditor_update_wireframe();

	//Delete node from rig
	rig_delete_node(rig, selNode);
	nodeNum --;

	//Update keyframes so that the child bone of the deleted bones stay attached to their parents
	if (selNode < nodeNum)
	{
		var node = nodeList[| selNode]
		if node[eAnimNode.IsBone]
		{
			for (var a = 0; a < animNum; a ++)
			{
				var animInd = animArray[a];
				var keyframeGrid = animInd.keyframeGrid;
				var frameNum = ds_grid_height(keyframeGrid);
				for (var f = 0; f < frameNum; f ++)
				{
					var keyframes = keyframeGrid[# 1, f];
					var keyframe = keyframes[selNode];
					keyframe[@ 4] = 0;
					keyframe[@ 5] = keyframe[2] * node[eAnimNode.Length];
					keyframe[@ 6] = -keyframe[1] * node[eAnimNode.Length];
					keyframe[@ 7] = 0;
				}
			}
		}
	}


}
