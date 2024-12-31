//////////////////////////////
function skineditor_init() {
	//Initialize skinning
#macro SKINSETPAINT 0
#macro SKINADDITIVEPAINT 1
#macro SKINSUBTRACTIVE 2
#macro SKINAUTOSKINPAINT 3

	enum edtSkin
	{
		Vertex,
		Triangle
	}

	globalvar edtSkinSelTool;
	edtSkinSelTool = SKINSETPAINT;

	globalvar edtSkinFormat;
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_colour(); //RGB = vert1 index, A = vert1 active
	vertex_format_add_colour(); //RGB = vert2 index, A = vert2 active
	vertex_format_add_colour(); //RGB = vert3 index, A = vert3 active
	edtSkinFormat = vertex_format_end();

	globalvar edtSkinPaintVertScale;
	edtSkinPaintVertScale = 1;

	globalvar edtSkinTriIndModels, edtSkinSelectedList;
	edtSkinTriIndModels = -1;
	edtSkinSelectedList = ds_list_create();

	globalvar pointModelBuffer, pointModelList, indexedTrianglesForSkinning;
	pointModelList = -1;
	pointModelBuffer = buffer_create(1, buffer_grow, 1);
	indexedTrianglesForSkinning = false;

	//Selection save system
	globalvar savedSelectionsList;
	savedSelectionsList = ds_list_create();

	//Select points from buffer
	globalvar edtSkinPower, edtSkinNormalWeighting, edtSkinPaintSurfSize, edtSkinPaintBrushSize, edtSkinPaintBuffer, edtSkinPaintWeight, edtSkinDepthNear, edtSkinDepthFar, edtSkinPressedButton, edtSkinAutoNormalize, edtSkinPaintMatrix;
	edtSkinPaintSurfSize = 256;
	edtSkinPaintBuffer = -1;
	edtSkinPaintMatrix = matrix_build_identity();
	edtSkinDepthNear = 0;
	edtSkinDepthFar = 800;
	edtSkinPressedButton = false;

	globalvar edtSkinTimer;
	edtSkinTimer = 0;


}
