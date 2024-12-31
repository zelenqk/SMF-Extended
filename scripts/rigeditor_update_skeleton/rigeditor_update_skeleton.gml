/// @description rig_update_bonemodel()
function rigeditor_update_skeleton() {
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
	if !is_struct(rig)
	{
		//model.rig = new smf_rig();
		//rig = model.rig;
		exit;
	}

	var nodeList = rig.nodeList;
	if is_undefined(nodeList) || nodeList < 0
	{
		if edtBoneModel >= 0{
			vertex_delete_buffer(edtBoneModel);}
		edtBoneModel = -1;
		exit;
	}
	var nodeNum = ds_list_size(nodeList);
	var sampleBoneInd = 0;

	if edtBoneWire < 0{edtBoneWire = vertex_create_buffer();}

	//Start a new primitive in the bone vertex buffer, which draws bones at their correct position
	var boneModelBuff = buffer_create(1, buffer_grow, 1);

	//Start a new primitive in the wire vertex buffer, which puts wires where bones are not connected to their parents
	vertex_begin(edtBoneWire, edtWireSkinnedFormat);

	var i, node, parent, parentMat, nodeMat, prevMat, length, d, rotPos, prevRotPos, parentPos;
	var subNum = array_length(rigSubDivs);
	for (i = 0; i < nodeNum; i ++)
	{
		node = nodeList[| i];
		nodeMat = smf_mat_create_from_dualquat(node[eAnimNode.WorldDQ]);
		parent = nodeList[| node[eAnimNode.Parent]];
		parentPos = smf_dq_get_translation(parent[eAnimNode.WorldDQ]);
		length = node[eAnimNode.Length];
		if node[eAnimNode.IsBone] //If node is attached to parent
		{
			var col = make_color_rgb(30, 100, 30);
			for (var j = 0; j < subNum; j ++)
			{
				if (smf_get_array_index(rigSubDivs[j], i) >= 0)
				{
					col = make_color_hsv((j * 106) mod 255, 255, 255);
					break;
				}
			}
			for (d = 0; d <= 2 * pi; d += pi / 4)
			{
				var s = sin(d);
				var c = cos(d);
				rotPos = [
					nodeMat[4] * s + nodeMat[8]  * c,
					nodeMat[5] * s + nodeMat[9]  * c,
					nodeMat[6] * s + nodeMat[10] * c];
				if d > 0
				{
					buffer_write(boneModelBuff, buffer_f32, parentPos[0]);
					buffer_write(boneModelBuff, buffer_f32, parentPos[1]);
					buffer_write(boneModelBuff, buffer_f32, parentPos[2]);
					buffer_write(boneModelBuff, buffer_u8, color_get_red(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_green(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_blue(col));
					buffer_write(boneModelBuff, buffer_u8, 255);
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * prevRotPos[0]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * prevRotPos[1]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * prevRotPos[2]));	
					buffer_write(boneModelBuff, buffer_u8, sampleBoneInd);
				
					buffer_write(boneModelBuff, buffer_f32, nodeMat[12]);
					buffer_write(boneModelBuff, buffer_f32, nodeMat[13]);
					buffer_write(boneModelBuff, buffer_f32, nodeMat[14]);
					buffer_write(boneModelBuff, buffer_u8, color_get_red(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_green(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_blue(col));
					buffer_write(boneModelBuff, buffer_u8, 255);
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * prevRotPos[0]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * prevRotPos[1]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * prevRotPos[2]) + 128);
					buffer_write(boneModelBuff, buffer_u8, sampleBoneInd);
				
					buffer_write(boneModelBuff, buffer_f32, parentPos[0]);
					buffer_write(boneModelBuff, buffer_f32, parentPos[1]);
					buffer_write(boneModelBuff, buffer_f32, parentPos[2]);
					buffer_write(boneModelBuff, buffer_u8, color_get_red(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_green(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_blue(col));
					buffer_write(boneModelBuff, buffer_u8, 255);
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * rotPos[0]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * rotPos[1]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * rotPos[2]));
					buffer_write(boneModelBuff, buffer_u8, sampleBoneInd);
				
				
					buffer_write(boneModelBuff, buffer_f32, nodeMat[12]);
					buffer_write(boneModelBuff, buffer_f32, nodeMat[13]);
					buffer_write(boneModelBuff, buffer_f32, nodeMat[14]);
					buffer_write(boneModelBuff, buffer_u8, color_get_red(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_green(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_blue(col));
					buffer_write(boneModelBuff, buffer_u8, 255);
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * prevRotPos[0]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * prevRotPos[1]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * prevRotPos[2]) + 128);
					buffer_write(boneModelBuff, buffer_u8, sampleBoneInd);
				
					buffer_write(boneModelBuff, buffer_f32, nodeMat[12]);
					buffer_write(boneModelBuff, buffer_f32, nodeMat[13]);
					buffer_write(boneModelBuff, buffer_f32, nodeMat[14]);
					buffer_write(boneModelBuff, buffer_u8, color_get_red(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_green(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_blue(col));
					buffer_write(boneModelBuff, buffer_u8, 255);
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * rotPos[0]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * rotPos[1]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * rotPos[2]) + 128);
					buffer_write(boneModelBuff, buffer_u8, sampleBoneInd);
				
					buffer_write(boneModelBuff, buffer_f32, parentPos[0]);
					buffer_write(boneModelBuff, buffer_f32, parentPos[1]);
					buffer_write(boneModelBuff, buffer_f32, parentPos[2]);
					buffer_write(boneModelBuff, buffer_u8, color_get_red(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_green(col));
					buffer_write(boneModelBuff, buffer_u8, color_get_blue(col));
					buffer_write(boneModelBuff, buffer_u8, 255);
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * rotPos[0]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * rotPos[1]));
					buffer_write(boneModelBuff, buffer_u8, 127 * (.5 + .5 * rotPos[2]));
					buffer_write(boneModelBuff, buffer_u8, sampleBoneInd);
				}
				prevRotPos = rotPos;
			}
			sampleBoneInd ++;
		}
		else
		{
			vertex_position_3d(edtBoneWire, parentPos[0], parentPos[1], parentPos[2]); 
			vertex_color(edtBoneWire, 0, 0); 
			vertex_color(edtBoneWire, 0, 0);
			vertex_position_3d(edtBoneWire, nodeMat[12], nodeMat[13], nodeMat[14]); 
			vertex_color(edtBoneWire, 0, 0); 
			vertex_color(edtBoneWire, 0, 0);
		}
	}
	if edtBoneModel >= 0{
		vertex_delete_buffer(edtBoneModel);}
	edtBoneModel = vertex_create_buffer_from_buffer(boneModelBuff, edtBoneFormat);
	buffer_delete(boneModelBuff);
	vertex_end(edtBoneWire);


}
