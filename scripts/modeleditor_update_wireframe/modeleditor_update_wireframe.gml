/// @description modeleditor_update_wireframe()
function modeleditor_update_wireframe() {
	/*
		Create a wireframe version of the editor model buffer.
		Sorts pairs of vertices so that each edge is only added once.
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

	if !is_array(mBuff) || array_length(mBuff) <= 0
	{
		vbuff_delete(wire);
		model.Wire = [];
		exit;
	}

	var bytesPerVert = mBuffBytesPerVert;
	var bbox = edt_model_get_size();
	var xInvSize = 1 / (bbox[3] - bbox[0]);
	var yInvSize = 1 / (bbox[4] - bbox[1]);
	var zInvSize = 1 / (bbox[5] - bbox[2]);
	var modelNum = array_length(mBuff);

	var pairMap = ds_map_create();

	var mStart = 0;
	if argument_count > 0
	{
		mStart = argument[0];
		modelNum = argument[0] + 1;
		if (mStart < array_length(wire))
		{
			vbuff_delete(wire[mStart]);
			model.Wire = _array_delete(wire, mStart);
			wire = model.Wire;
		}
	}
	else
	{
		vbuff_delete(wire);
		wire = array_create(modelNum);
		model.Wire = wire;
	}

	var timer = get_timer();
	for (var m = mStart; m < modelNum; m ++)
	{
		ds_map_clear(pairMap);
	
		var buff = mBuff[m];
		var buffSize = buffer_get_size(buff);
		var wireBuff = buffer_create(1, buffer_grow, 1);
	
		var p, key, vertHash, p0, p1, p2, vx, vy, vz, b, w;
		b = [0, 0, 0];
		w = [255, 0, 0];
		for (var i = 3 * bytesPerVert; i < buffSize; i += bytesPerVert)
		{
			p = (i div bytesPerVert) mod 3;
			buffer_seek(buff, buffer_seek_start, i);
			vx[p] = buffer_read(buff, buffer_f32);
			vy[p] = buffer_read(buff, buffer_f32);
			vz[p] = buffer_read(buff, buffer_f32);

			buffer_seek(buff, buffer_seek_relative, 3*4+2*4+4);
			b[p] = buffer_read(buff, buffer_u32);
			w[p] = buffer_read(buff, buffer_u32);
		
			vertHash[p] = (vx[p] - bbox[0]) * xInvSize + floor(1024 * ((vy[p] - bbox[1]) * yInvSize + floor(1024 * (vz[p] - bbox[2]) * zInvSize)));
			if (p == 2)
			{
				p0 = vertHash[0];
				p1 = vertHash[1];
				p2 = vertHash[2];
				key = string_format(min(p0, p1), 1, 4) + "," + string_format(max(p0, p1), 1, 4);
				if is_undefined(pairMap[? key])
				{
					pairMap[? key] = true;
					p = 0;
					buffer_write(wireBuff, buffer_f32, vx[p]);
					buffer_write(wireBuff, buffer_f32, vy[p]);
					buffer_write(wireBuff, buffer_f32, vz[p]);
					buffer_write(wireBuff, buffer_u32, b[p]);
					buffer_write(wireBuff, buffer_u32, w[p]);
				
					p = 1;
					buffer_write(wireBuff, buffer_f32, vx[p]);
					buffer_write(wireBuff, buffer_f32, vy[p]);
					buffer_write(wireBuff, buffer_f32, vz[p]);
					buffer_write(wireBuff, buffer_u32, b[p]);
					buffer_write(wireBuff, buffer_u32, w[p]);
				}
				key = string_format(min(p0, p2), 1, 4) + "," + string_format(max(p0, p2), 1, 4);
				if is_undefined(pairMap[? key])
				{
					pairMap[? key] = true;
					p = 0;
					buffer_write(wireBuff, buffer_f32, vx[p]);
					buffer_write(wireBuff, buffer_f32, vy[p]);
					buffer_write(wireBuff, buffer_f32, vz[p]);
					buffer_write(wireBuff, buffer_u32, b[p]);
					buffer_write(wireBuff, buffer_u32, w[p]);
				
					p = 2;
					buffer_write(wireBuff, buffer_f32, vx[p]);
					buffer_write(wireBuff, buffer_f32, vy[p]);
					buffer_write(wireBuff, buffer_f32, vz[p]);
					buffer_write(wireBuff, buffer_u32, b[p]);
					buffer_write(wireBuff, buffer_u32, w[p]);
				}
				key = string_format(min(p1, p2), 1, 4) + "," + string_format(max(p1, p2), 1, 4);
				if is_undefined(pairMap[? key])
				{
					pairMap[? key] = true;
					p = 1;
					buffer_write(wireBuff, buffer_f32, vx[p]);
					buffer_write(wireBuff, buffer_f32, vy[p]);
					buffer_write(wireBuff, buffer_f32, vz[p]);
					buffer_write(wireBuff, buffer_u32, b[p]);
					buffer_write(wireBuff, buffer_u32, w[p]);
				
					p = 2;
					buffer_write(wireBuff, buffer_f32, vx[p]);
					buffer_write(wireBuff, buffer_f32, vy[p]);
					buffer_write(wireBuff, buffer_f32, vz[p]);
					buffer_write(wireBuff, buffer_u32, b[p]);
					buffer_write(wireBuff, buffer_u32, w[p]);
				}
			}
		}
	
		//Loop through pairs and create the new vertex buffer
		buffer_resize(wireBuff, buffer_tell(wireBuff));
		wire[@ m] = vertex_create_buffer_from_buffer(wireBuff, edtWireSkinnedFormat);
	
		buffer_delete(wireBuff);
	}
	ds_map_destroy(pairMap);
	show_debug_message("Updated wireframe model in " + string(get_timer() - timer) + " microseconds");


}
