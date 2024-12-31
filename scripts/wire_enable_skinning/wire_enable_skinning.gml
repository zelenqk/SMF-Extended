/// @description wire_enable_skinning(modelIndex)
/// @param modelIndex
function wire_enable_skinning() {
	/*
	Enables skinning for the given model.
	This changes the format into a skinnable format, and rebuilds the vertex buffer.
	Note, it does not actually skin your model, you still need to do that yourself!

	Script made by TheSnidr, 2018
	www.TheSnidr.com
	*/
	/*
	var modelIndex, modelList, subModel, modelNum, mBuff, bytesPerVert;
	modelIndex = argument0;
	modelList = modelIndex[| eSMF_SkinnedModel.SubModels];
	modelNum = ds_list_size(modelList);
	bytesPerVert = modelIndex[| eSMF_SkinnedModel.BytesPerVert];

	//Exit if the model is frozen
	if modelIndex[| eSMF_SkinnedModel.Frozen]{
		show_debug_message("Error in script wire_enable_skinning: Cannot manipulate frozen models");
		exit;}
	
	//Exit if the model already is skinned
	if modelIndex[| eSMF_SkinnedModel.Format] == edtWireSkinnedFormat
	{
		show_debug_message("Error in script wire_enable_skinning: Model is already enabled for skinning");
		exit;
	}

	var tempBuff, m, bufferSize, i, mtlInd, newMBuff, sizeRelation;
	sizeRelation = (bytesPerVert + 8) / bytesPerVert;
	for (m = 0; m < modelNum; m ++)
	{
		subModel = modelList[| m];
		mBuff = subModel[| eSMF_SubModel.mBuff;
		bufferSize = buffer_get_size(mBuff);
	
		newMBuff = buffer_create(bufferSize * sizeRelation, buffer_fixed, 1);
		for (i = 0; i < bufferSize; i += bytesPerVert)
		{
			buffer_copy(mBuff, i, bytesPerVert, newMBuff, i * sizeRelation);
			buffer_poke(newMBuff, (i+1) * sizeRelation - 4, buffer_u8, 255);
		}
		buffer_delete(mBuff);
		subModel[| eSMF_SubModel.mBuff = newMBuff;
	}
	modelIndex[| eSMF_SkinnedModel.Format] = edtWireSkinnedFormat;
	modelIndex[| eSMF_SkinnedModel.BytesPerVert] = edtWireSkinnedBytesPerVert;
	modelIndex[| eSMF_SkinnedModel.Skinned] = true;

	//Update materials
	var mtlList = modelIndex[| eSMF_SkinnedModel.MtlList];
	var mtlNum = ds_list_size(mtlList) div 2;
	for (i = 0; i < mtlNum; i ++)
	{
		smf_mtl_set_animated(mtlList[| i*2+1], true);
	}

	//Update vertex buffers
	smf_model_update_vbuff(modelIndex);

/* end wire_enable_skinning */
}
