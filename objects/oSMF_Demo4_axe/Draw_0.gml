/// @description
if (alarm[0] > 0){exit;}
shader_set(sh_smf_static);
matrix_set(matrix_world, matrix_build(x, y, 5 + 2 * cos(current_time / 200), 0, 0, current_time / 10, 2, 2, 2));
smf_model_submit(global.modAxe);
matrix_set(matrix_world, matrix_build_identity());
shader_reset();

//Draw shadow
gpu_set_ztestenable(false);
draw_sprite_ext(sShadow, 0, x, y, .16, .16, 0, c_white, .4);
gpu_set_ztestenable(true);