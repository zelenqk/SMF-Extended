/// @description

//Draw ground
var spr = texGrid;
var spriteW = sprite_get_width(spr);
var spriteH = sprite_get_height(spr);
var rep = 3;
draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(texGrid, 0));
draw_vertex_texture(0, 0, 0, 0);
draw_vertex_texture(room_width, 0, rep * room_width / spriteW, 0);
draw_vertex_texture(0, room_height, 0, rep * room_height / spriteH);
draw_vertex_texture(room_width, room_height, rep * room_width / spriteW, rep * room_height / spriteH);
draw_primitive_end();

matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, 10000, 10000, 10000));
gpu_set_zwriteenable(false);
gpu_set_cullmode(cull_noculling);
shader_set(sh_skydome);
//smf_model_submit(global.modSky);
shader_reset();
gpu_set_zwriteenable(true);
matrix_set(matrix_world, matrix_build_identity());