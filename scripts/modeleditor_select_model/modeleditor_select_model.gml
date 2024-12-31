function modeleditor_select_model() {
	//Select vbuffer from vbuff surface
	//Model settings
	var model = -1;
	if (edtSMFSel >= 0)
	{
		model = edtSMFArray[edtSMFSel];
		var vBuff = model.vBuff;
		var vis = model.vis;
	}

	var size = 128;
	if (edtModelSelectBuffer < 0 || !array_equals(edtModelSelectMatrix, camera_get_view_mat(view_camera[1])))
	{
		var surf = surface_create(size, size);
		surface_set_target(surf);
		draw_clear_alpha(c_black, 1);
		gpu_set_zwriteenable(true);
		gpu_set_ztestenable(true);
		gpu_set_cullmode(culling * 2);
		var shader = sh_select_vbuff;
		shader_set(shader);
		matrix_set(matrix_view, camera_get_view_mat(view_camera[1]));
		matrix_set(matrix_projection, camera_get_proj_mat(view_camera[1]));
		matrix_set(matrix_world, matrix_build_identity());
	
		for (var m = 0; m < array_length(vBuff); m ++)
		{
			if !vis[m]{continue;}
			shader_set_uniform_f(shader_get_uniform(shader, "u_vColour"), m / 255, (m div 256) / 255, 0, 1);
			vertex_submit(vBuff[m], pr_trianglelist, -1);
		}
		shader_reset();
		surface_reset_target();
	
		edtModelSelectMatrix = camera_get_view_mat(view_camera[1]);
		if edtModelSelectBuffer >= 0{buffer_delete(edtModelSelectBuffer);}
		edtModelSelectBuffer = buffer_create(size * size * 4, buffer_grow, 1);
		buffer_get_surface(edtModelSelectBuffer, surf, 0);
		surface_free(surf);
	}

	var mx = clamp(floor(size * (mouseX mod editWidth) / editWidth), 0, size-1);
	var my = clamp(floor(size * (mouseY mod editHeight) / editHeight), 0, size-1);
	var p = (mx + size * my) * 4;
	var r = buffer_peek(edtModelSelectBuffer, p, buffer_u8);
	var g = buffer_peek(edtModelSelectBuffer, p+1, buffer_u8);
	var b = buffer_peek(edtModelSelectBuffer, p+2, buffer_u8);

	if b == 255{return 0;}
	return r + 255 * g + 255 * 255 * b;


}
