/// @description show_scroll_menu(handle, ds_list)
/// @param ds_list
function show_scroll_menu(argument0, argument1) {
	editorScrollmenuHandle = argument0;
	editorScrollmenuActive = true;
	editorScrollmenu = argument1;
	editorScrollmenuNum = ds_list_size(argument1) / 3;
	editorScrollmenuScroll = 0;
	editorScrollmenuHeight = min(editorScrollmenuNum * 16 + 8, editHeight * 2);
	editorScrollmenuLimitedNum = editorScrollmenuHeight div 16;
	var w = 0;
	for (var i = 0; i < editorScrollmenuNum; i ++){
		w = max(w, string_width(string(argument1[| i*3])));}
	editorScrollmenuWidth = w + 24 + 16;
	editorScrollmenuX = min(window_mouse_get_x() + 4, window_get_width() - editorScrollmenuWidth);
	editorScrollmenuY = min(window_mouse_get_y() + 4, window_get_height() - editorScrollmenuHeight);
	editorScrollmenuFadeIn = 0;

	mouseScroll = false;
	clicks = 1;


}
