function animeditor_create_loop() {
	vertex_format_begin();
	vertex_format_add_colour();
	var loopFormat = vertex_format_end();

	var iItr = 1 / 64;
	var jItr = 1 / 8;
	var tempBuff = buffer_create(24 * (1 / (iItr * jItr)), buffer_grow, 1);
	for (var i = 0; i <= 1; i += iItr)
	{
		for (var j = 0; j <= 1; j += jItr)
		{
			buffer_write(tempBuff, buffer_u8, floor(255 * i));
			buffer_write(tempBuff, buffer_u8, floor(255 * j));
			buffer_write(tempBuff, buffer_u16, 0);
		
			buffer_write(tempBuff, buffer_u8, floor(255 * (i - iItr)));
			buffer_write(tempBuff, buffer_u8, floor(255 * j));
			buffer_write(tempBuff, buffer_u16, 0);
		
			buffer_write(tempBuff, buffer_u8, floor(255 * i));
			buffer_write(tempBuff, buffer_u8, floor(255 * (j - jItr)));
			buffer_write(tempBuff, buffer_u16, 0);
		
		
			buffer_write(tempBuff, buffer_u8, floor(255 * (i - iItr)));
			buffer_write(tempBuff, buffer_u8, floor(255 * (j - jItr)));
			buffer_write(tempBuff, buffer_u16, 0);
		
			buffer_write(tempBuff, buffer_u8, floor(255 * i));
			buffer_write(tempBuff, buffer_u8, floor(255 * (j - jItr)));
			buffer_write(tempBuff, buffer_u16, 0);
		
			buffer_write(tempBuff, buffer_u8, floor(255 * (i - iItr)));
			buffer_write(tempBuff, buffer_u8, floor(255 * j));
			buffer_write(tempBuff, buffer_u16, 0);
		}
	}
	globalvar edtAnimLoopModel;
	edtAnimLoopModel = vertex_create_buffer_from_buffer(tempBuff, loopFormat);
	buffer_delete(tempBuff);


}
