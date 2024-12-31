/// @description rigeditor_detach_node(nodeInd, detach)
/// @param nodeInd
/// @param detach
function rigeditor_detach_node(argument0, argument1) {
	/*
		Detaches a node in all the currently loaded animations
	*/
	var nodeInd = argument0;
	var detach = argument1;

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
			for (var i = mBuffBytesPerVert - 8; i < buffSize; i += mBuffBytesPerVert)
			{
				for (var j = 0; j < 4; j ++)
				{
					var b = buffer_peek(buff, i + j, buffer_u8);
					if detach
					{
						if (b > boneInd)
						{
							buffer_poke(buff, i + j, buffer_u8, b-1);
						}
						else if (b == boneInd)
						{
							buffer_poke(buff, i + j, buffer_u8, newBoneInd);
						}
					}
					else if (b >= boneInd)
					{
						buffer_poke(buff, i + j, buffer_u8, b+1);
					}
				}		
			}
		}
	}
	vbuff_delete(vBuff);
	model.vBuff = vbuff_create_from_mbuff(mBuff);
	modeleditor_update_wireframe();
}
