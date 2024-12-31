/// @description
if view_current == 0{
	draw_clear(c_dkgray);
	exit;}

draw_clear(make_color_hsv(0, 0, 30));

//GPU settings
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_cullmode(cull_noculling);
gpu_set_texrepeat(true)
gpu_set_texfilter(true);

//Model settings
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

if drawGrid
{
	editor_draw_grid();
}

with obj_sphere
{
	event_perform(ev_draw, 0);
}

//Draw model
if is_struct(model)
{
	gpu_set_cullmode(culling * 2);
	gpu_set_texrepeat(enableTexRepeat)
	matrix_set(matrix_world, edtModelTransformM);
	gpu_set_texfilter(enableTexFilter);
	if view_current == 1
	{
		if (global.editMode == eTab.Animation)
		{
			draw_model(edtSMFSel, drawTexture ? texPack : [texGray], false, true);
		}
		else
		{
			draw_model(edtSMFSel, drawTexture ? texPack : [texGray], false, false);
		}
		if selectModelFade > 0
		{
			selectModelFade = max(selectModelFade - 0.04, 0); 
		}
	}

	draw_set_alpha((view_current == 1) ? (drawWireframe ? .6 : 0) : .4);
	if (global.editMode == eTab.Animation)
	{
		draw_model(edtSMFSel, -1, true, true);
	}
	else
	{
		draw_model(edtSMFSel, -1, true, false);
	}
	draw_set_alpha(1);
	matrix_set(matrix_world, matrix_build_identity());
}
if !surface_exists(edtOverlaySurf[view_current])
{
	edtOverlaySurf[view_current] = surface_create(editWidth, editHeight);
}
surface_set_target(edtOverlaySurf[view_current]);
draw_clear_alpha(c_white, 0);
matrix_set(matrix_projection, camera_get_proj_mat(view_camera[view_current]));
matrix_set(matrix_view, camera_get_view_mat(view_camera[view_current]));
matrix_set(matrix_world, matrix_build_identity());
if (drawSkeleton || global.editMode == eTab.Rigging)
{
	rigeditor_draw_skeleton();
}
if (edtSkinVertVisible && global.editMode == eTab.Skinning)
{
	skineditor_draw_selected_points();
}
surface_reset_target();

//Reset settings
matrix_set(matrix_world, matrix_build_identity());
shader_reset();