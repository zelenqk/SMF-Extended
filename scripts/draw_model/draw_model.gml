/// @description draw_model(modelIndex, texture, wireframe, animate)
/// @param modelIndex
/// @param texture
/// @param wireframe
/// @param animate
function draw_model(argument0, argument1, argument2, argument3) {
	//A special version of the draw script that is made for the editor
	var modelIndex = argument0;
	var texture = argument1;
	var wireframe = argument2;
	var skinned = argument3;
	var cullMode = gpu_get_cullmode();

	//Model settings
	var model = -1;
	if (modelIndex >= 0)
	{
		model = edtSMFArray[modelIndex];
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
		var sample = model.Sample;
	}
	else
	{
		exit;
	}
	if (!skinned)
	{
		sample = -1;
	}


	//Editor stuff
	var worldM = matrix_get(matrix_world);

	if wireframe
	{
		//Extract camera position from view matrix
		if skinned
		{
			shader = sh_edt_animate_wire;
			shader_set(shader);
			sample_set_uniform(shader, sample);
		}
		else
		{
			shader = sh_edt_wire;
			shader_set(shader);
		}
		var n = array_length(wire);
		var a, c;
		for (var i = 0; i < n; i ++)
		{
			c = 1;
			a = draw_get_alpha();
			if ((ds_list_find_index(selList, i) >= 0) && selectModelFade > 0)
			{
				c = 1 - .3 * selectModelFade;
				a = lerp(a, 1., sqrt(selectModelFade));
			}
			if ds_list_find_index(selList, i) >= 0
			{
				matrix_set(matrix_world, worldM);
			}
			else
			{
				matrix_set(matrix_world, matrix_build_identity());
			}
			if !vis[i]
			{
				shader_set_uniform_f(shader_get_uniform(shader, "u_colour"), .5, .5 * c, .5 * c, .1);
			}
			else
			{
				shader_set_uniform_f(shader_get_uniform(shader, "u_colour"), 1, c, c, a);
			}
			vertex_submit(wire[i], pr_linelist, -1);
		}
		shader_reset();
	}
	else
	{
		//Extract camera position from view matrix
		var vM = matrix_get(matrix_view);
		var p = [	- vM[12] * vM[0] - vM[13] * vM[1] - vM[14] * vM[2],
					- vM[12] * vM[4] - vM[13] * vM[5] - vM[14] * vM[6],
					- vM[12] * vM[8] - vM[13] * vM[9] - vM[14] * vM[10]];
		
		if global.editMode == eTab.Skinning
		{
			var shader = sh_skinning_weights;
			shader_set(shader);
			var bindMap = rig.bindMap;
			var boneInd = bindMap[| selNode];
			if is_undefined(boneInd){boneInd = -1;}
			shader_set_uniform_i(shader_get_uniform(shader, "u_Bone"), boneInd);
		}
		else
		{
			var shader = enableShader ? sh_edt_animate : sh_edt_animate_noshading;
			shader_set(shader);
			sample_set_uniform(shader, sample);
		}
	
		var spr, tex;
		var n = array_length(vBuff);
		var texNum = array_length(texture);
		if is_array(texture) && texNum > 0
		{
			for (var i = 0; i < n; i ++)
			{
				if !vis[i]{continue;}
				if ds_list_find_index(selList, i) >= 0
				{
					matrix_set(matrix_world, worldM);
				}
				else
				{
					matrix_set(matrix_world, matrix_build_identity());
				}
				spr = texture[i mod texNum];
				tex = (spr >= 0) ? sprite_get_texture(spr, 0) : -1;
				vertex_submit(vBuff[i], pr_trianglelist, tex);
			}
		}
		shader_reset();
	}
	gpu_set_cullmode(cullMode);


}
