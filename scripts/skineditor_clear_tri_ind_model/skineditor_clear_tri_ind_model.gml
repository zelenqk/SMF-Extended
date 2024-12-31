/// @description skineditor_clear_tri_ind_model()
function skineditor_clear_tri_ind_model() {
	var num = array_length(edtSkinTriIndModels);
	for (var i = 0; i < num; i ++)
	{
		vertex_delete_buffer(edtSkinTriIndModels[i]);
	}
	edtSkinTriIndModels = -1;
	
	if (edtSkinPaintBuffer >= 0)
	{
		buffer_delete(edtSkinPaintBuffer);
	}
	edtSkinPaintBuffer = -1;
	ds_list_clear(edtSkinSelectedList);


}
