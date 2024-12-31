/// @description editor_load_smf_v1(fname)
/// @param fname
function editor_load_smf_v1(argument0) {
	var fname = argument0;

	var loadBuff = buffer_load(fname);
	var header = buffer_read(loadBuff, buffer_u16);
	var version = buffer_read(loadBuff, buffer_string);

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

	var bindMap = rig.bindMap;

	if !string_count("SnidrsModelFormat", version)
	{
		var buffSize = buffer_get_size(loadBuff);
		var startPos = 0;
	}
	else if string_count("1.0", version)
	{
		var buffSize = buffer_read(loadBuff, buffer_u32);
		var startPos = buffer_tell(loadBuff);
	}
	else
	{
		show_debug_message("Error in script editor_load_smf_v1: Could not load file");
		return -1;
	}

	var bytesPerVert = 40;
	var sizeRelation = mBuffBytesPerVert / bytesPerVert;
	var mBuff = buffer_create(buffSize * sizeRelation, buffer_fixed, 1);
	for (var i = 0; i < buffSize; i += bytesPerVert)
	{
		buffer_copy(loadBuff, startPos + i, 8 * 4, mBuff, i * sizeRelation);
		buffer_seek(loadBuff, buffer_seek_start, startPos + i + 8 * 4);
		buffer_seek(mBuff, buffer_seek_start, i * sizeRelation + 9 * 4);
		buffer_write(mBuff, buffer_u8, bindMap[| buffer_read(loadBuff, buffer_u8)]);
		buffer_write(mBuff, buffer_u8, bindMap[| buffer_read(loadBuff, buffer_u8)]);
		buffer_write(mBuff, buffer_u8, bindMap[| buffer_read(loadBuff, buffer_u8)]);
		buffer_write(mBuff, buffer_u8, bindMap[| buffer_read(loadBuff, buffer_u8)]);
		buffer_write(mBuff, buffer_u8, buffer_read(loadBuff, buffer_u8));
		buffer_write(mBuff, buffer_u8, buffer_read(loadBuff, buffer_u8));
		buffer_write(mBuff, buffer_u8, buffer_read(loadBuff, buffer_u8));
		buffer_write(mBuff, buffer_u8, buffer_read(loadBuff, buffer_u8));
	}
	buffer_delete(loadBuff);

	return mBuff;


}
