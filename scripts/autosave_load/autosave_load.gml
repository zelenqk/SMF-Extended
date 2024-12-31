/// @description autosave_load()
function autosave_load() {
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

	//Load models
	mbuff_delete(mBuff);
	model.mBuff = [];
	mBuff = model.mBuff;
	var texInd = [];
	var fname = file_find_first("Autosave/*.mbuff", 0);
	while fname != ""
	{
		var ind = real(string_digits(filename_name(fname)));
		var loadBuff = buffer_load("Autosave/" + fname);
		edtSavePath = buffer_read(loadBuff, buffer_string);
		mBuff[@ ind] = mbuff_read_from_buffer(loadBuff);
		vis[@ ind] = buffer_read(loadBuff, buffer_u8);
		texInd[ind] = buffer_read(loadBuff, buffer_u8);
		buffer_delete(loadBuff);
		fname = file_find_next();
	}
	file_find_close();
	vbuff_delete(vBuff);
	model.vBuff = vbuff_create_from_mbuff(mBuff);
	model.Vertices = mbuff_get_vertices(mBuff);
	model.Triangles = model.Vertices div 3;
	modeleditor_update_wireframe();

	//Load textures
	for (var i = 0; i < array_length(texPack); i ++)
	{
		sprite_delete(texPack[i]);
	}
	var modelNum = array_length(texInd);
	var fname = file_find_first("Autosave/*.png", 0);
	while (fname != "")
	{
		var ind = real(string_digits(filename_name(fname)));
		var spr = sprite_add("Autosave/" + fname, 1, 0, 0, 0, 0);
		for (var i = 0; i < modelNum; i ++)
		{
			if (texInd[i] == ind)
			{
				//Match textures to the correct model indices
				texPack[@ i] = spr;
			}
		}
		fname = file_find_next();
	}
	file_find_close();
	model.vBuff = vbuff_create_from_mbuff(mBuff);

	//Update camera
	var bbox = edt_model_get_size();
	camPos[0] = (bbox[0] + bbox[3]) * .5;
	camPos[1] = (bbox[1] + bbox[4]) * .5;
	camPos[2] = (bbox[2] + bbox[5]) * .5;
	var size = max(bbox[3] - bbox[0], bbox[4] - bbox[1], bbox[5] - bbox[2]);
	camZoom = 2 * size / editWidth;
	move_camera();

	//Load rig
	var fname = "Autosave/Rig.rig";
	if file_exists(fname)
	{
		rig_delete(rig);
		var loadBuff = buffer_load(fname);
		model.rig = rig_read_from_buffer(loadBuff);
		buffer_delete(loadBuff);
		rigeditor_update_skeleton();
	}

	//Load animations
	for (var i = 0; i < array_length(animArray); i ++)
	{
		anim_delete(animArray[i]);
	}
	var fname = file_find_first("Autosave/*.anim", 0);
	while fname != ""
	{
		var ind = real(string_digits(filename_name(fname)));
		var loadBuff = buffer_load("Autosave/" + fname);
		animArray[@ ind] = anim_read_from_buffer(loadBuff);
		buffer_delete(loadBuff);
		fname = file_find_next();
	}
	file_find_close();


}
