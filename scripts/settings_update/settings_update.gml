function settings_update() {
	ini_open("Settings.ini");
	ini_write_real("Settings", "Snap to grid", snapToGrid);
	ini_write_real("Settings", "Draw skeleton", drawSkeleton);
	ini_write_real("Settings", "Draw wireframe", drawWireframe);
	ini_write_real("Settings", "Draw node indices", drawNodeIndices);
	ini_write_real("Settings", "Draw collision buffer", drawColBuffer);
	ini_write_real("Settings", "Draw texture", drawTexture);
	ini_write_real("Settings", "Enable editor light", lightFollowCam);
	ini_write_real("Settings", "Enable backface culling", culling);
	ini_write_real("Settings", "Draw grid", drawGrid);
	ini_write_real("Settings", "Texture repeat", enableTexRepeat);
	ini_write_real("Settings", "Rig opacity", edtRigOpacity);
	ini_write_real("Settings", "Rig scale", edtRigScale);
	ini_write_real("Settings", "Texture filter", enableTexFilter);
	ini_write_real("Settings", "Node perspective", enableNodePerspective);
	ini_write_real("Settings", "Shader enabled", enableShader);

	//Rigging
	ini_write_real("Settings", "Draw primary axis", edtRigShowPrimaryAxis);

	//Skinning
	ini_write_real("Settings", "AutoskinPower", edtSkinPower);
	ini_write_real("Settings", "AutoskinNormalWeighting", edtSkinNormalWeighting);
	ini_write_real("Skinning", "Skinning paint brush size", edtSkinPaintBrushSize);
	ini_write_real("Skinning", "Skinning paint weight", edtSkinPaintWeight);
	ini_write_real("Skinning", "Skinning auto normalize", edtSkinAutoNormalize);
	ini_write_real("Skinning", "Skinning vert visible", edtSkinVertVisible);
	ini_write_real("Skinning", "Skinning vertex paint type", edtSkinVertPaintType);

	//Animation
	ini_write_real("Animation", "Transform children", edtAnimTransformChildren);
	ini_write_real("Animation", "Move from current", edtAnimMoveFromCurrent);

	ini_write_real("Export options", "Include textures", IncludeTex);
	ini_write_real("Export options", "Use compression", useCompression);

	ini_write_real("Export options", "Texpage max size", TexpageMaxSize);
	ini_write_real("Export options", "Texpage extend edges", TexpageExtendEdges);
	ini_write_real("Export options", "Texpage force power of two", TexForcePowerOfTwo);
	ini_close();


}
