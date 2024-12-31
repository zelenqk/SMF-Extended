function settings_init() {
	globalvar snapToGrid, drawSkeleton, drawWireframe, drawNodeIndices, playAnimation, drawColBuffer, drawTexture, lightFollowCam, culling, drawGrid, transformNodes, autoskinPower, autoskinNormalWeighting, modifyMode, enableTexRepeat, edtRigOpacity, edtRigScale, enableTexFilter, enableNodePerspective, enableShader;
	ini_open("Settings.ini");
	snapToGrid = ini_read_real("Settings", "Snap to grid", 1);
	drawSkeleton = ini_read_real("Settings", "Draw skeleton", 1);
	drawWireframe = ini_read_real("Settings", "Draw wireframe", 1);
	drawNodeIndices = ini_read_real("Settings", "Draw node indices", true);
	drawColBuffer = ini_read_real("Settings", "Draw collision buffer", 1);
	drawTexture = ini_read_real("Settings", "Draw texture", 1);
	playAnimation = false;
	lightFollowCam = ini_read_real("Settings", "Enable editor light", 1);
	culling = ini_read_real("Settings", "Enable backface culling", 1);
	drawGrid = ini_read_real("Settings", "Draw grid", 1);
	enableTexRepeat = ini_read_real("Settings", "Texture repeat", 1);
	edtRigOpacity = ini_read_real("Settings", "Rig opacity", 1);
	edtRigScale = ini_read_real("Settings", "Rig scale", 1);
	enableTexFilter = ini_read_real("Settings", "Texture filter", 1);
	enableNodePerspective = ini_read_real("Settings", "Node perspective", 1);
	enableShader = ini_read_real("Settings", "Shader enabled", 1);

	//Rigging
	globalvar edtRigShowPrimaryAxis;
	edtRigShowPrimaryAxis = ini_read_real("Settings", "Draw primary axis", false);

	//Skinning
	globalvar edtSkinVertVisible, edtSkinVertPaintType;
	edtSkinPower = ini_read_real("Settings", "AutoskinPower", 3);
	edtSkinNormalWeighting = ini_read_real("Settings", "AutoskinNormalWeighting", 0.5);
	edtSkinPaintBrushSize = ini_read_real("Skinning", "Skinning paint brush size", 10);
	edtSkinPaintWeight = ini_read_real("Skinning", "Skinning paint weight", 1);
	edtSkinAutoNormalize = ini_read_real("Skinning", "Skinning auto normalize", true);
	edtSkinVertVisible = ini_read_real("Skinning", "Skinning vert visible", true);
	edtSkinVertPaintType = ini_read_real("Skinning", "Skinning vertex paint type", true);

	//Animation
	globalvar edtAnimTransformChildren, edtAnimMoveFromCurrent;
	edtAnimTransformChildren = ini_read_real("Animation", "Transform children", 1);
	edtAnimMoveFromCurrent = ini_read_real("Animation", "Move from current", false);

	globalvar IncludeTex, useCompression;
	IncludeTex = ini_read_real("Export options", "Include textures", 1);
	useCompression = ini_read_real("Export options", "Use compression", 1);

	globalvar TexpageMaxSize, TexpageExtendEdges, TexForcePowerOfTwo;
	TexpageMaxSize = ini_read_real("Export options", "Texpage max size", 2048);
	TexpageExtendEdges = ini_read_real("Export options", "Texpage extend edges", 4);
	TexForcePowerOfTwo = ini_read_real("Export options", "Texpage force power of two", true);
	ini_close();


}
