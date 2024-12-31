/// @description

//Draw shadow
gpu_set_ztestenable(false);
draw_sprite_ext(sShadow, 0, x, y, 0.6, 0.4, direction, c_white, .9);
gpu_set_ztestenable(true);

shader_set(sh_smf_animate);
matrix_set(matrix_world, matrix_build(x, y, z, 0, 0, direction, 14, 14, 14));
mainInst.draw();
matrix_set(matrix_world, matrix_build_identity());
shader_reset();