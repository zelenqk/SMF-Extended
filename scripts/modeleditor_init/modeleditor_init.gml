function modeleditor_init() {
	//Initialize model editor
	//Tool enums
	enum eMOD{
		None, Move, Scale, Rotate}
	
	globalvar edtModSelTool;
	edtModSelTool = eMOD.None;

	//Initialize models
	globalvar edtModelName;
	edtModelName = "";

	//Model scrolling
	globalvar edtModelIndexScroll;
	edtModelIndexScroll = 0;

	//Model transform
	globalvar edtModelTransformM;
	edtModelTransformM = matrix_build_identity();

	//Select model from 3D view
	globalvar edtModelSelectBuffer, edtModelSelectMatrix;
	edtModelSelectBuffer = -1;
	edtModelSelectMatrix = matrix_build_identity();


}
