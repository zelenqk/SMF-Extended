function editor_init() {
	//Initialize editor

	//Save path
	globalvar edtSavePath;
	edtSavePath = "";

	//Content arrays
	globalvar edtSMFArray, edtSMFSel;
	edtSMFArray = [edt_smf_create_model()];
	edtSMFSel = 0;

	/*enum eSMFext
	{
		Sample = eSMF.Num,
		SampleStrip = eSMF.Num+1,
		Wire = eSMF.Num+2,
		PointList = eSMF.Num+3,
		PointMap = eSMF.Num+4,
		FaceList = eSMF.Num+5,
		SelModelList = eSMF.Num+6,
		SelNode = eSMF.Num+7,
		SelAnim = eSMF.Num+8,
		SelKeyframe = eSMF.Num+9,
		UndoIndex = eSMF.Num+10,
		UndoList = eSMF.Num+11, 
		Vertices = eSMF.Num+12,
		Triangles = eSMF.Num+13,
		Bbox = eSMF.Num+14,
	}*/

	//Selected indices
	globalvar edtSelButton, edtPrevButton;
	edtSelButton = -1;
	edtPrevButton = -1;

	//Editor modes
	enum eTab{
		Model, Level, Rigging, Skinning, Animation}
	global.editMode = eTab.Model;

	settings_init();
	views_init();
	undo_init();
	autosave_init();

	//////////////////////////////
	//Initialize editor systems
	modeleditor_init();
	rigeditor_init();
	skineditor_init();
	animeditor_init();

	globalvar camZoom;

	globalvar selectedTool, prevSelectedTool, selectedSlider, selectModelFade, edtMaxButtons;
	selectedTool = 0;
	prevSelectedTool = 0;
	selectModelFade = 0;
	selectedSlider = -1;
	edtMaxButtons = 0;

	globalvar mouseX, mouseY, mouseDx, mouseDy, mousePrevX, mousePrevY, mouseWorldPrevPos, mouseWorldPos, mouseWorldVec, camTransform, camPos, tooltipHover, tooltipPrevHover, scalePos;
	globalvar mouseViewInd;
	globalvar screenWidth, screenHeight;

	//Initialize menus
	globalvar selectedTool, modelIndexScroll, modelTabButtons, modelTabButtonsPerPage;
	buttons_update();

	//initialize scroll menus
	globalvar editorScrollmenuActive, editorScrollmenuHandle, editorScrollmenu, editorScrollmenuNum, editorScrollmenuScroll, editorScrollmenuHeight, editorScrollmenuWidth, editorScrollmenuFadeIn, editorScrollmenuX, editorScrollmenuY, editorScrollmenuLimitedNum;
	editorScrollmenuActive = false;

	globalvar edtOverlaySurf;
	edtOverlaySurf[1] = -1;
	edtOverlaySurf[2] = -1;
	edtOverlaySurf[3] = -1;
	edtOverlaySurf[4] = -1;

	globalvar edtWireStaticFormat, edtWireStaticBytesPerVert;
	vertex_format_begin();
	vertex_format_add_position_3d();
	edtWireStaticFormat = vertex_format_end();
	edtWireStaticBytesPerVert = 3 * 4;

	globalvar edtWireSkinnedFormat, edtWireSkinnedBytesPerVert, edtWireSkinnedValues;
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_color();
	vertex_format_add_color();
	edtWireSkinnedFormat = vertex_format_end();
	edtWireSkinnedBytesPerVert = 4 * 4;
	edtWireSkinnedValues = 7;

	globalvar edtStandardFormat;
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_normal();
	vertex_format_add_texcoord();
	vertex_format_add_color();
	edtStandardFormat = vertex_format_end();

	create_wireframe_cube();


}
