/// @description

event_inherited();

/////////////////////////////////////////////////////////
//---------------Load necessary models-----------------//
/////////////////////////////////////////////////////////
global.modMan = smf_model_load_async("SMF/Buffguy.smf");

/////////////////////////////////////////////////////////
//---------------------Settings------------------------//
/////////////////////////////////////////////////////////
gpu_set_tex_mip_enable(mip_on);
game_set_speed(9999, gamespeed_fps);

/////////////////////////////////////////////////////////
//---------------Spawn player and NPCs-----------------//
/////////////////////////////////////////////////////////
instance_create_depth(room_width / 2, room_height / 2, -1, oSMF_Demo3_player);
repeat 30
{
	var xx = room_width / 2 + random_range(-1, 1) * room_width * .4;
	var yy = room_height / 2 + random_range(-1, 1) * room_height * .4;
	instance_create_depth(xx, yy, -1, oSMF_Demo3_NPC);
}