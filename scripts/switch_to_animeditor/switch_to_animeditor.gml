function switch_to_animeditor() {
	var model = edtSMFArray[edtSMFSel];
	if (edtAutosaveModelChanged)
	{
		autosave_save(edtAutosaveType.Models);
		edtAutosaveModelChanged = false;
		modeleditor_update_wireframe();
	}
	if (edtAutosaveTexturesChanged)
	{
		autosave_save(edtAutosaveType.Textures);
		edtAutosaveTexturesChanged = false;
	}
	if (edtAutosaveRigChanged)
	{
		autosave_save(edtAutosaveType.BindPose);
		edtAutosaveRigChanged = false;
	}
	var animArray = model.animations;
	var animNum = array_length(animArray);
	if (model.SelKeyframe < 0)
	{
		model.Sample = sample_create_bind(model.rig);
	}
	else
	{
		model.SelKeyframe = 0;
		if (animNum == 0)
		{
			model.Sample = sample_create_bind(model.rig);
		}
		else
		{
			var animInd = animArray[model.SelAnim];
			var keyframeGrid = animInd.keyframeGrid;
			var keyframeTime = keyframeGrid[# 0, model.SelKeyframe];
			model.Sample = anim_generate_sample(model.rig, animInd, keyframeTime, eAnimInterpolation.Keyframe);
		}
	}
	for (var i = 0; i < animNum; i ++)
	{
		_anim_update(animArray[i]);
		model.SampleStrip = -1;
	}
	model.SelNode = -1;
	global.editMode = eTab.Animation;
	selectedTool = edtAnimSelTool;
	buttons_update();


}
