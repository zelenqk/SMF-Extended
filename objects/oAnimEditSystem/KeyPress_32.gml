/// @description Start animation
if global.editMode == eTab.Animation
{
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
	if (model < 0)
	{
		exit;
	}
	if (array_length(animArray) == 0){exit;}
	edtAnimPlay = !edtAnimPlay;
	edtAnimPlayTime = 0;
	if selKeyframe >= 0
	{
		var animInd = animArray[selAnim];;
		var keyframeGrid = animInd.keyframeGrid;
		var keyframeTime = keyframeGrid[# 0, selKeyframe]
		edtAnimPlayTime = keyframeTime;
	}
	if !edtAnimPlay
	{
		var animInd = animArray[selAnim];;
		var keyframeGrid = animInd.keyframeGrid;
		var keyframeTime = keyframeGrid[# 0, selKeyframe]
		model.Sample = anim_generate_sample(rig, animArray[selAnim], keyframeTime, eAnimInterpolation.Keyframe);
	}
}
edtSelButton = -1;