var windowW = window_get_width();
var windowH = window_get_height();

//Turn off 3D
gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);
gpu_set_cullmode(cull_noculling);
gpu_set_tex_filter(false);

matrix_set(matrix_projection, matrix_build_projection_ortho(screenWidth, -screenHeight, 1, 32000))

//Draw borders around the 3D views
draw_set_color(c_white);
draw_rectangle(borderX, borderY, borderX + editWidth, borderY + editHeight, true);
draw_rectangle(borderX + editWidth, borderY, borderX + editWidth * 2, borderY + editHeight, true);
draw_rectangle(borderX, borderY + editHeight, borderX + editWidth, borderY + editHeight * 2, true);
draw_rectangle(borderX + editWidth, borderY + editHeight, borderX + editWidth * 2, borderY + editHeight * 2, true);

//Draw overlay surface over the 3D view
for (var i = 1; i < 5; i ++)
{
	if !surface_exists(edtOverlaySurf[i]){continue;}
	var xx = borderX + editWidth * (i mod 2);
	var yy = borderY + editHeight * ((i-1) div 2);
	draw_surface_ext(edtOverlaySurf[i], xx, yy, 1, 1, 0, c_white, edtRigOpacity);
}

//Draw the dimension indicators
draw_sprite(sDimensions, 0, borderX + 8, borderY + 8);
draw_sprite(sDimensions, 1, borderX + 8, borderY + editHeight * 2 - 72);
draw_sprite(sDimensions, 2, borderX + editWidth + 8, borderY + editHeight * 2 - 72);

//Draw blue messages at the middle of the screen
draw_set_color(c_white);
draw_set_font(fontMessage);
draw_set_halign(fa_middle);
draw_set_valign(fa_middle);
with oAnimEditMessage
{
	w = string_width(text) / 2 + 10;
	h = string_height(text) / 2 + 10;
	draw_set_alpha(alarm[0] / 20);
	draw_set_color(make_color_rgb(40, 80, 150));
	draw_roundrect(windowW / 2 - w, windowH / 2 - h, windowW / 2 + w, windowH / 2 + h, false)
	draw_set_color(c_black);
	draw_roundrect(windowW / 2 - w, windowH / 2 - h, windowW / 2 + w, windowH / 2 + h, true)
	draw_set_color(c_white);
	draw_text(windowW / 2, windowH / 2, text);
	draw_set_alpha(1);
}

//draw_text(200, 200, fps);

//Draw buttons
draw_buttons()

//Load model settings
var model = -1;
if edtSMFSel >= 0
{
	model = edtSMFArray[edtSMFSel];
	var mBuff = model.mBuff;
	var vBuff = model.vBuff;
	var vis = model.vis;
	var texPack = model.texPack;
	var wire = model.Wire;
	var selList = model.SelModelList;
	var selNode = model.SelNode;
	var animArray = model.animations;
	var selAnim = model.SelAnim;
	var selKeyframe = model.SelKeyframe;
	var rig = model.rig;
}

//Draw lower left info
draw_set_font(fontSmall);
var str = "";
if (model >= 0)
{
	str += "Vertices: " + string(model.Vertices);
	str += "\nTriangles: " + string(model.Triangles);
	str += "\nNodes: " + string(ds_list_size(rig.nodeList));
	str += "\nBones: " + string(rig.boneNum);
}
scale = 16 * power(2, floor(log2(camZoom)));
str += "\nMouse position:";
if abs(mouseWorldPos[0]) != 8000 * camZoom and mouseViewInd != 1{
		str += "\nX: " + string(snapToGrid ? round(mouseWorldPos[0] / scale) * scale : mouseWorldPos[0]);}
else{str += "\nX: NA";}
if abs(mouseWorldPos[1]) != 8000 * camZoom and mouseViewInd != 1{
		str += "\nY: " + string(snapToGrid ? round(mouseWorldPos[1] / scale) * scale : mouseWorldPos[1]);}
else{str += "\nY: NA";}
if abs(mouseWorldPos[2]) != 8000 * camZoom and mouseViewInd != 1{
		str += "\nZ: " + string(snapToGrid ? round(mouseWorldPos[2] / scale) * scale : mouseWorldPos[2]);}
else{str += "\nZ: NA";}
draw_text(5, windowH - string_height(str) - 5, str);
draw_set_font(font_0);

//Draw timeline
if global.editMode == eTab.Animation
{
	animeditor_draw_timeline();
}

//Draw tooltips
_x = window_mouse_get_x();
_y = window_mouse_get_y();
tooltipHover = collision_point(_x, _y, oAnimEditButton, false, true);
if tooltipHover != tooltipPrevHover{alarm[0] = 10 * game_get_speed(gamespeed_fps) / 30;}
if tooltipHover != noone and alarm[0] < 0 and !editorScrollmenuActive
{
	tooltip = tooltipHover.tooltip;
	var w = string_width(tooltip);
	_x = min(_x, display_get_gui_width() - w - 32);
	if tooltip != ""
	{
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_color(c_white)
		draw_rectangle(_x + 20, _y, _x + 20 + w + 10, _y + string_height(tooltip) + 10, false)
		draw_set_color(c_black)
		draw_rectangle(_x + 20, _y, _x + 20 + w + 10, _y + string_height(tooltip) + 10, true)
		draw_text(_x + 25, _y + 5, tooltip)
	}
}
tooltipPrevHover = tooltipHover;

//Draw scroll menus
draw_scroll_menu();

gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_cullmode(cull_clockwise);