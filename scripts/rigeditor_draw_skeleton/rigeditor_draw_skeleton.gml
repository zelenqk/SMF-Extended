function rigeditor_draw_skeleton() {
	if edtBoneModel < 0{exit;}
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
	if (model < 0)
	{
		exit;
	}
	

	gpu_set_cullmode(false);
	var animate = (is_array(model.Sample) && global.editMode == eTab.Animation);
	var nodeList = rig.nodeList;
	var bindMap = rig.bindMap;

	if nodeList < 0{exit;}
	var nodeNum = ds_list_size(nodeList);
	if nodeNum <= 0{exit;}

	//Draw rig
	var shader = sh_rigging_bones;
	shader_set(shader);
	if animate{
		sample_set_uniform(shader, model.Sample);}
	shader_set_uniform_i(shader_get_uniform(shader, "animate"), animate);
	var selectedBone = bindMap[| selNode];
	if is_undefined(selectedBone){selectedBone = -1;}
	shader_set_uniform_f(shader_get_uniform(shader, "u_selectedBone"), selectedBone);
	shader_set_uniform_f(shader_get_uniform(shader, "u_scale"), edtRigScale * camZoom * 5);
	gpu_set_cullmode(cull_clockwise);
	shader_set_uniform_f(shader_get_uniform(shader, "u_depthfactor"), 1.001);
	shader_set_uniform_f(shader_get_uniform(shader, "u_addscale"), edtRigScale * camZoom * 2);
	shader_set_uniform_f(shader_get_uniform(shader, "u_color"), 0, 0, 0, 1);
	shader_set_uniform_f(shader_get_uniform(shader, "u_selcolor"), .3, .3, .3, 1);
	vertex_submit(edtBoneModel, pr_trianglelist, -1);
	gpu_set_cullmode(cull_counterclockwise);
	shader_set_uniform_f(shader_get_uniform(shader, "u_depthfactor"), 1);
	shader_set_uniform_f(shader_get_uniform(shader, "u_addscale"), 0);
	shader_set_uniform_f(shader_get_uniform(shader, "u_color"), 1, 1, 1, 1);
	shader_set_uniform_f(shader_get_uniform(shader, "u_selcolor"), 1, 1, 0, 1);
	vertex_submit(edtBoneModel, pr_trianglelist, -1);

	//Draw detached bones as lines
	var shader = sh_edt_wire;
	shader_set(shader);
	if animate{
		shader = sh_edt_animate_wire;
		shader_set(shader);
		sample_set_uniform(shader, model.Sample);}
	shader_set_uniform_f(shader_get_uniform(shader, "u_colour"), 0.8, 0.8, 0.8, 1.0);
	vertex_submit(edtBoneWire, pr_linelist, -1);

	draw_set_font(fontMessage);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_middle);

	var node, nodeM;
	nodeM = array_create(16);
	for (var i = 0; i < nodeNum; i ++)
	{
		node = nodeList[| i];
		var locked = false;
		if is_array(model.Sample) && global.editMode == eTab.Animation && array_length(animArray) != 0
		{
			nodeM = sample_get_node_matrix(rig, i, model.Sample);
			if (ds_list_find_index(animArray[selAnim].lockedBonesList, i) >= 0)
			{
				locked = true;
			}
		}
		else
		{
			nodeM = smf_mat_create_from_dualquat(node[eAnimNode.WorldDQ], nodeM);
		}
	
		shader_set(sh_edt_billboard);
		gpu_set_cullmode(cull_noculling);
		var scale = camZoom * (.5 + .5 * edtRigScale);
		if (view_current == 1 && !enableNodePerspective)
		{
			//Counter perspective by scaling the opposite way
			var camDist = editHeight * camZoom / (2 * dtan(30));
			var V = matrix_get(matrix_view);
			var dp = (nodeM[12] - camPos[0]) * V[2] + (nodeM[13] - camPos[1]) * V[6] + (nodeM[14] - camPos[2]) * V[10] + camDist;
			scale *= dp / camDist;
		}
		if (locked)
		{
			scale *= 1.5;
		}
		matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 0, 0, 0, 6 * scale, 6 * scale, 6 * scale), nodeM));
		if node[eAnimNode.IsBone]
		{
			//Draw as a blue/green ball if the node is a bone
			var ind = 3 * locked + (i == selNode);
			vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(sNode, ind));
		}
		else
		{
			//Draw as a red ball with a dot in the middle if the node is not a bone
			vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(sNode, 2 - (i == selNode)));
		}
	
		if (drawNodeIndices)
		{
			matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 0, 0, 180, scale, scale, scale), nodeM));
			draw_text_transformed_color(-2, -2, i, 1, -1, 0, c_black, c_black, c_black, c_black, 1)
			draw_text_transformed_color(2, -2, i, 1, -1, 0, c_black, c_black, c_black, c_black, 1)
			draw_text_transformed_color(-2, 2, i, 1, -1, 0, c_black, c_black, c_black, c_black, 1)
			draw_text_transformed_color(2, 2, i, 1, -1, 0, c_black, c_black, c_black, c_black, 1);
			draw_text_transformed_color(0, 0, i, 1, -1, 0, c_white, c_white, c_white, c_white, 1);
		}
		shader_reset();
	
		if (selNode == i)
		{
			if global.editMode != eTab.Skinning
			{
				shader_set(sh_edt_arrows);
				matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 0, 0, 0, 4 * scale, 4 * scale, 4 * scale), nodeM));
				vbuff_draw(modUnitarrows, sprite_get_texture(tex_arrows, 0));
				shader_reset();
			}
			if global.editMode == eTab.Animation
			{
				var boneLength = node[eAnimNode.Length];
				nodeM[12] -= boneLength * nodeM[0];
				nodeM[13] -= boneLength * nodeM[1];
				nodeM[14] -= boneLength * nodeM[2];
				if selectedTool == ANIROTATEGLOBAL
				{
					nodeM = matrix_build(nodeM[12], nodeM[13], nodeM[14], 0, 0, 0, 1, 1, 1);
				}
				else if selectedTool != ANIROTATELOCAL
				{
					continue;
				}
			
				var loopSize = max(boneLength * 0.4, camZoom * 40);
				matrix_set(matrix_world, nodeM);
				animeditor_draw_loops(loopSize, camZoom * 3);
			
				if edtAnimSelectedHandle >= 0 && is_array(edtAnimRotStartVec)
				{
					//shader_set(sh_rigging_arrows);
					shader_set(sh_edt_billboard);
					gpu_set_cullmode(cull_noculling);
					nodeM[12] += edtAnimRotStartVec[0] * loopSize;
					nodeM[13] += edtAnimRotStartVec[1] * loopSize;
					nodeM[14] += edtAnimRotStartVec[2] * loopSize;
					matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 0, 0, 0, 7 * camZoom, 7 * camZoom, 7 * camZoom), nodeM));
					vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(texHandle, 0));
				
					nodeM[12] += (edtAnimRotCurrVec[0] - edtAnimRotStartVec[0]) * loopSize;
					nodeM[13] += (edtAnimRotCurrVec[1] - edtAnimRotStartVec[1]) * loopSize;
					nodeM[14] += (edtAnimRotCurrVec[2] - edtAnimRotStartVec[2]) * loopSize;
					matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 0, 0, 0, 7 * camZoom, 7 * camZoom, 7 * camZoom), nodeM));
					vertex_submit(modWall, pr_trianglestrip, sprite_get_texture(texHandle, 0));
					shader_reset();
				}
			}
			if (global.editMode == eTab.Rigging && edtRigShowPrimaryAxis)
			{
				var cNode = nodeList[| selNode]
				var pNode = nodeList[| cNode[eAnimNode.Parent]];
				var gNode = nodeList[| pNode[eAnimNode.Parent]];
				if (cNode[eAnimNode.IsBone] && pNode[eAnimNode.IsBone])
				{
					var gPos = smf_dq_get_translation(gNode[eAnimNode.WorldDQ]);
					var cPos = smf_dq_get_translation(cNode[eAnimNode.WorldDQ]);
					var pAxis = cNode[eAnimNode.PrimaryAxis];
			
					var M = global.AnimTempM;
					M[0] = pAxis[0];
					M[1] = pAxis[1];
					M[2] = pAxis[2];
					M[8] = cPos[0] - gPos[0];
					M[9] = cPos[1] - gPos[1];
					M[10] = cPos[2] - gPos[2];
					M[12] = gPos[0];
					M[13] = gPos[1];
					M[14] = gPos[2];
					var size = max(camZoom * 20, cNode[eAnimNode.Length] * .3);
					smf_mat_orthogonalize(M);
					matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 0, 0, 0, size * .4, size * .7, size * .7), M));
					shader_set(sh_edt_arrows);
					gpu_set_cullmode(cull_clockwise);
					vbuff_draw(modArrow, sprite_get_texture(texBlack, 0));
					gpu_set_cullmode(cull_counterclockwise);
					matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 0, 0, 0, size * .4, size * .35, size * .35), M));
					vbuff_draw(modArrow, sprite_get_texture(tex_point, 0));
					gpu_set_cullmode(cull_counterclockwise);
					matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 0, 90, 0, size, size, size), M));
					vbuff_draw(modSphere, sprite_get_texture(tex_spheregrid, 0));
					shader_reset();
				}
			}
		}
	}
	shader_reset();
	matrix_set(matrix_world, matrix_build_identity());


}
