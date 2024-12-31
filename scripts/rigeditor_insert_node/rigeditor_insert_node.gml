/// @description rigeditor_insert_node(nodeInd)
/// @param nodeInd
function rigeditor_insert_node(argument0) {
	/*
		Inserts a node into all the currently loaded animations
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

	//Update animations
	for (var a = 0; a < animNum; a ++)
	{
		var animInd = animArray[a];
		var keyframeGrid = animInd.keyframeGrid;
		var frameNum = ds_grid_height(keyframeGrid);
		for (var f = 0; f < frameNum; f ++)
		{
			var keyframe = keyframeGrid[# 1, f];
			var nodeNum = array_length(keyframe);
			for (var i = nodeNum; i > nodeInd + 1; i --)
			{
				keyframe[@ i] = keyframe[i - 1];
			}
			keyframe[@ nodeInd + 1] = [0, 0, 0, 1, 0, 0, 0, 0];
		}
	}

	//Update skinning... this is slow, but there's no way around it...
	var modelNum, b, buff, buffSize, boneByteOffset, bindMap, boneInd, m, i, j;
	modelNum = array_length(mBuff);
	if modelNum <= 0{exit;}
	boneByteOffset = mBuffBytesPerVert - 8;
	bindMap = rig.bindMap;
	boneInd = bindMap[| nodeInd];
	if boneInd >= 0
	{
		for (m = 0; m < modelNum; m ++)
		{
			buff = mBuff[m];
			buffSize = buffer_get_size(buff);
			for (i = boneByteOffset; i < buffSize; i += mBuffBytesPerVert)
			{
				for (j = 0; j < 4; j ++)
				{
					b = buffer_peek(buff, i + j, buffer_u8);
					if b >= boneInd
					{
						buffer_poke(buff, i + j, buffer_u8, b + 1);
					}
				}		
			}
		}
	}
	vbuff_delete(vBuff);
	model.vBuff = vbuff_create_from_mbuff(mBuff);
	modeleditor_update_wireframe();

	//Insert node into rig
	rig_insert_node(rig, selNode);

	//Update keyframes so that the child bone of the deleted bones stay attached to their parents
	var nodeNum = ds_list_size(nodeList);
	var node = nodeList[| selNode];
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
