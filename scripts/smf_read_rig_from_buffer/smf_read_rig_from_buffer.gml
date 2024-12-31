/// @description smf_read_rig_from_buffer(buffer)
/// @param buffer
function smf_read_rig_from_buffer() {
	/*
		This is a legacy script for those of you who are familiar with the SMF system from before.

		Script made by TheSnidr
		www.TheSnidr.com
	*/
	var HeaderText, loadBuff, size, n, versionNum;
	loadBuff = argument[0];
	var path = "";
	if argument_count > 1
	{
		path = argument[1];
	}

	HeaderText = buffer_read(loadBuff, buffer_string);
	versionNum = 0;
	if HeaderText != "SnidrsModelFormat"
	{
		show_debug_message("The given buffer does not contain a valid SMF model");
		return -1;
	}
	versionNum = buffer_read(loadBuff, buffer_f32);

	var partitioned = false;
	var compatibility = false;

	//This importer supports versions 6, 7 and 8
	if (versionNum > 8)
	{
		show_error("This was made with a newer version of SMF.", false);
		return -1;
	}
	else if (versionNum == 8)
	{
		partitioned = true;
		compatibility = buffer_read(loadBuff, buffer_bool);
	}
	else if (versionNum < 6)
	{
		show_error("This was made with an unsupported version of SMF.", false);
		return -1;
	}

	//Load buffer positions
	var texPos = buffer_read(loadBuff, buffer_u32);
	var matPos = buffer_read(loadBuff, buffer_u32);
	var modPos = buffer_read(loadBuff, buffer_u32);
	var nodPos = buffer_read(loadBuff, buffer_u32);
	var colPos = buffer_read(loadBuff, buffer_u32);
	var rigPos = buffer_read(loadBuff, buffer_u32);
	var aniPos = buffer_read(loadBuff, buffer_u32);
	var selPos = buffer_read(loadBuff, buffer_u32);
	var subPos = buffer_read(loadBuff, buffer_u32);
	buffer_read(loadBuff, buffer_u32); //Placeholder

	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Load rig
	buffer_seek(loadBuff, buffer_seek_start, rigPos);
	var nodeNum, i, j, nodeList, node, worldDQ;
	nodeNum = buffer_read(loadBuff, buffer_u8);
	if (nodeNum > 0)
	{
		var rig = new smf_rig();
		nodeList = rig.nodeList;
		for (i = 0; i < nodeNum; i ++)
		{
			node = array_create(eAnimNode.Num, 0);
			worldDQ = array_create(8);
			for (j = 0; j < 8; j ++)
			{
				worldDQ[j] = buffer_read(loadBuff, buffer_f32);
			}
			node[@ eAnimNode.WorldDQ] = worldDQ;
			node[@ eAnimNode.Parent] = buffer_read(loadBuff, buffer_u8);
			node[@ eAnimNode.IsBone] = buffer_read(loadBuff, buffer_u8);
			node[@ eAnimNode.PrimaryAxis] = [0, 0, 1];
	
			//Add node to node list
			nodeList[| i] = node;
			_anim_rig_update_node(rig, i);
		}
		_anim_rig_update_bindmap(rig);
		if (buffer_read(loadBuff, buffer_u8) == 232) //An extension to the rig format
		{
			var bytesPerNode = buffer_read(loadBuff, buffer_u8);
			var buffPos = buffer_tell(loadBuff);
			for (var i = 0; i < nodeNum; i ++)
			{
				node = nodeList[| i];
				node[@ eAnimNode.Locked] = buffer_peek(loadBuff, buffPos + bytesPerNode * i, buffer_u8);
				if (bytesPerNode >= 13)
				{
					var pAxis = array_create(3);
					pAxis[0] = buffer_peek(loadBuff, buffPos + bytesPerNode * i + 1, buffer_f32);
					pAxis[1] = buffer_peek(loadBuff, buffPos + bytesPerNode * i + 5, buffer_f32);
					pAxis[2] = buffer_peek(loadBuff, buffPos + bytesPerNode * i + 9, buffer_f32);
					node[@ eAnimNode.PrimaryAxis] = pAxis;
				}
			}
		}
		
		return rig;
	}

	return -1;


}
