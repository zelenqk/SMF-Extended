/// @description
gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);
gpu_set_cullmode(cull_noculling);
gpu_set_tex_filter(false);

alpha = 1
if alarm[0] >= 0{alpha = min((alarm[0] / (20 / 30 * room_speed)), 1);}

sHalfWidth = sprite_get_width(sSplashScreen) / 2;
sHalfHeight = sprite_get_height(sSplashScreen) / 2;
draw_set_alpha(alpha);
draw_set_color(c_dkgray);
draw_roundrect(screenWidth / 2 - sHalfWidth - 16, screenHeight / 2 - sHalfHeight - 16, screenWidth / 2 + sHalfWidth + 16, screenHeight / 2 + sHalfHeight + 86, false)
draw_set_color(c_white);
draw_roundrect(screenWidth / 2 - sHalfWidth - 16, screenHeight / 2 - sHalfHeight - 16, screenWidth / 2 + sHalfWidth + 16, screenHeight / 2 + sHalfHeight + 86, true)
draw_sprite_ext(sSplashScreen, 0, screenWidth / 2, screenHeight / 2, 1, 1, 0, c_white, alpha);

draw_set_halign(fa_middle);
draw_set_valign(fa_top);
xx = floor(screenWidth / 2);
yy = floor((screenHeight / 2 + sHalfHeight) / 16) + 1;
draw_text(xx, (yy++)*16, "SMF Model Tool version 0.9.999");
draw_text(xx, (yy++)*16, "Made by Sindre Hauge Larsen");
draw_text(xx, (yy++)*16, "Logo by Chris Goodwin");
draw_text(xx, (yy++)*16, "Non-tiring debugging by Paweł Zagawa");

gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_cullmode(cull_clockwise);
draw_set_alpha(1);