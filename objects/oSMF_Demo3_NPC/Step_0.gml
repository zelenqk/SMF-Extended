/// @description
var timeStep = delta_time * 60 / 1000000;

//Check distance to player
var dist = point_distance(x, y, oSMF_Demo3_player.x, oSMF_Demo3_player.y);

var diff = angle_difference(-point_direction(x, y, oSMF_Demo3_player.x, oSMF_Demo3_player.y), faceDir);
if (abs(diff) > 120 || dist > 50)
{
	diff = 0
}
headDir += (diff - headDir) * .05 * timeStep;

//Enable fast sampling for distant NPCs
if (dist > 100 && abs(headDir) < 2)
{
	smf_instance_enable_fast_sampling(mainInst, true);
	smf_instance_step(mainInst, timeStep);
	exit;
}
smf_instance_enable_fast_sampling(mainInst, false);
smf_instance_step(mainInst, timeStep);

/////////////////////////////////////////
//Turn the NPCs head towards the player
if abs(headDir) > 1
{
	//Turn torso halfway
	smf_instance_node_rotate_z(mainInst, 1, headDir * .7);
	//Turn head the rest of the way
	smf_instance_node_rotate_z(mainInst, 2, headDir * .3);
}