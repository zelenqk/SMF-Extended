function rig_draw_bone_indices() {
	/*var boneNum = ds_grid_height(RigBoneGrid);
	gpu_set_ztestenable(false);
	gpu_set_cullmode(cull_noculling);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_middle);
	shader_reset();
	var viewpos = [viewPos[view_current, 0], viewPos[view_current, 1], viewPos[view_current, 2]];
	var up = [0, 0, 1];
	if view_current == 2{up = [0, -1, 0];}
	smf_transform_set_billboard(0, 0, 0, viewpos, [camPos[0] - viewpos[0], camPos[1] - viewpos[1], camPos[2] - viewpos[2]], up);
	var billboardMat = matrix_get(matrix_world);

	for (var boneInd = 0; boneInd < boneNum; boneInd ++)
	{
		boneDQ = rig_get_sample_bone(boneInd);
		bonePos = dq_get_translation(boneDQ);
		matrix_set(matrix_world, matrix_multiply(billboardMat, matrix_build(bonePos[0], bonePos[1], bonePos[2], 0, 0, 0, 1.5*camZoom, 1.5*camZoom, 1.5*camZoom)));
		draw_set_color(c_black);
		draw_text(-1, -1, string(boneInd));
		draw_text(-1, 1, string(boneInd));
		draw_text(1, -1, string(boneInd));
		draw_text(1, 1, string(boneInd));
		draw_set_color(c_white);
		draw_text(0, 0, string(boneInd));
	}
	gpu_set_ztestenable(true);
	matrix_set(matrix_world, matrix_build_identity());

/* end rig_draw_bone_indices */
}
