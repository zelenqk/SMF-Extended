/// @description

//This model needs to be drawn with culling turned off, otherwise its hair will only be visible from one side
gpu_set_cullmode(cull_noculling);

//Draw basic circular shadows under each foot
gpu_set_ztestenable(false);
for (var i = 0; i < footNum; i ++)
{
	var C = footCurrent[i];
	draw_sprite_ext(sShadow, 0, C[0], C[1], .13, .13, 0, c_white, .5 * sqr(footMove[i] * 2 - 1));
}

//Draw larger, elongated shadow under the main body
matrix_set(matrix_world, matrix_build(x, y, z, 0, 0, headDir, 1, 1, 1));
draw_sprite_ext(sShadow, 0, 0, 0, .5, .3, 0, c_white, .7);
gpu_set_ztestenable(true);

//Draw the spider
shader_set(sh_smf_animate);
matrix_set(matrix_world, matrix);
mainInst.draw();

//Reset settings
matrix_set(matrix_world, matrix_build_identity());
shader_reset();