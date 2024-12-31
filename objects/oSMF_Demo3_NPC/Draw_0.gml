/// @description
shader_set(sh_smf_animate);
matrix_set(matrix_world, M);
smf_instance_draw(mainInst);
matrix_set(matrix_world, matrix_build_identity());
shader_reset();