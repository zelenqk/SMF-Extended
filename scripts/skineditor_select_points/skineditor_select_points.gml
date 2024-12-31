function skineditor_select_points() {
	if (skineditor_update_tri_ind_model() || (!array_equals(edtSkinPaintMatrix, camera_get_view_mat(view_camera[1])) && edtSkinPaintBuffer >= 0))
	{
		if (edtSkinPaintBuffer >= 0)
		{
			buffer_delete(edtSkinPaintBuffer);
		}
		edtSkinPaintBuffer = -1;
	}

	//Update vertex paint buffer
	var model = edtSMFArray[edtSMFSel];
	var vis = model.vis;
	if (edtSkinPaintBuffer < 0)
	{
		edtSkinPaintMatrix = camera_get_view_mat(view_camera[1]);
		
		//Settings
		var surf = surface_create(edtSkinPaintSurfSize, edtSkinPaintSurfSize);
		surface_set_target(surf);
		draw_clear_alpha(c_white, 1);
		matrix_set(matrix_view, camera_get_view_mat(view_camera[1]));
		matrix_set(matrix_projection, camera_get_proj_mat(view_camera[1]));
		matrix_set(matrix_world, matrix_build_identity());
		gpu_set_zwriteenable(true);
		gpu_set_ztestenable(true);
		gpu_set_cullmode(culling ? cull_counterclockwise : cull_noculling);
		gpu_set_blendmode_ext(bm_one, bm_zero);
		
		//Draw triangle index model with a shader that colours each triangle in a unique colour
		shader_set(sh_skinning_weight_paint);
		shader_set_uniform_f(shader_get_uniform(sh_skinning_weight_paint, "u_Near"), camZoom * edtSkinDepthNear);
		shader_set_uniform_f(shader_get_uniform(sh_skinning_weight_paint, "u_Far"), camZoom * edtSkinDepthFar);
		var modelNum = array_length(edtSkinTriIndModels);
		for (var m = 0; m < modelNum; m ++)
		{
			if vis[m]
			{
				vertex_submit(edtSkinTriIndModels[m], pr_trianglelist, -1);
			}
		}
		surface_reset_target();
		shader_reset();
	
		//Convert surface into buffer
		edtSkinPaintBuffer = buffer_create(edtSkinPaintSurfSize * edtSkinPaintSurfSize * 4, buffer_grow, 1);
		buffer_get_surface(edtSkinPaintBuffer, surf, 0);
	
		surface_free(surf);
		gpu_set_blendmode(bm_normal);
	}

	//Iterate through the select point buffer
	var mx = edtSkinPaintSurfSize * (mouseX mod editWidth) / editWidth;
	var my = edtSkinPaintSurfSize * (mouseY mod editHeight) / editHeight;
	var buff = edtSkinPaintBuffer;
	var brushSize = edtSkinPaintBrushSize;
	var model = edtSMFArray[edtSMFSel];
	var faceList = model.FaceList;

	//Read the depth of the value under the mouse. This will be used to prevent painting vertices that are too far away in the third dimension
	var pos = (floor(mx) + floor(my) * edtSkinPaintSurfSize) * 4;
	var mz = buffer_peek(buff, pos+3, buffer_u8);

	//Iterate through the buffer as a grid
	for (var px = max(mx - brushSize, 0); px <= min(mx + brushSize, edtSkinPaintSurfSize-1); px ++)
	{
		for (var py = max(my - brushSize, 0); py <= min(my + brushSize, edtSkinPaintSurfSize-1); py ++)
		{
			//Continue the loop if the pixel is too far away in the third dimension.
			var pos = (floor(px) + floor(py) * edtSkinPaintSurfSize) * 4;
			var pz = buffer_peek(buff, pos+3, buffer_u8);
			if is_undefined(pz){continue;}
			if abs(pz - mz) > brushSize{continue;}
		
			//Read the red, green and blue channels, and generate the triangle index from the rgb values
			var r = buffer_peek(buff, pos, buffer_u8);
			var g = buffer_peek(buff, pos+1, buffer_u8);
			var b = buffer_peek(buff, pos+2, buffer_u8);
			if (is_undefined(r) || is_undefined(g) || is_undefined(b)) //Continue if something went wrong (typically if trying to read outside the view)
			{
				continue;
			}
			if (r == 255 && g == 255 && b == 255) //If the pixel is white, it's part of the background
			{
				continue;
			}
			var p = r + g * 256 + b * 256 * 256;
		
			if edtSkinVertPaintType == edtSkin.Triangle
			{
				var p1 = faceList[| p*3];
				var p2 = faceList[| p*3+1];
				var p3 = faceList[| p*3+2];
				if (ds_list_find_index(edtSkinSelectedList, p1) < 0)
				{
					ds_list_add(edtSkinSelectedList, p1);
				}
				if (ds_list_find_index(edtSkinSelectedList, p2) < 0)
				{
					ds_list_add(edtSkinSelectedList, p2);
				}
				if (ds_list_find_index(edtSkinSelectedList, p3) < 0)
				{
					ds_list_add(edtSkinSelectedList, p3);
				}
			}
			else if edtSkinVertPaintType == edtSkin.Vertex
			{
				if (ds_list_find_index(edtSkinSelectedList, p) < 0)
				{
					ds_list_add(edtSkinSelectedList, p);
				}
			}
		}
	}


}
