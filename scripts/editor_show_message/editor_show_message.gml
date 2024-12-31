/// @description editor_show_message
/// @param string
function editor_show_message(argument0) {
	var ID = instance_create_depth(0, 0, 0, oAnimEditMessage);
	with ID
	{
		text = argument0;
	}
	return ID;


}
