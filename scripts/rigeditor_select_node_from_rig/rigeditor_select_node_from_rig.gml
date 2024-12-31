function rigeditor_select_node_from_rig() {
	var size = 128;
	var surf = surface_create(size, size);
	surface_set_target(surf);
	draw_clear_alpha(c_white, 1);
	gpu_set_zwriteenable(true);
	gpu_set_ztestenable(true);
	matrix_set(matrix_view, camera_get_view_mat(view_camera[mouseViewInd]));
	matrix_set(matrix_projection, camera_get_proj_mat(view_camera[mouseViewInd]));
	matrix_set(matrix_world, matrix_build_identity());

	//Model settings
	var model = -1;
	if (edtSMFSel >= 0)
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
	else
	{
		exit;
	}

	//Draw rig
	var shader = sh_skinning_select_bone;
	shader_set(shader);
	shader_set_uniform_f(shader_get_uniform(shader, "u_scale"), camZoom * 12);
	var animate = (global.editMode == eTab.Animation and is_array(model.Sample));
	if animate
	{
		sample_set_uniform(shader, model.Sample);
	}
	shader_set_uniform_i(shader_get_uniform(shader, "animate"), animate);
	vertex_submit(edtBoneModel, pr_trianglelist, -1);
	shader_reset();
	surface_reset_target();

	var surfBuff = buffer_create(size * size * 4, buffer_grow, 1);
	buffer_get_surface(surfBuff, surf, 0);
	var mx = size * (mouseX mod editWidth) / editWidth;
	var my = size * (mouseY mod editHeight) / editHeight;
		
	for (var checkRadius = 0; checkRadius < 2; checkRadius ++)
	{
		for (var checkAngle = 0; checkAngle < 360; checkAngle += 360 / (1 + 7 * (checkRadius > 0)))
		{
			var px = floor(mx + dcos(checkAngle) * checkRadius);
			var py = floor(my + dsin(checkAngle) * checkRadius);
			var p = (px + py * size) * 4;
			var r = buffer_peek(surfBuff, p, buffer_u8);
			var g = buffer_peek(surfBuff, p+1, buffer_u8);
			var b = buffer_peek(surfBuff, p+2, buffer_u8);
		
			if is_undefined(r) || is_undefined(g) || is_undefined(b){continue;}
			if r == 255 && g == 255 && b = 255{continue;}
		
			surface_free(surf);
			buffer_delete(surfBuff);
			return ds_list_find_index(rig.bindMap, r + 255 * g + 255 * 255 * b);
		}
	}
	surface_free(surf);
	buffer_delete(surfBuff);
	return -1;


}
