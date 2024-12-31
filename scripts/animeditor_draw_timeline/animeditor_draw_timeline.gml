function animeditor_draw_timeline() {
	var tmlWidth = edtTmlPos[2] - edtTmlPos[0];
	var tmlHeight = edtTmlPos[3] - edtTmlPos[1];
	draw_set_color(make_color_rgb(200, 200, 200));
	draw_rectangle(edtTmlPos[0], edtTmlPos[1], edtTmlPos[2], edtTmlPos[3], false);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_bottom);
	
	//Draw timeline intervals
	for (var i = 0; i < 10; i ++)
	{
		draw_set_color(c_white);
		draw_text(edtTmlPos[0] + i / 10 * tmlWidth, edtTmlPos[1] - 2, string(i / 10));
			draw_set_color(c_gray);
		draw_line_width(edtTmlPos[0] + i / 10 * tmlWidth, edtTmlPos[1], edtTmlPos[0] + i / 10 * tmlWidth, edtTmlPos[3], 3);
		for (var j = 0; j < 10; j ++)
		{
			draw_line_width(edtTmlPos[0] + (i / 10 + j / 100) * tmlWidth, edtTmlPos[1], edtTmlPos[0] + (i / 10 + j / 100) * tmlWidth, edtTmlPos[3], 1);
		}
	}

	//Exit if there are no animations loaded
	var model = -1;
	var animation = -1; 
	if (edtSMFSel >= 0)
	{
		model = edtSMFArray[edtSMFSel];
		var mBuff = model.mBuff;
		var vBuff = model.vBuff;
		var vis = model.vis;
		var texPack = model.texPack;
		var wire = model.Wire;
		var selList = model.SelModelList;
		var selNode = model.SelNode;
		var animArray = model.animations;
		var selAnim = model.SelAnim;
		var selKeyframe = model.SelKeyframe;
		var rig = model.rig;
	}
	else
	{
		exit;
	}
	if selAnim >= array_length(animArray)
	{
		exit;
	}
	var animation = animArray[selAnim];;
	var keyframeGrid = animation.keyframeGrid;
	var keyframeNum = ds_grid_height(keyframeGrid);
		
	//Draw sample frames
	draw_set_alpha(0.5);
	var frameNum = keyframeNum * animation.sampleFrameMultiplier;
	for (var i = 0; i <= frameNum; i ++)
	{
		var xx = edtTmlPos[0] + tmlWidth * i / frameNum;
		draw_set_color(c_blue);
		draw_rectangle(max(xx - 1, edtTmlPos[0]), edtTmlPos[1], xx + 1, edtTmlPos[3], false);
		draw_set_color(c_black);
		draw_rectangle(max(xx - 1, edtTmlPos[0]), edtTmlPos[1], xx + 1, edtTmlPos[3], true);
	}
	draw_set_alpha(1);
		
	//Draw keyframes
	for (var i = 0; i < keyframeNum; i ++)
	{
		var xx = edtTmlPos[0] + tmlWidth * keyframeGrid[# 0, i];
		if i == 0{xx += 5;}
		draw_set_color(c_green);
		if i == selKeyframe{draw_set_color(c_red);}
		draw_rectangle(max(xx - 5, edtTmlPos[0]), edtTmlPos[1], xx + 5, edtTmlPos[3], false);
		draw_set_color(c_black);
		draw_rectangle(max(xx - 5, edtTmlPos[0]), edtTmlPos[1], xx + 5, edtTmlPos[3], true);
		draw_rectangle(xx - 1, edtTmlPos[1], xx + 1, edtTmlPos[3], true);
	}
		
		
	//Draw blue time indicator
	if edtAnimPlay
	{
		xx = edtTmlPos[0] + tmlWidth * edtAnimPlayTime;
		draw_set_color(c_blue);
		draw_rectangle(xx - 3, edtTmlPos[1], xx + 3, edtTmlPos[3], false);
		draw_set_color(c_black);
		draw_rectangle(xx - 3, edtTmlPos[1], xx + 3, edtTmlPos[3], true);
		draw_rectangle(xx - 1, edtTmlPos[1], xx + 1, edtTmlPos[3], true);
	}
		
	//Draw mouse indicator
	if (window_mouse_get_x() > edtTmlPos[0] && window_mouse_get_x() < edtTmlPos[2] && window_mouse_get_y() > edtTmlPos[1] && window_mouse_get_y() < edtTmlPos[3])
	{
		draw_sprite(sTime, 0, window_mouse_get_x(), edtTmlPos[1]);
	}


}
