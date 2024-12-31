function rigeditor_init() {
#macro RIGSELECTBONE 0
#macro RIGADDBONE 1
#macro RIGMOVEBONE 2
#macro RIGROTATEBONE 3
#macro RIGMOVE 4
#macro RIGSCALE 5
#macro RIGROTATE 6
#macro RIGMOVEAFTERPLACE 7
#macro subRigsELECTBONE 8

	globalvar edtRigSelTool;
	edtRigSelTool = RIGADDBONE;

	globalvar edtedtSelectedNode, edtSelectedBone, edtBoneModel, edtBoneWire;
	edtedtSelectedNode = -1;
	edtSelectedBone = -1;
	edtBoneModel = -1;
	edtBoneWire = -1;

	globalvar edtBoneFormat;
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_colour();
	vertex_format_add_colour();
	edtBoneFormat = vertex_format_end();


	globalvar rigScale;
	rigScale = [1, 1, 1];

	globalvar rigSubDivs, rigSelSubDiv;
	rigSubDivs = [];
	rigSelSubDiv = 0;

	globalvar edtRigSetAxis;
	edtRigSetAxis = false;


}
