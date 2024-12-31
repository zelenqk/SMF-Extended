function create_wireframe_cube() {
	globalvar wireframeCube;
	wireframeCube = vertex_create_buffer();
	vertex_begin(wireframeCube, edtWireStaticFormat);
	vertex_position_3d(wireframeCube, -0.5, -0.5, -0.5);
	vertex_position_3d(wireframeCube, -0.5, -0.5, 0.5);
	vertex_position_3d(wireframeCube, 0.5, -0.5, -0.5);
	vertex_position_3d(wireframeCube, 0.5, -0.5, 0.5);
	vertex_position_3d(wireframeCube, -0.5, 0.5, -0.5);
	vertex_position_3d(wireframeCube, -0.5, 0.5, 0.5);
	vertex_position_3d(wireframeCube, 0.5, 0.5, -0.5);
	vertex_position_3d(wireframeCube, 0.5, 0.5, 0.5);

	vertex_position_3d(wireframeCube, 0.5, -0.5, -0.5);
	vertex_position_3d(wireframeCube, 0.5, 0.5, -0.5);
	vertex_position_3d(wireframeCube, 0.5, -0.5, 0.5);
	vertex_position_3d(wireframeCube, 0.5, 0.5, 0.5);

	vertex_position_3d(wireframeCube, -0.5, -0.5, -0.5);
	vertex_position_3d(wireframeCube, -0.5, 0.5, -0.5);
	vertex_position_3d(wireframeCube, -0.5, -0.5, 0.5);
	vertex_position_3d(wireframeCube, -0.5, 0.5, 0.5);

	vertex_position_3d(wireframeCube, -0.5, 0.5, -0.5);
	vertex_position_3d(wireframeCube, 0.5, 0.5, -0.5);
	vertex_position_3d(wireframeCube, -0.5, 0.5, 0.5);
	vertex_position_3d(wireframeCube, 0.5, 0.5, 0.5);

	vertex_position_3d(wireframeCube, -0.5, -0.5, -0.5);
	vertex_position_3d(wireframeCube, 0.5, -0.5, -0.5);
	vertex_position_3d(wireframeCube, -0.5, -0.5, 0.5);
	vertex_position_3d(wireframeCube, 0.5, -0.5, 0.5);

	vertex_end(wireframeCube);


}
