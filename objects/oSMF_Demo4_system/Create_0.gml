/// @description
event_inherited();

/////////////////////////////////////////////////////////
//---------------------Settings------------------------//
/////////////////////////////////////////////////////////
gpu_set_tex_mip_enable(mip_on);
game_set_speed(9999, gamespeed_fps);

/////////////////////////////////////////////////////////
//---------------Load necessary models-----------------//
/////////////////////////////////////////////////////////
global.modAxe = smf_model_load_async("SMF/Axe.smf");
global.modDwarf = smf_model_load_async("SMF/Dwarf.smf");
global.modHammer = smf_model_load_async("SMF/Hammer.smf");

/////////////////////////////////////////////////////////
//-------------Spawn player and weapons----------------//
/////////////////////////////////////////////////////////
instance_create_depth(room_width / 2, room_height / 2, -1, oSMF_Demo4_player);
instance_create_depth(room_width / 2 + 70, room_height / 2 + 70, -1, oSMF_Demo4_axe);
instance_create_depth(room_width / 2 - 70, room_height / 2 - 70, -1, oSMF_Demo4_hammer);