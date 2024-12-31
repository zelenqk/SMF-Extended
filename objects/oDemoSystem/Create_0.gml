/// @description
enum playerState
{
	Idle,
	Walk,
	Run,
	Jump,
	Land,
	Attack,
	Roll
}
	
loading = true;
	

show_debug_overlay(true)
gpu_set_tex_mip_enable(mip_on);
layer_force_draw_depth(true, 0);
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_cullmode(cull_counterclockwise);
gpu_set_texrepeat(true);