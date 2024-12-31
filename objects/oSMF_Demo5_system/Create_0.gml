/// @description
event_inherited();

global.modCar = smf_model_load_async("SMF/Van.smf");

/////////////////////////////////////////////////////////
//---------------------Settings------------------------//
/////////////////////////////////////////////////////////
gpu_set_tex_mip_enable(mip_on);
game_set_speed(60, gamespeed_fps);

/////////////////////////////////////////////////////////
//-------------------Spawn player----------------------//
/////////////////////////////////////////////////////////
instance_create_depth(room_width / 2, room_height / 2, -1, oSMF_Demo5_player);