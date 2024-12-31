/// @description animeditor_select_handle()
function animeditor_update_selecthandle_surface() {
	var model = -1;
	var animation = -1; 
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
	if (selAnim >= array_length(animArray))
	{
		exit;
	}
	var nodeList = rig.nodeList;

	if edtAnimHandleBuffer >= 0
	{
		buffer_delete(edtAnimHandleBuffer);
		edtAnimHandleBuffer = -1;
	}
	
	var node = nodeList[| selNode];
	var nodeMat = anim_keyframe_get_node_matrix(rig, animArray[selAnim], selKeyframe, selNode);
	var boneLength = node[eAnimNode.Length];
	nodeMat[12] -= boneLength * nodeMat[0];
	nodeMat[13] -= boneLength * nodeMat[1];
	nodeMat[14] -= boneLength * nodeMat[2];
	if selectedTool == ANIROTATEGLOBAL
	{
		nodeMat = matrix_build(nodeMat[12], nodeMat[13], nodeMat[14], 0, 0, 0, 1, 1, 1);
	}
	else if selectedTool != ANIROTATELOCAL
	{
		exit;
	}
	
	edtAnimHandleMatrix = camera_get_view_mat(view_camera[mouseViewInd]);

	//Create surface
	var surf = surface_create(edtAnimHandleSurfSize, edtAnimHandleSurfSize);
	surface_set_target(surf);
	draw_clear_alpha(c_black, 1);
	matrix_set(matrix_view, camera_get_view_mat(view_camera[mouseViewInd]));
	matrix_set(matrix_projection, camera_get_proj_mat(view_camera[mouseViewInd]));
	gpu_set_zwriteenable(true);
	gpu_set_ztestenable(true);
	gpu_set_cullmode(cull_clockwise);
	gpu_set_blendmode_ext(bm_one, bm_zero);
		
	//Draw point models with a shader that gives each point a unique colour
	matrix_set(matrix_world, nodeMat);
	var loopSize = max(boneLength * 0.4, camZoom * 40);
	animeditor_draw_loops(loopSize, camZoom * 8);
	surface_reset_target();
	
	//Convert surface into buffer
	edtAnimHandleBuffer = buffer_create(edtAnimHandleSurfSize * edtAnimHandleSurfSize * 4, buffer_grow, 1);
	buffer_get_surface(edtAnimHandleBuffer, surf, 0);
	
	surface_free(surf);
	gpu_set_blendmode(bm_normal);


}
