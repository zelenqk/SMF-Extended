/// @description skineditor_update_tri_ind_model()
function skineditor_update_tri_ind_model() {
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

	if (is_array(edtSkinTriIndModels) || array_length(mBuff) < 1)
	{
		return false;
	}

	var bbox = edt_model_get_size();
	var pointList = model.PointList;
	var pointMap = model.PointMap;
	var faceList = model.FaceList;
	ds_map_clear(pointMap);
	ds_list_clear(pointList);
	ds_list_clear(faceList);

	var modelNum, bytesPerVert;
	modelNum = array_length(mBuff);
	bytesPerVert = mBuffBytesPerVert;

	edtSkinTriIndModels = array_create(modelNum);
	for (var m = 0; m < modelNum; m ++)
	{
		edtSkinTriIndModels[m] = vertex_create_buffer();
		vertex_begin(edtSkinTriIndModels[m], edtSkinFormat);
	}

	var vx = array_create(3);
	var vy = array_create(3);
	var vz = array_create(3);
	var p = array_create(3);
	for (var m = 0; m < modelNum; m ++)
	{
		var j = 0;
		var buff = mBuff[m];
		var buffSize = buffer_get_size(buff);
		for (var i = 0; i < buffSize; i += bytesPerVert)
		{
			buffer_seek(buff, buffer_seek_start, i);
			vx[j] = buffer_read(buff, buffer_f32);
			vy[j] = buffer_read(buff, buffer_f32);
			vz[j] = buffer_read(buff, buffer_f32);
		
			//Find the index of the selected point. If the point has not been indexed, add it to the pointlist
			var _vx = (vx[j] - bbox[0]) / bbox[3];
			var _vy = (vy[j] - bbox[1]) / bbox[4];
			var _vz = (vz[j] - bbox[2]) / bbox[5];
			var key = _vx + floor(2048 * (_vy + floor(2048 * _vz)));
			p[j] = pointMap[? key];
			var pointInd = i div bytesPerVert;
			if is_undefined(p[j])
			{
				p[j] = ds_list_size(pointList);
				ds_list_add(pointList, [m, pointInd]);
				pointMap[? key] = p[j];
			}
			else
			{
				var vertArray = pointList[| p[j]];
				vertArray[@ array_length(vertArray)] = m;
				vertArray[@ array_length(vertArray)] = pointInd;
			}
		
			j ++;
			if j == 3
			{
				if edtSkinVertPaintType == edtSkin.Triangle
				{
					var faceInd = ds_list_size(faceList) div 3;
					ds_list_add(faceList, p[0], p[1], p[2]);
					for (var j = 0; j < 3; j ++)
					{
						vertex_position_3d(edtSkinTriIndModels[m], vx[j], vy[j], vz[j]);
						vertex_color(edtSkinTriIndModels[m], make_color_rgb(faceInd mod 256, (faceInd div 256) mod 256, (faceInd div (256 * 256)) mod 256), 1);
						vertex_color(edtSkinTriIndModels[m], 0, 0);
						vertex_color(edtSkinTriIndModels[m], 0, 0);
					}
				}
				else if edtSkinVertPaintType == edtSkin.Vertex
				{
					for (var j = 0; j < 3; j ++)
					{
						vertex_position_3d(edtSkinTriIndModels[m], vx[j], vy[j], vz[j]);
						vertex_color(edtSkinTriIndModels[m], make_color_rgb(p[0] mod 256, (p[0] div 256) mod 256, (p[0] div (256 * 256)) mod 256), j == 0);
						vertex_color(edtSkinTriIndModels[m], make_color_rgb(p[1] mod 256, (p[1] div 256) mod 256, (p[1] div (256 * 256)) mod 256), j == 1);
						vertex_color(edtSkinTriIndModels[m], make_color_rgb(p[2] mod 256, (p[2] div 256) mod 256, (p[2] div (256 * 256)) mod 256), j == 2);
					}
				}
				j = 0;
			}
		}
	}

	for (var m = 0; m < modelNum; m ++)
	{
		vertex_end(edtSkinTriIndModels[m]);
	}
	return true;


}
