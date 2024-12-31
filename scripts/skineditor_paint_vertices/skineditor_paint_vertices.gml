/// @description skineditor_paint_vertices()
function skineditor_paint_vertices() {
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
	//var faceList = model.FaceList;
	var pointList = model.PointList;
	var pointMap = model.PointMap;

	var bytesPerVert = mBuffBytesPerVert;
	var boneByteOffset = bytesPerVert - 8;
	var nodeList = rig.nodeList;
	var bindMap = rig.bindMap;

	//Iterate through the points that were selected
	var selectedBone = bindMap[| selNode];
	var sort = ds_priority_create();
	var boneList = ds_list_create();
	var bone = array_create(4, 0);
	var weight = array_create(4, 0);

	if selectedTool == SKINAUTOSKINPAINT
	{
		var v = array_create(6);
		var nodeNum = ds_list_size(nodeList);
		var weightPower = edtSkinPower;
		var normalWeight = edtSkinNormalWeighting;
	}
	//Loop through the intersected points
	for (var i = 0; i < ds_list_size(edtSkinSelectedList); i ++)
	{
		var vertArray = pointList[| edtSkinSelectedList[| i]];
		var pointNum = array_length(vertArray);
		var prevM = -1;
	
		if selectedTool == SKINAUTOSKINPAINT
		{
			var buff = mBuff[vertArray[0]];
			buffer_seek(buff, buffer_seek_start, vertArray[1] * bytesPerVert);
			v[0] = buffer_read(buff, buffer_f32);
			v[1] = buffer_read(buff, buffer_f32);
			v[2] = buffer_read(buff, buffer_f32);
			v[3] = buffer_read(buff, buffer_f32);
			v[4] = buffer_read(buff, buffer_f32);
			v[5] = buffer_read(buff, buffer_f32);
		}
	
		//Loop through all the vertices that share this point
		for (var j = 0; j < pointNum; j += 2)
		{
			var m = vertArray[j];
			var buffPos = vertArray[j+1] * bytesPerVert;
			if m != prevM
			{
				if !vis[m]{continue;}
				buff = mBuff[m];
				prevM = m;
				ds_list_clear(boneList);
				ds_priority_clear(sort);
				if (selectedTool == SKINSETPAINT)
				{
					var skinWeight = 6;
				}
				else
				{
					var skinWeight = edtSkinPaintWeight * 255;
				}
			
				//Read skinning info of this vertex
				if (selectedTool == SKINADDITIVEPAINT || selectedTool == SKINSETPAINT || selectedTool == SKINSUBTRACTIVE)
				{
					var sum = 0;
					var sel = false;
					for (var k = 0; k < 4; k ++)
					{
						var b = buffer_peek(buff, buffPos + boneByteOffset + k, buffer_u8);
						var w = buffer_peek(buff, buffPos + boneByteOffset + k + 4, buffer_u8);
						//If this bone is the selected bone, set the skin weight and continue the loop
						if (b == selectedBone)
						{
							if (!sel)
							{
								sel = true;
								if (selectedTool == SKINADDITIVEPAINT)
								{
									skinWeight = min(w + skinWeight * .5, 255);
									continue;
								}
								if (selectedTool == SKINSUBTRACTIVE)
								{
									skinWeight = max(w - skinWeight * .2, 0);
									continue;
								}
								if (selectedTool == SKINSETPAINT)
								{
									skinWeight = w + clamp(edtSkinPaintWeight * 255 - w, -6, 6);
									continue;
								}
							}
							b = -1;
							w = 0;
						}
						//Only three bones can be added to the bone list. Give the bone a negative weight to separate it more easily from the bone indices
						sum += w;
						ds_list_add(boneList, b, w);
					}
					if (selectedTool == SKINSUBTRACTIVE && !sel)
					{
						break;
					}
					//Normalize the weights of the other bones, and add them to a priority
					var n = 1;
					if ((selectedTool == SKINSUBTRACTIVE || selectedTool == SKINSETPAINT) && sum > 0)
					{
						n = (255 - skinWeight) / sum;
					}
					for (k = 0; k < 3; k ++)
					{
						w = boneList[| k*2+1] * n;
						b = boneList[| k*2];
						ds_priority_add(sort, b, w);
					}
					ds_priority_add(sort, selectedBone, skinWeight);
				}
				else if selectedTool == SKINAUTOSKINPAINT
				{
					for (var nodeInd = 0; nodeInd < nodeNum; nodeInd ++)
					{
						var node = nodeList[| nodeInd];
						if !node[eAnimNode.IsBone]{continue;} //If node is not attached to its parent, continue the loop
						var parent = nodeList[| node[eAnimNode.Parent]];
			
						var pPos = smf_dq_get_translation(parent[eAnimNode.WorldDQ]);
						var cPos = smf_dq_get_translation(node[eAnimNode.WorldDQ]);
						var h =smf_vector_normalize(smf_vector_subtract(cPos, pPos));
						var d = median(smf_vector_dot(smf_vector_subtract(v, pPos), h), 0, h[3]);
						//Dist is the shortest distance from the vertex to the bone
						var dist = point_distance_3d(v[0], v[1], v[2], pPos[0] + h[0] * d, pPos[1] + h[1] * d, pPos[2] + h[2] * d);
						//Normal weighting increases if the normal points away from the bone
						var normalWeighting = (2 - dot_product_3d(v[0] - (pPos[0] + h[0] * d), v[1] - (pPos[1] + h[1] * d), v[2] - (pPos[2] + h[2] * d), v[3], v[4], v[5]) / max(dist, 0.0001));
						var modifiedDist = dist * lerp(1, normalWeighting, normalWeight);
						var priority = power(2, 63) / max(power(modifiedDist, weightPower), 0.0001);
						ds_priority_add(sort, bindMap[| nodeInd], priority)
					}
				}
			
				//Sort the bones
				var k = 0;
				while !ds_priority_empty(sort)
				{
					bone[k] = ds_priority_find_max(sort);
					weight[k] = ds_priority_find_priority(sort, bone[k]);
					k ++;
					ds_priority_delete_max(sort);
				}
				while (k < 4)
				{
					bone[k] = 0;
					weight[k] = 0;
					k ++;
				}
			
				//We need to normalize the bone weights
				sum = weight[0] + weight[1] + weight[2] + weight[3];
				if (sum > 0)
				{
					n = 255 / sum;
					weight[0] *= n;
					weight[1] *= n;
					weight[2] *= n;
					weight[3] *= n;
				}
				bone[0] = clamp(bone[0], 0, 255);
				bone[1] = clamp(bone[1], 0, 255);
				bone[2] = clamp(bone[2], 0, 255);
				bone[3] = clamp(bone[3], 0, 255);
				weight[0] = clamp(weight[0], 0, 255);
				weight[1] = clamp(weight[1], 0, 255);
				weight[2] = clamp(weight[2], 0, 255);
				weight[3] = clamp(weight[3], 0, 255);
			}
		
			//Update the model buffer with the new skinning info
			buffer_seek(buff, buffer_seek_start, buffPos + boneByteOffset)
			buffer_write(buff, buffer_u8, bone[0]);
			buffer_write(buff, buffer_u8, bone[1]);
			buffer_write(buff, buffer_u8, bone[2]);
			buffer_write(buff, buffer_u8, bone[3]);
			buffer_write(buff, buffer_u8, weight[0]);
			buffer_write(buff, buffer_u8, weight[1]);
			buffer_write(buff, buffer_u8, weight[2]);
			buffer_write(buff, buffer_u8, weight[3]);
		}
	}
	ds_priority_destroy(sort);
	ds_list_destroy(boneList);

	//Update the vertex buffer
	if is_array(vBuff){vbuff_delete(vBuff);}
	model.vBuff = vbuff_create_from_mbuff(mBuff);


}
