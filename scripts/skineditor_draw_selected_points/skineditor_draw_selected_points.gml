/// @description skineditor_draw_selected_points()
function skineditor_draw_selected_points() {
	if (view_current != 1){exit;}

	var model = edtSMFArray[edtSMFSel];
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
	var pointList = model.PointList;

	var bytesPerVert = mBuffBytesPerVert;

	gpu_set_cullmode(cull_noculling);
	shader_set(sh_edt_billboard);
	for (var i = 0; i < ds_list_size(edtSkinSelectedList); i ++)
	{
		var vertArray = pointList[| edtSkinSelectedList[| i]];
		var buff = mBuff[vertArray[0]];
		buffer_seek(buff, buffer_seek_start, vertArray[1] * bytesPerVert);
		var vx = buffer_read(buff, buffer_f32);
		var vy = buffer_read(buff, buffer_f32);
		var vz = buffer_read(buff, buffer_f32);
	
		var scale = edtSkinPaintVertScale * camZoom;
		if (!enableNodePerspective)
		{
			//Counter perspective by scaling the opposite way
			var camDist = editHeight * camZoom / (2 * dtan(30));
			var V = matrix_get(matrix_view);
			var dp = (vx - camPos[0]) * V[2] + (vy - camPos[1]) * V[6] + (vz - camPos[2]) * V[10] + camDist;
			scale *= dp / camDist;
		}
	
		matrix_set(matrix_world, matrix_build(vx, vy, vz, 0, 0, 0, 3 * scale, 3 * scale, 3 * scale));
		vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(sNode, 1));
	}
	shader_reset();
	matrix_set(matrix_world, matrix_build_identity());


}
