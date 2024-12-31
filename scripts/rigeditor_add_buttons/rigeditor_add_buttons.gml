function rigeditor_add_buttons() {
	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Save and load", "", "");
	add_button(0, 16 * (yy++), sButton, "Load rig", "Load a rig from a previously created SMF model", "LOADRIG");
	add_button(0, 16 * (yy++), sButton, "Clear rig", "Remove all bones from the rig", "CLEARRIG");

	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Node tools", "", "");
	add_button(0, 16 * (yy++), sToggle, "Toggle primary axis", "Toggle whether or not the primary IK axis should be visible\nThe primary axis is the first axis to rotate around when doing inverse kinematics.\nControlling this is useful to avoid bones bending in strange ways.\nAll bones will automatically generate this axis, even if this button is toggled off.", "TOGGLEPRIMARYAXIS");
	add_button(0, 16 * (yy++), sTool, "Select nodes", "Select nodes by clicking them", "TOOL0");
	add_button(0, 16 * (yy++), sTool, "Add nodes", "Add nodes by clicking in an empty space.", "TOOL1");
	add_button(0, 16 * (yy++), sTool, "Move node", "Click nodes and drag to move them. \nDoesn't work in 3D view.", "TOOL2");
	add_button(0, 16 * (yy++), sTool, "Rotate node", "Rotate the node's orientation so that it'll be easier to animate later", "TOOL3");
	add_button(0, 16 * (yy++), sButton, "Insert node", "Inserts a new node before the selected node", "INSERTNODE");
	add_button(0, 16 * (yy++), sButton, "Delete node", "Deletes the selected node", "DELETENODE");
	add_button(0, 16 * (yy++), sButton, "Detach/reattach node", "Detaches the selected node from its parent, so that it can move around individually. \nIt will still be affected by its parent's orientation", "DETACHNODE");
	add_button(0, 16 * (yy++), sButton, "Deselect node (D)", "Deselect the selected node", "DESELECTNODE");

	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Transform rig", "", "");
	add_button(0, 16 * (yy++), sTool, "Move rig", "Move the rig", "TOOL4");
	add_button(0, 16 * (yy++), sTool, "Scale rig", "Scale the rig", "TOOL5");
	add_button(0, 16 * (yy++), sTool, "Rotate rig", "Rotate the rig", "TOOL6");
	add_button(0, 16 * (yy++), sButton, "Spin rig around X", "Spin rig 90 degrees around x-axis", "SPINRIGX");
	add_button(0, 16 * (yy++), sButton, "Spin rig around Y", "Spin rig 90 degrees around y-axis", "SPINRIGY");
	add_button(0, 16 * (yy++), sButton, "Spin rig around Z", "Spin rig 90 degrees around z-axis", "SPINRIGZ");

	/*
	xx = 128 + editWidth * 2 + 1;
	yy = 5.5;
	add_button(xx, 16 * (yy++), sCategory, "Subdivide rig", "", "");
	add_button(xx, 16 * (yy++), sButton, "Create subrig", "", "ADDLIMB");
	add_button(xx, 16 * (yy++), sButton, "Delete subrig", "", "DELLIMB");
	add_button(xx, 16 * (yy++), sTool, "Add bones", "", "TOOL8");

	yy += .5;
	add_button(xx, 16 * (yy++), sCategory, "Subdivisions", "", "");
	var num = array_length(rigSubDivs);
	for (var i = 0; i < num; i ++)
	{
		add_button(xx, 16 * (yy++), sButtonWhite, "Subrig " + string(i), "", "SUBRIG" + string(i));
		var sub = rigSubDivs[i];
		var subNum = array_length(sub);
		for (var j = 0; j < subNum; j ++)
		{
			add_button(32 + xx, 16 * (yy++), sButtonSmall, "Node " + string(sub[j]), "", "NODE" + string(sub[j]));
		}
	}

/* end rigeditor_add_buttons */
}
