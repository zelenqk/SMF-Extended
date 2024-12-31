/// @description skineditor_assign_to_bone()
function skineditor_set_bone_weight(argument0, argument1, argument2) {
	var mBuff = argument0;
	var bone = argument1;
	var weight = argument2;

	var bytesPerVert = mBuffBytesPerVert;
	var sort = ds_priority_create();

	//Loop through the intersected points
	var b, w;
	var buffSize = buffer_get_size(mBuff);
	for (var i = 0; i < buffSize; i += bytesPerVert)
	{
		ds_priority_clear(sort);
		buffer_seek(mBuff, buffer_seek_start, i + bytesPerVert - 8);
		b[0] = buffer_read(mBuff, buffer_u8);
		b[1] = buffer_read(mBuff, buffer_u8);
		b[2] = buffer_read(mBuff, buffer_u8);
		b[3] = buffer_read(mBuff, buffer_u8);
		w[0] = buffer_read(mBuff, buffer_u8);
		w[1] = buffer_read(mBuff, buffer_u8);
		w[2] = buffer_read(mBuff, buffer_u8);
		w[3] = buffer_read(mBuff, buffer_u8);
	
		if (weight <= w[3]) //Make sure the new bone has a higher weight than the lowest weighted current bone
		{
			w[3] = 0;
		}
	
		var sel = false;
		var sum = 0;
		for (var j = 0; j < 4; j ++)
		{
			if (b[j] != bone)
			{
				ds_priority_add(sort, b[j], w[j]);
				sum += w[j];
			}
			else
			{
				ds_priority_add(sort, -1, 0);
				sel = true;
			}
		}
		if (!sel && weight == 0)
		{
			//If the new weight is 0 and the bone has no influence over the vertex from before, we can just continue the loop right here and now. The bone is supposed to be removed anyway, so there's no need to add it to the bone indices
			continue;
		}
		ds_priority_add(sort, bone, weight);
	
		var l = (255 - weight) / max(sum, 1);
		sum = 0;
		for (var j = 0; j < 4; j ++)
		{
			b[j] = ds_priority_find_max(sort);
			w[j] = ds_priority_find_priority(sort, b[j]);
			ds_priority_delete_max(sort);
			if (b[j] != bone)
			{
				w[j] *= l;
			}
			sum += w[j];
		}
	
		l = 255 / max(sum, 1);
		buffer_seek(mBuff, buffer_seek_start, i + bytesPerVert - 8);
		buffer_write(mBuff, buffer_u8, max(b[0], 0));
		buffer_write(mBuff, buffer_u8, max(b[1], 0));
		buffer_write(mBuff, buffer_u8, max(b[2], 0));
		buffer_write(mBuff, buffer_u8, max(b[3], 0));
		buffer_write(mBuff, buffer_u8, w[0] * l);
		buffer_write(mBuff, buffer_u8, w[1] * l);
		buffer_write(mBuff, buffer_u8, w[2] * l);
		buffer_write(mBuff, buffer_u8, w[3] * l);
	}
	ds_priority_destroy(sort);


}
