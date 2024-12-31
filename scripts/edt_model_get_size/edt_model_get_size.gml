/// @description edt_model_get_size()
function edt_model_get_size() {
	var model = edtSMFArray[edtSMFSel];

	if !is_array(model.Bbox)
	{
		model.Bbox = mbuff_get_boundingbox(model.mBuff);
	}

	return model.Bbox;


}
