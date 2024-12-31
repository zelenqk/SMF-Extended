/// @description smf_model_create_wireframe(modelIndex, colour[4])
/// @param modelIndex
/// @param colour[4]
function edt_model_create_wireframe() {
	/*
	Creates a wireframe model from the given model.
	Returns the index of the new model

	Note, this creates a line for each edge of a triangle. This means that there could be lots of overlapping lines!

	Script made by TheSnidr
	www.TheSnidr.com
	*/
	/*
	var modelIndex, modelList, mtlInd, visList, modelNum, bytesPerVert, bufferSize, vertNum, skinned, m, i, j, P, N, n;
	modelIndex = argument0;
	modelList = modelIndex[| eSMF_Model.SubModels];
	modelNum = ds_list_size(modelList);
	bytesPerVert = modelIndex[| eSMF_Model.BytesPerVert];
	skinned = (modelIndex[| eSMF_Model.Format] == global.SMF_SkinnedFormat);

	//Exit if the model has no submodels
	if modelNum <= 0{
		show_debug_message("Error in script smf_model_create_wireframe: Cannot manipulate models with no submodels");
		//return smf_model_create();
	}
	
	var wireIndex, wireModelList, wireBytesPerVert, wireMaterial, wireMtlList, wireSubModel, wiremBuff;
	wireIndex = smf_model_create();
	wireIndex[| eSMF_Model.Format] = (skinned ? edtWireSkinnedFormat : edtWireStaticFormat);
	wireIndex[| eSMF_Model.BytesPerVert] = (skinned ? edtWireSkinnedBytesPerVert : edtWireStaticBytesPerVert);
	wireModelList = wireIndex[| eSMF_Model.SubModels];
	wireBytesPerVert = wireIndex[| eSMF_Model.BytesPerVert];

	var subModel, mBuff, ii, i2;
	for (m = 0; m < modelNum; m ++)
	{
		subModel = modelList[| m];
		mBuff = subModel[| eSMF_SubModel.mBuff;
		bufferSize = buffer_get_size(mBuff);
		vertNum = bufferSize div bytesPerVert;
	
		wireSubModel = smf_model_add_submodel(wireIndex);
		wireSubModel[| eSMF_SubModel.mBuff = buffer_create(vertNum * 2 * wireBytesPerVert, buffer_fixed, 1);
		wiremBuff = wireSubModel[| eSMF_SubModel.mBuff;
		for (i = 0; i < vertNum; i += 3)
		{
			ii = i * bytesPerVert;
			i2 = 2 * i;
			//First edge
			buffer_copy(mBuff, ii,						12, wiremBuff, (i2 + 0) * wireBytesPerVert);
			buffer_copy(mBuff, ii + bytesPerVert,		12, wiremBuff, (i2 + 1) * wireBytesPerVert);
		
			//Second edge
			buffer_copy(mBuff, ii + bytesPerVert,		12, wiremBuff, (i2 + 2) * wireBytesPerVert);
			buffer_copy(mBuff, ii + 2 * bytesPerVert,	12, wiremBuff, (i2 + 3) * wireBytesPerVert);
		
			//Third edge
			buffer_copy(mBuff, ii + 2 * bytesPerVert,	12, wiremBuff, (i2 + 4) * wireBytesPerVert);
			buffer_copy(mBuff, ii,						12, wiremBuff, (i2 + 5) * wireBytesPerVert);
		
			if skinned
			{
				ii += 9 * 4;
				//First edge
				buffer_copy(mBuff, ii,						8, wiremBuff, (i2 + 0) * wireBytesPerVert + 12);
				buffer_copy(mBuff, ii + bytesPerVert,		8, wiremBuff, (i2 + 1) * wireBytesPerVert + 12);
		
				//Second edge
				buffer_copy(mBuff, ii + bytesPerVert,		8, wiremBuff, (i2 + 2) * wireBytesPerVert + 12);
				buffer_copy(mBuff, ii + 2 * bytesPerVert,	8, wiremBuff, (i2 + 3) * wireBytesPerVert + 12);
		
				//Third edge
				buffer_copy(mBuff, ii + 2 * bytesPerVert,	8, wiremBuff, (i2 + 4) * wireBytesPerVert + 12);
				buffer_copy(mBuff, ii,						8, wiremBuff, (i2 + 5) * wireBytesPerVert + 12);
			}
		
		}
		wireSubModel[| eSMF_SubModel.MtlInd] = wireMaterial;
		wireSubModel[| eSMF_SubModel.Visible] = subModel[| eSMF_SubModel.Visible];
	}

	//Update vertex buffers
	//smf_model_update_vbuff(wireIndex);
	return wireIndex;

/* end edt_model_create_wireframe */
}
