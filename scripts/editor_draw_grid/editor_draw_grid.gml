function editor_draw_grid() {
	var scale, size, pos;
	gpu_set_cullmode(cull_noculling);
	gpu_set_texrepeat(true);
	if view_current != 1
	{
		gpu_set_zwriteenable(false);
	}
	scale = power(2, round(log2(camZoom)));
	size = scale * 64 * 10;
	pos = array_create(3);
	pos[0] = floor(camPos[0] / (size / 5)) * (size / 5);
	pos[1] = floor(camPos[1] / (size / 5)) * (size / 5);
	pos[2] = floor(camPos[2] / (size / 5)) * (size / 5);

	//Draw grids
	shader_set(sh_grid);
	matrix_set(matrix_world, matrix_build(pos[0], pos[1], 0, 0, 0, 0, size, size, size));
	vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(tex_grid, 0));
	if view_current != 1
	{
		matrix_set(matrix_world, matrix_build(pos[0], 0, pos[2], 90, 0, 0, size, 1, size));
		vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(tex_grid, 0));
	
		matrix_set(matrix_world, matrix_build(0, pos[1], pos[2], 0, 90, 0, 1, size, size));
		vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(tex_grid, 0));
	}
	shader_reset();

	//Draw axes (red lines)
	matrix_set(matrix_world, matrix_build(pos[0], camZoom * 0.1, camZoom * 0.1, 90, 0, 0, size, 1, scale));
	vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(tex_axis, 0));
	matrix_set(matrix_world, matrix_build(pos[0], camZoom * 0.1, camZoom * 0.1, 0, 0, 0, size, scale, 1));
	vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(tex_axis, 0));

	matrix_set(matrix_world, matrix_build(camZoom * 0.1, pos[1], camZoom * 0.1, 0, 90, 0, 1, size, scale));
	vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(tex_axis, 0));
	matrix_set(matrix_world, matrix_build(camZoom * 0.1, pos[1], camZoom * 0.1, 0, 0, 0, scale, size, 1));
	vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(tex_axis, 0));

	matrix_set(matrix_world, matrix_build(camZoom * 0.1, camZoom * 0.1, pos[2], 90, 0, 0, scale, 1, size));
	vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(tex_axis, 0));
	matrix_set(matrix_world, matrix_build(camZoom * 0.1, camZoom * 0.1, pos[2], 0, 90, 0, 1, scale, size));
	vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(tex_axis, 0));
	matrix_set(matrix_world, matrix_build_identity());


}
