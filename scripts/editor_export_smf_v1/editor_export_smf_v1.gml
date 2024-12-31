/// @description editor_export_smf_v1(savePath)
function editor_export_smf_v1(argument0) {
	/*
		Exports to the first version of the SMF format
	*/
	var fname = argument0;

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

	var totalSize = 0;
	var bindMap = rig.bindMap;
	var nodeList = rig.nodeList;
	var nodeNum = ds_list_size(nodeList);
	var modelNum = array_length(mBuff);
	var sizeRelation = 40 / mBuffBytesPerVert;

	var tempBuff = buffer_create(1, buffer_grow, 1);
	for (var i = 0; i < modelNum; i ++)
	{
		if !vis[i]{continue;}
		var buff = mBuff[i];
		var buffSize = buffer_get_size(buff);
		var currPos = totalSize;
		totalSize += buffSize * sizeRelation;
					
		for (var j = 0; j < buffSize; j += mBuffBytesPerVert)
		{
			//Copy position, normal and texcoords
			buffer_copy(buff, j, 8 * 4, tempBuff, currPos + j * sizeRelation);
			//Skip tangent and write bone indices and bone weights
			buffer_seek(buff, buffer_seek_start, j + 9 * 4);
			buffer_seek(tempBuff, buffer_seek_start, currPos + j * sizeRelation + 8 * 4);
			buffer_write(tempBuff, buffer_u8, ds_list_find_index(bindMap, buffer_read(buff, buffer_u8)));
			buffer_write(tempBuff, buffer_u8, ds_list_find_index(bindMap, buffer_read(buff, buffer_u8)));
			buffer_write(tempBuff, buffer_u8, ds_list_find_index(bindMap, buffer_read(buff, buffer_u8)));
			buffer_write(tempBuff, buffer_u8, ds_list_find_index(bindMap, buffer_read(buff, buffer_u8)));
			buffer_write(tempBuff, buffer_u8, buffer_read(buff, buffer_u8));
			buffer_write(tempBuff, buffer_u8, buffer_read(buff, buffer_u8));
			buffer_write(tempBuff, buffer_u8, buffer_read(buff, buffer_u8));
			buffer_write(tempBuff, buffer_u8, buffer_read(buff, buffer_u8));
		}
	}

	var saveBuff = buffer_create(totalSize, buffer_fixed, 1);
	buffer_copy(tempBuff, 0, totalSize, saveBuff, buffer_tell(saveBuff));
	buffer_save(saveBuff, fname);
	buffer_delete(saveBuff);
	buffer_delete(tempBuff);
				
	//Save textures
	var texNum = min(array_length(texPack), modelNum);
	for (var i = 0; i < texNum; i ++)
	{
		sprite_save(texPack[i], 0, string(i) + ".png");
		file_copy(game_save_id + string(i) + ".png", filename_change_ext(fname, "_" + string(i) + ".png"));
		file_delete(string(i) + ".png");
	}
				
	if nodeNum > 0
	{		
		//Save animations
		var animNum = array_length(animArray);
		for (var i = 0; i < animNum; i ++)
		{
			var saveBuff = buffer_create(1, buffer_grow, 1);
			var animInd = animArray[i];
			var keyframeGrid = animInd.keyframeGrid;
			var keyframeNum = ds_grid_height(keyframeGrid);
		
			//Save the rig first (the rig is stored in every animation in this format...)
			buffer_write(saveBuff, buffer_u8, nodeNum);
			buffer_write(saveBuff, buffer_u8, keyframeNum);
			for (var j = 0; j < nodeNum; j ++)
			{
				var node = nodeList[| j];
				var Q = node[eAnimNode.WorldDQ];
				buffer_write(saveBuff, buffer_f32, Q[0]);
				buffer_write(saveBuff, buffer_f32, Q[1]);
				buffer_write(saveBuff, buffer_f32, Q[2]);
				buffer_write(saveBuff, buffer_f32, Q[3]);
				buffer_write(saveBuff, buffer_f32, Q[4]);
				buffer_write(saveBuff, buffer_f32, Q[5]);
				buffer_write(saveBuff, buffer_f32, Q[6]);
				buffer_write(saveBuff, buffer_f32, Q[7]);
				buffer_write(saveBuff, buffer_u8, node[eAnimNode.Parent]);
				buffer_write(saveBuff, buffer_u8, node[eAnimNode.IsBone]);
			}
		
			for (var j = 0; j < keyframeNum; j ++)
			{
				buffer_write(saveBuff, buffer_f32, keyframeGrid[# 0, j]); //Write time of frame
				var keyframe = keyframeGrid[# 1, j];
				for (var k = 0; k < nodeNum; k ++)
				{
					var node = nodeList[| k];
					var frameQ = keyframe[k];
					var Q = global.AnimTempQ1;
					smf_dq_multiply(node[eAnimNode.LocalDQ], frameQ, Q);
					buffer_write(saveBuff, buffer_f32, Q[0]);
					buffer_write(saveBuff, buffer_f32, Q[1]);
					buffer_write(saveBuff, buffer_f32, Q[2]);
					buffer_write(saveBuff, buffer_f32, Q[3]);
					buffer_write(saveBuff, buffer_f32, Q[4]);
					buffer_write(saveBuff, buffer_f32, Q[5]);
					buffer_write(saveBuff, buffer_f32, Q[6]);
					buffer_write(saveBuff, buffer_f32, Q[7]);
				}
			}
		
			buffer_save(saveBuff, filename_change_ext(fname, "_" + animInd.name + ".ani"));
			buffer_delete(saveBuff);
		}
	}
				
	editor_show_message("Saved SMF v1");


}
