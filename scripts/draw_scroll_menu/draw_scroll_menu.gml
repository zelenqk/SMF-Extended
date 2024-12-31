function draw_scroll_menu() {
	if editorScrollmenuActive
	{
		var mouseScrollX = window_mouse_get_x() - editorScrollmenuX;
		var mouseScrollY = window_mouse_get_y() - editorScrollmenuY;
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		draw_set_color(c_dkgray);
		draw_rectangle(editorScrollmenuX, editorScrollmenuY, editorScrollmenuX + editorScrollmenuWidth, editorScrollmenuY + editorScrollmenuHeight, false);
		for (var i = 0; i < editorScrollmenuLimitedNum; i ++)
		{
			j = (editorScrollmenuScroll + i) * 3;
			if mouseScrollX >= 0 and mouseScrollY >= 4+i*16 and mouseScrollX <= editorScrollmenuWidth and mouseScrollY < 4+i*16+16
			{
				draw_set_color(c_gray);
				draw_rectangle(editorScrollmenuX, editorScrollmenuY + i * 16, editorScrollmenuX + editorScrollmenuWidth, editorScrollmenuY + 3 + i * 16 + 16, false);
			}
			draw_set_color(c_white);
			if editorScrollmenu[| j+1] >= 0
			{
				draw_sprite_stretched(editorScrollmenu[| j+1], editorScrollmenu[| j+2], editorScrollmenuX + 3, editorScrollmenuY + 3 + i * 16, 14, 14);
			}
			draw_text(editorScrollmenuX + 3 + 17 * (editorScrollmenu[| j+1] >= 0), editorScrollmenuY + 4 + i * 16, editorScrollmenu[| j]);
		}
		if editorScrollmenuLimitedNum < editorScrollmenuNum
		{
			var amount = editorScrollmenuScroll / (editorScrollmenuNum - editorScrollmenuLimitedNum);
			draw_set_color(c_gray);
			draw_rectangle(editorScrollmenuX + editorScrollmenuWidth - 12, editorScrollmenuY, editorScrollmenuX + editorScrollmenuWidth, editorScrollmenuY + editorScrollmenuHeight, false);
			draw_set_color(c_dkgray);
			draw_rectangle(editorScrollmenuX + editorScrollmenuWidth - 12, editorScrollmenuY + (editorScrollmenuHeight-32) * amount, editorScrollmenuX + editorScrollmenuWidth, editorScrollmenuY + (editorScrollmenuHeight-32) * amount + 32, false);
			draw_set_color(c_white);
			draw_rectangle(editorScrollmenuX + editorScrollmenuWidth - 12, editorScrollmenuY + (editorScrollmenuHeight-32) * amount, editorScrollmenuX + editorScrollmenuWidth, editorScrollmenuY + (editorScrollmenuHeight-32) * amount + 32, true);
		}
		draw_set_color(c_white);
		draw_rectangle(editorScrollmenuX, editorScrollmenuY, editorScrollmenuX + editorScrollmenuWidth, editorScrollmenuY + editorScrollmenuHeight, true);
	}


}
