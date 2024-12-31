/// @description mbuff_autoskin(mBuff, rigIndex, power, normalWeighting)
/// @param mBuff
/// @param rigIndex
/// @param power
/// @param normalWeighting
function mbuff_autoskin(argument0, argument1) {
	/*
		The autoskinning is done by getting the distance from the vertex to the bone, and raising this
		to the given power. The relative weight of the bone will be the inverse of this result.
		You can choose to weigh vertices whose normals point away from the bone more, so that
		it's more likely they'll properly follow bones that are inside, for example, limbs.

		Power can be any number above and including 1.
		Normalweighting should be between 0 and 1.

		Script made by TheSnidr 2018
		www.TheSnidr.com
	*/
	var weightPower = argument0;
	var normalWeight = argument1;

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
		var pointList = model.PointList;
	}
	else
	{
		exit;
	}

	//Make sure the vertex index model is updated. This will also update the model's pointlist
	skineditor_update_tri_ind_model();

	var nodeList = rig.nodeList;
	var bindMap = rig.bindMap;
	var bytesPerVert = mBuffBytesPerVert;
	var boneByteOffset = mBuffBytesPerVert - 8;
	var aabb = edt_model_get_size();
	var modelSize = max(aabb[3] - aabb[0], aabb[4] - aabb[1], aabb[5] - aabb[2]);

	var i, m, n, buffSize, vertArray, key, v, nodeNum, nodeInd, priority, sort, node, parent, pPos, cPos, h, d, dist, normalWeighting, bone, k, sum, vertNum, modifiedDist, pointMap, buff, p, weight;
	nodeNum = ds_list_size(nodeList);
	sort = ds_priority_create();
	v = array_create(6, 0);

	//Loop through all the unique points of the model
	for (i = ds_list_size(pointList) - 1; i >= 0; i --)
	{
		vertArray = ds_list_find_value(pointList, i);
	
		//Find a representative vertex by reading the first vertex in the pointlist
		m = vertArray[0];
		buff = mBuff[m];
		buffer_seek(buff, buffer_seek_start, vertArray[1] * bytesPerVert);
		v[0] = buffer_read(buff, buffer_f32);
		v[1] = buffer_read(buff, buffer_f32);
		v[2] = buffer_read(buff, buffer_f32);
		v[3] = buffer_read(buff, buffer_f32);
		v[4] = buffer_read(buff, buffer_f32);
		v[5] = buffer_read(buff, buffer_f32);
		
		//Loop through all the bones and add them to a ds_priority based on their distance to the vertex
		ds_priority_clear(sort);
		for (nodeInd = 0; nodeInd < nodeNum; nodeInd ++)
		{
			node = nodeList[| nodeInd];
			if !node[eAnimNode.IsBone]{continue;} //If node is not a bone, continue the loop
		
			parent = nodeList[| node[eAnimNode.Parent]];
			cPos = smf_dq_get_translation(node[eAnimNode.WorldDQ]);
			pPos = smf_dq_get_translation(parent[eAnimNode.WorldDQ]);
			h =smf_vector_normalize(smf_vector_subtract(cPos, pPos));
			d = median(smf_vector_dot(smf_vector_subtract(v, pPos), h), 0, h[3]);
			//Dist is the shortest distance from the vertex to the bone
			dist = point_distance_3d(v[0], v[1], v[2], pPos[0] + h[0] * d, pPos[1] + h[1] * d, pPos[2] + h[2] * d);
			//Normal weighting increases if the normal points away from the bone
			normalWeighting = (2 - dot_product_3d(v[0] - (pPos[0] + h[0] * d), v[1] - (pPos[1] + h[1] * d), v[2] - (pPos[2] + h[2] * d), v[3], v[4], v[5]) / max(dist, 0.0001));
			modifiedDist = 1 + 64 * dist * lerp(1, normalWeighting, normalWeight) / modelSize;
		
			//Use 2^63 as reference
			priority = power(2, 63) / power(modifiedDist, weightPower);
			ds_priority_add(sort, bindMap[| nodeInd], priority)
		}
		bone = array_create(4);
		weight = array_create(4);
		for (k = 0; !ds_priority_empty(sort) && k < 4; k ++)
		{
			bone[k] = ds_priority_find_max(sort);
			weight[k] = ds_priority_find_priority(sort, bone[k]);
			ds_priority_delete_max(sort);
		}
		sum = weight[0] + weight[1] + weight[2] + weight[3];
		if (sum > 0)
		{
			n = 255 / sum;
			weight[0] = floor(weight[0] * n);
			weight[1] = floor(weight[1] * n);
			weight[2] = floor(weight[2] * n);
			weight[3] = floor(weight[3] * n);
		}
		bone[0] = clamp(bone[0], 0, 255);
		bone[1] = clamp(bone[1], 0, 255);
		bone[2] = clamp(bone[2], 0, 255);
		bone[3] = clamp(bone[3], 0, 255);
		weight[0] = clamp(weight[0], 0, 255);
		weight[1] = clamp(weight[1], 0, 255);
		weight[2] = clamp(weight[2], 0, 255);
		weight[3] = clamp(weight[3], 0, 255);
		vertNum = array_length(vertArray);
		for (k = 0; k < vertNum; k += 2)
		{
			m = vertArray[k];
			if !vis[m]{continue;}
			buff = mBuff[m];
			buffer_seek(buff, buffer_seek_start, vertArray[k+1] * bytesPerVert + boneByteOffset)
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


}
