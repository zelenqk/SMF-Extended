/// @description wire_disable_skinning(modelIndex)
/// @param modelIndex
function wire_disable_skinning() {
	/*
	Disables skinning for the given model.
	This changes the format into a non-skinnable format, and rebuilds the vertex buffer.

	Script made by TheSnidr, 2018
	www.TheSnidr.com
	*/
	/*
	var modelIndex, modelList, subModel, modelNum, mBuff, bytesPerVert;
	modelIndex = argument[0];
	modelList = modelIndex[| eSMF_SkinnedModel.SubModels];
	modelNum = ds_list_size(modelList);
	bytesPerVert = modelIndex[| eSMF_SkinnedModel.BytesPerVert];

	//Exit if the model is frozen
	if modelIndex[| eSMF_SkinnedModel.Frozen]{
		show_debug_message("Error in script smf_model_disable_skinning: Cannot manipulate frozen models");
		exit;}
	
	//Exit if the model is not skinned
	if modelIndex[| eSMF_SkinnedModel.Format] == edtWireStaticFormat{
		show_debug_message("Error in script smf_model_disable_skinning: Model is not enabled for skinning");
		exit;}

	var tempBuff, m, bufferSize, i, mtlInd, newMBuff, sizeRelation;
	sizeRelation = (bytesPerVert - 8) / bytesPerVert;
	for (m = 0; m < modelNum; m ++)
	{
		subModel = modelList[| m];
		mBuff = subModel[| eSMF_SubModel.mBuff;
		bufferSize = buffer_get_size(mBuff);
	
		newMBuff = buffer_create(bufferSize * sizeRelation, buffer_fixed, 1);
		for (i = 0; i < bufferSize; i += bytesPerVert)
		{
			buffer_copy(mBuff, i, bytesPerVert * sizeRelation, newMBuff, i * sizeRelation);
		}
		buffer_delete(mBuff);
		subModel[| eSMF_SubModel.mBuff = newMBuff;
	}
	modelIndex[| eSMF_SkinnedModel.Format] = edtWireStaticFormat;
	modelIndex[| eSMF_SkinnedModel.BytesPerVert] = edtWireStaticBytesPerVert;
	modelIndex[| eSMF_SkinnedModel.Skinned] = false;

	//Update materials
	var mtlList = modelIndex[| eSMF_SkinnedModel.MtlList];
	var mtlNum = ds_list_size(mtlList) div 2;
	for (i = 0; i < mtlNum; i ++)
	{
		smf_mtl_set_animated(mtlList[| i*2+1], false);
	}

	//Update vertex buffers
	smf_model_update_vbuff(modelIndex);

/* end wire_disable_skinning */
}
