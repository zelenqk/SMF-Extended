/// @description

//Draw ground
var spr = texDisco;
var spriteW = sprite_get_width(spr);
var spriteH = sprite_get_height(spr);
var rep = 6;
draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(spr, 0));
draw_vertex_texture(0, 0, 0, 0);
draw_vertex_texture(room_width, 0, rep * room_width / spriteW, 0);
draw_vertex_texture(0, room_height, 0, rep * room_height / spriteH);
draw_vertex_texture(room_width, room_height, rep * room_width / spriteW, rep * room_height / spriteH);
draw_primitive_end();