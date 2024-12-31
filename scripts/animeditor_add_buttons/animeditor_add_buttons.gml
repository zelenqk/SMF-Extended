function animeditor_add_buttons() {
	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Keyframes", "", "");
	add_button(0, 16 * (yy++), sButton, "Clear keyframe", "Clears the selected frame", "CLEARKEYFRAME");
	add_button(0, 16 * (yy++), sButton, "Delete keyframe", "Removes the selected frame", "DELETEKEYFRAME");

	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Edit keyframe", "", "");
	add_button(0, 16 * (yy++), sToggle, "Transfrm children (E)", "Whenever you transform a node, enabling this will also transform its children. \nIf disabled, its children will only move to stay attached to the tip of the transformed bone.", "TRANSFORMCHILDREN");
	add_button(0, 16 * (yy++), sToggle, "Move from current", "This changes how the inverse kinematics works. \nIf enabled, the primary rotation axis will be transformed by the \norienation of the parent bone.\nIf not, the primary axis will stay constant no matter the orientation of the rig.\nEnabling this makes it easier to do small adjustments to an existing pose, \nbut it may also twist bones into unnatural orientations.", "MOVEFROMCURRENT");
	add_button(0, 16 * (yy++), sTool, "Drag node", "Lets you drag nodes.", "TOOL0");
	add_button(0, 16 * (yy++), sTool, "Move node IK", "Lets you move nodes. \nNodes that represent bones will be moved using inverse kinematics", "TOOL1");
	add_button(0, 16 * (yy++), sTool, "Rotate local (L)", "Rotate the node around its own axes", "TOOL2");
	add_button(0, 16 * (yy++), sTool, "Rotate global (G)", "Rotate the node around the global xyz axes", "TOOL3");

	yy += .5;
	add_button(0, 16 * (yy++), sCategory, "Various", "", "");
	add_button(0, 16 * (yy++), sButton, "Reset node", "Resets the node to its bind position", "RESETNODE");
	add_button(0, 16 * (yy++), sButton, "Lock node", "Locks the selected node in place. This is useful for animations where you want\na node to stay in one position while you move the rest of the rig", "LOCKNODE");
	add_button(0, 16 * (yy++), sButton, "Copy node", "Copies the selected node's world-space orientation to clipboard", "COPYNODE");
	add_button(0, 16 * (yy++), sButton, "Paste node", "Pastes a previously copied node's world-space orientation to the current keyframe", "PASTENODE");
	add_button(0, 16 * (yy++), sButton, "Flip node", "Dual quaternions can represent the same orientation in two different ways. \nSometimes you'll want to switch from one orientation to the other. This button lets you do that.", "FLIPNODE");

	xx = 128;
	yy = borderY - 32;
	add_button(xx, yy, sCategory, "Keyframe tool", "", "");
	yy += 16;
	add_button(xx, yy, sButtonFourth, "Copy", "Copy the selected keyframe to clipboard. Can be copied between animations!", "COPYKEYFRAME");
	add_button(xx+128/4, yy, sButtonFourth, "Pste", "Paste the frame on the clipboard to animation. \nNote: You can add new keyframes by double-clicking the timeline!", "PASTEKEYFRAME");
	add_button(xx+2*128/4, yy, sButtonFourth, "Bind", "Adds new blank keyframes.\nNote: You can add new keyframes by double-clicking the timeline!", "ADDKEYFRAME");
	add_button(xx+3*128/4, yy, sButtonFourth, "Insrt", "Lets you create new intermediary keyframes\nNote: You can insert new keyframes by double-clicking the timeline!", "INSERTKEYFRAME");

	xx = 128 + editWidth * 2 + 1;
	yy = 5;

	add_button(xx, 16 * (yy++), sCategory, "Play animation", "", "");
	add_button(xx, 16 * (yy++), sButton, "Play", "Play animation with linear interpolation", "ANIMPLAY");

	yy += .5;
	add_button(xx, 16 * (yy++), sCategory, "Animation settings", "", "");
	add_button(xx, 16 * (yy++), sButton, "Play time: ", "Opens a dialogue asking for new play time in milliseconds", "ANIMATIONSPEED");
	add_button(xx, 16 * (yy++), sToggle, "Enable looping", "When enabled, the sample will be interpolated between the last and the first keyframes.\nWhen disabled, the last keyframe will \"freeze\" at the end of the animation.", "ANIMLOOP");
	add_button(xx, 16 * (yy++), sCategory, "Interpolation", "Lets you define the type of interpolation for this animation", "");
	add_button(xx ,		 16 * yy, sButtonThird, "None", "No interpolation. \nReturns the nearest keyframe", "ANIMNOINTERPOLATION");
	add_button(xx +  43, 16 * yy, sButtonThird, "Linear", "Linear interpolation. \nThe sample will be linearly interpolated between the nearest two keyframes", "ANIMLINEARINTERPOLATION");
	add_button(xx +  86, 16 * yy, sButtonThird, "Quad", "Quadratic interpolation. \nThe sample will be interpolated between the nearest three keyframes", "ANIMQUADRATICNTERPOLATION");

	yy ++;
	add_button(xx, 16 * (yy++), sCategory, "Frame multiplier", "Animations are split up into smaller segments in order to make generating samples faster.\nThe number of frames is defined as (number of keyframes) x (frame multiplier). \nA higher frame multiplier leads to more precise animations, but consumes more memory.", "");
	add_button(xx, 16 * (yy++), sSlider, "", "Animations are split up into smaller segments in order to make generating samples faster.\nThe number of frames is defined as (number of keyframes) x (frame multiplier). \nA higher frame multiplier leads to more precise animations, but consumes more memory.", "FRAMEMULTIPLIER");

	yy += .5;
	add_button(xx, 16 * (yy++), sCategory, "Animation indices", "", "");
	add_button(xx, 16 * (yy++), sButton, "New animation", "", "NEWANIM");
	add_button(xx, 16 * (yy++), sButton, "Load animation", "Load an animation", "LOADANIM");
	yy += .5;
	
	var model = -1;
	if (edtSMFSel >= 0)
	{
		model = edtSMFArray[edtSMFSel];
		var mBuff = model.mBuff;
		var vBuff = model.vBuff;
		var vis = model.vis;
		var texPack = model.texPack;
		var wire = model.Wire;
		var selList = model.SelModelList;
		var selNode = model.SelNode;
		var animArray = model.animations;
		var selAnim = model.SelAnim;
		var selKeyframe = model.SelKeyframe;
		var rig = model.rig;
	}
	else
	{
		exit;
	}
	var animNum = array_length(animArray);
	edtMaxButtons = floor((editHeight * 2) div 24 - yy * 16 / 24 - 3);
	edtAnimIndexScroll = max(min(edtAnimIndexScroll, animNum - edtMaxButtons), 0);
	if animNum > 0
	{
		if edtAnimIndexScroll
		{
			add_button(xx, 16 * yy, sModelScrollUp, "", "", "ANIMSCROLLUP");
		}
		yy ++;
		
		var dy = yy * 16 + 6;
		var i = 0;
		while i < min(edtMaxButtons, animNum)
		{
			var animInd = animArray[edtAnimIndexScroll + i];
			var name = animInd.name;
			add_button(xx, dy + i * 24, sAnimationTab, name, "", "ANIMINDEX" + string(edtAnimIndexScroll + i));
			i ++;
		}
		yy += 24 / 16 * i;
		if animNum > edtAnimIndexScroll + edtMaxButtons
		{
			add_button(xx, 16 * yy, sModelScrollDown, "", "", "ANIMSCROLLDOWN");
		}
		yy ++;
	}


}
