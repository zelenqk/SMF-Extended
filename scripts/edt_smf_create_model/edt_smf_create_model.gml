/// @description edt_smf_create_model()
function edt_smf_create_model() {
	var model = new smf_model();
	model.SampleStrip = -1;
	model.Wire = -1;
	model.PointList = ds_list_create();
	model.PointMap = ds_map_create();
	model.FaceList = ds_list_create();
	model.SelModelList = ds_list_create();
	model.SelNode = -1;
	model.SelAnim = 0;
	model.SelKeyframe = 0;
	model.UndoIndex = 0;
	model.UndoList = ds_list_create();
	model.Triangles = 0;
	model.Vertices = 0;
	model.Bbox = -1;
	model.Sample = [0, 0, 0, 1, 0, 0, 0, 0];
	
	model.rig = new smf_rig();

	return model;
}
