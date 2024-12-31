/// @description mod_create_wall()
function mod_create_wall() {
	var vBuff = vertex_create_buffer();
	vertex_begin(vBuff, global.edtStandardFormat);

	vertex_position_3d(vBuff, -1, -1, 0);
	vertex_normal(vBuff, 0, 0, 1);
	vertex_texcoord(vBuff, 0, 0);
	vertex_color(vBuff, c_white, 1);

	vertex_position_3d(vBuff, 1, -1, 0);
	vertex_normal(vBuff, 0, 0, 1);
	vertex_texcoord(vBuff, 1, 0);
	vertex_color(vBuff, c_white, 1);

	vertex_position_3d(vBuff, -1, 1, 0);
	vertex_normal(vBuff, 0, 0, 1);
	vertex_texcoord(vBuff, 0, 1);
	vertex_color(vBuff, c_white, 1);

	vertex_position_3d(vBuff, 1, 1, 0);
	vertex_normal(vBuff, 0, 0, 1);
	vertex_texcoord(vBuff, 1, 1);
	vertex_color(vBuff, c_white, 1);

	vertex_end(vBuff);

	return vBuff;


}
