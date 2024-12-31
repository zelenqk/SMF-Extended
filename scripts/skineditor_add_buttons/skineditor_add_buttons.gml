function skineditor_add_buttons() {


	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Skinning settings", "", "");
	add_button(0, 16 * (yy++), sButton, "Paint type: " + (edtSkinVertPaintType == edtSkin.Triangle ? "Triangle" : "Vertex"), "Toggle paint type, either drawing to whole triangles or individual vertices. \nPainting individual vertices gives you more precise control, but can make some vertices hard to reach.", "TOGGLEVERTPAINTTYPE");
	add_button(0, 16 * (yy++), sToggle, "Draw paint vertices", "Only available in skinning mode, this will make the vertices that are about to be painted visible", "TOGGLEVERTVISIBLE");
	if edtSkinVertVisible
	{
		add_button(0, 16 * (yy++), sSlider, "PAINTSIZE", "Scale the points showing vertices to be painted", "PAINTSIZE");
	}


	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Automatic skinning", "", "");
	add_button(0, 16 * (yy++), sSlider, "AUTOSKINPOWER", "Weights are assigned to the vertices based on the distance to the vertex raised to a power. \nHigher powers result in \"stiffer\" joints.", "AUTOSKINPOWER");
	add_button(0, 16 * (yy++), sSlider, "NORMALWEIGHTING", "Weights the vertices heavier if the normal points away from the bone. \nThis is useful for when the skeleton is entirely inside the model.", "NORMALWEIGHTING");
	add_button(0, 16 * (yy++), sButton, "Autoskin visible", "Automatically skins all visible models", "AUTOSKINMODEL");

	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Tools", "", "");
	add_button(0, 16 * (yy++), sTool, "Set paint", "Vertex weights will gradually move toward the selected weight", "TOOL0");
	add_button(0, 16 * (yy++), sTool, "Additive paint", "Paint vertex weights onto the model", "TOOL1");
	add_button(0, 16 * (yy++), sTool, "Subtractive paint", "Subtract from the vertex influence of the selected bone", "TOOL2");
	add_button(0, 16 * (yy++), sTool, "Autoskin paint", "Lets you paint vertices to be auto-skinned", "TOOL3");
	add_button(0, 16 * (yy++), sSlider, "Paint radius", "Set the radius of the paint tool.\Note, this radius is defined in pixels on a 256*256 buffer. \nA radius of 256/2 will thus mean that the brush covers the entire view", "PAINTRADIUS");
	add_button(0, 16 * (yy++), sSlider, "Paint weight", "Set the paint weight", "PAINTWEIGHT");

	yy += .5;
	add_button(0, 16 * (yy++), sButton, "Set bone influence", "Sets the selected bone's influence over the selected models to the paint weight", "ASSIGNTOBONE");


}
