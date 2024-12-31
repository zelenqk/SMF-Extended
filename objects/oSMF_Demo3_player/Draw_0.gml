/// @description

//Draw instance
shader_set(sh_smf_animate);
matrix_set(matrix_world, matrix_build(x, y, z, 0, 0, faceDir, 16, 16, 16));
smf_instance_draw(mainInst);
matrix_set(matrix_world, matrix_build_identity());
shader_reset();