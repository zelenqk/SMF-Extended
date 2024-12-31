function modeleditor_add_buttons() {
	toolNum = 0;

	base_y = yy;

	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Free transform", "", "");
	add_button(0, 16 * (yy++), sTool, "No tool", "No tool selected", "TOOL" + string(eMOD.None));
	add_button(0, 16 * (yy++), sTool, "Move model", "Move the model before rigging", "TOOL" + string(eMOD.Move));
	add_button(0, 16 * (yy++), sTool, "Scale model", "Scale the model before rigging", "TOOL" + string(eMOD.Scale));
	add_button(0, 16 * (yy++), sTool, "Rotate model", "Rotate the model before rigging", "TOOL" + string(eMOD.Rotate));
	add_button(0, 16 * (yy++), sButton, "Scale", "Lets you write how much, in percent, the model should be scaled.", "NUMERICALSCALE");

	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Modify model", "", "");
	add_button(0, 16 * (yy++), sButton, "Flip triangles", "Flips the draw order of the triangles, in case they get culled the wrong way", "FLIPTRIANGLES");
	add_button(0, 16 * (yy++), sButton, "Spin around X", "Spin model 90 degrees around x-axis", "SPINX");
	add_button(0, 16 * (yy++), sButton, "Spin around Y", "Spin model 90 degrees around y-axis", "SPINY");
	add_button(0, 16 * (yy++), sButton, "Spin around Z", "Spin model 90 degrees around z-axis", "SPINZ");

	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Generate normals", "", "");
	add_button(0, 16 * (yy++), sButton, "Flat normals", "Creates flat triangle normals.", "FLATNORMALS");
	add_button(0, 16 * (yy++), sButton, "Smooth normals", "Creates smooth triangle normals.", "SMOOTHNORMALS");
	add_button(0, 16 * (yy++), sButton, "Flat tangents", "Creates flat triangle tangents in the auxiliary colour attribute.", "FLATTANGENTS");
	add_button(0, 16 * (yy++), sButton, "Smooth tangents", "Creates smooth triangle tangents in the auxiliary colour attribute.", "SMOOTHTANGENTS");

	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Optimization", "", "");
	//add_button(0, 16 * (yy++), sButton, "Merge same textures", "Merges models that use the same texture.", "MERGESAME")
	add_button(0, 16 * (yy++), sToggle, "Force power of two", "Forces the size of texture pages to be powers of two.", "TEXFORCEPOWTWO");
	add_button(0, 16 * (yy++), sSlider, "", "The maximum size limit of a texture page. \nThe SMF system allows textures that aren't a power of two, and the textures don't have to be on their own texture page when imported into GM!", "TEXPAGEMAXSIZE");
	add_button(0, 16 * (yy++), sSlider, "", "Extend the edges of each texture, to avoid bleedover from nearby textures. \nThis should be increased if you plan to use mipmapping!", "TEXPAGEEXTEND");
	add_button(0, 16 * (yy++), sButton, "Combine to texpages", "Combines models and textures.", "COMBINETOTEXPAGES");
	yy += .5;
	add_button(0, 16 * (yy++), sButton, "Tesselate UVs", "Creates flat triangle normals.", "TESSELATE");


}
