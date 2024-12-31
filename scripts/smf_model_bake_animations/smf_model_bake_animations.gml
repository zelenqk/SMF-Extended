// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function smf_model_bake_animations(model)
{
	for (var i = array_length(model.animations) - 1; i >= 0; --i)
	{
		sampleStrip = new smf_samplestrip(model.rig, model.animations[i]);
		for (var j = sampleStrip.steps; j >= 0; --j)
		{
			sampleStrip.get_sample(j);
		}
		model.sampleStrips[i] = sampleStrip;
	}
}