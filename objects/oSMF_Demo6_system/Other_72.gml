/// @description
event_inherited();

if (loading == false)
{
	/////////////////////////////////////////////////////////
	//-------------------Spawn player----------------------//
	/////////////////////////////////////////////////////////
	instance_create_depth(room_width / 2, room_height / 2, -1, oSMF_Demo6_player);
}