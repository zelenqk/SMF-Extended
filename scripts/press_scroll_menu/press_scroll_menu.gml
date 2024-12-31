/// @description press_scroll_menu()
function press_scroll_menu() {

	//Exit if there is no button selected (which shouldn't really ever happen, but it's good to be on the safe side)
	if !instance_exists(edtSelButton){
		editorScrollmenuActive = false;
		ds_list_destroy(editorScrollmenu);
		exit;}
	
	var model = -1;
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

	//Find mouse coordinates within the dropdown menu
	mouseScrollX = window_mouse_get_x() - editorScrollmenuX;
	mouseScrollY = window_mouse_get_y() - editorScrollmenuY;

	//If we're scrolling by manually pressing the scrolling bar
	if mouseScroll{
		editorScrollmenuScroll = round(clamp(mouseScrollY / editorScrollmenuHeight, 0, 1) * (editorScrollmenuNum - editorScrollmenuLimitedNum));
		if !mouse_check_button(mb_left){mouseScroll = false;}
		exit;}
	if mouse_check_button_released(mb_left) || mouse_check_button_released(mb_right){clicks--;}

	//Scrolling
	if mouseScrollX > editorScrollmenuWidth - 16 and mouseScrollX < editorScrollmenuWidth and mouseScrollY > 0 and mouseScrollY < editorScrollmenuHeight{
		mouseScroll = true;}
	if mouse_wheel_up(){
		editorScrollmenuScroll -= 2;}
	if mouse_wheel_down(){
		editorScrollmenuScroll += 2;}
	editorScrollmenuScroll = clamp(editorScrollmenuScroll, 0, editorScrollmenuNum - editorScrollmenuLimitedNum);

	//Exit is the mouse is not within the dropdown menu borders
	if mouseScrollX < 0 or mouseScrollY < 0 or mouseScrollX > editorScrollmenuWidth or mouseScrollY > editorScrollmenuHeight or clicks >= 0{
		if clicks < 0{editorScrollmenuActive = false;}
		exit;}

	//If the mouse hasn't just been released, don't perform any actions
	if !mouse_check_button_released(mb_left){
		exit;}
	
	//We've selected an option, and now we need to react to this
	editorScrollmenuActive = false;
	mouseScrollInd = editorScrollmenuScroll + (mouseScrollY - 4) div 16;
	switch editorScrollmenuHandle
	{
		case "SELECTTEXTURE":
			edtAutosaveTexturesChanged = true;
			if mouseScrollInd == 0
			{
				var fname = get_open_filename("Image files (.png, .bmp, .jpg)|*.png;*.bmp;*.jpg;*.jpeg;", "");
				if fname != ""
				{
					//var name = filename_name(filename_change_ext(fname, ""));
					var ext = string_upper(filename_ext(fname));
					var spr = -1;
					if ext == ".PNG" || ext == ".JPG" || ext == ".JPEG"
					{
						spr = sprite_add(fname, 1, 0, 0, 0, 0);
					}
					else if ext == ".BMP"
					{
						spr = _load_bmp(fname);
					}
					if (spr >= 0)
					{
						texPack[@ selList[| 0]] = spr;
					}
				}
			}
			else
			{
				var prevTex = texPack[selList[| 0]];
				texPack[@ selList[| 0]] = editorScrollmenu[| mouseScrollInd*3+1];
				if (smf_get_array_index(texPack, prevTex) < 0)
				{
					var num = array_length(texPack);
					model.texPack = array_create(num + 1);
					array_copy(model.texPack, 0, texPack, 0, num);
					array_set(model.texPack, num, prevTex);
				}
			}
			break;
		case "SUBMODELRIGHTCLICK":
			edtAutosaveModelChanged = true;
			if mouseScrollInd == 0 //Move to top
			{
				var num = ds_list_size(selList);
				if num == 0{break;}
				ds_list_sort(selList, true);
				var texNum = array_length(texPack);
				for (var i = 0; i < num; i ++)
				{
					//Move models to the top
					var m = selList[| i];
					var _vis = vis[m];
					var _mbuff = mBuff[m]; 
					var _vbuff = vBuff[m];
					var _wire = wire[m];
					var _tex = texPack[m mod texNum];
					
					//Shift other models down by one
					for (var j = m - 1; j >= i; j --)
					{
						vis[j + 1] = vis[j];
						mBuff[@ j + 1] = mBuff[j];
						vBuff[@ j + 1] = vBuff[j];
						wire[@ j + 1] = wire[j];
						texPack[@ (j + 1) mod texNum] = texPack[j mod texNum];
					}
					
					mBuff[@ i] = _mbuff;
					vBuff[@ i] = _vbuff;
					wire[@ i] = _wire;
					vis[@ i] = _vis;
					texPack[@ i] = _tex;
					
					selList[| i] = i;
				}
				skineditor_clear_tri_ind_model();
			}
			else if mouseScrollInd == 1 //Move to bottom
			{
				var num = ds_list_size(selList);
				if num == 0{break;}
				var modelNum = array_length(mBuff);
				ds_list_sort(selList, false);
				var texNum = array_length(texPack);
				for (var i = 0; i < num; i ++)
				{
					//Move models to the bottom
					var k = modelNum - i - 1;
					var m = selList[| i];
					var _vis = vis[m];
					var _mbuff = mBuff[m]; 
					var _vbuff = vBuff[m];
					var _wire = wire[m];
					var _tex = texPack[m mod texNum];
					
					//Shift other models up by one
					for (var j = m + 1; j <= k; j ++)
					{
						vis[@ j - 1] = vis[j];
						mBuff[@ j - 1] = mBuff[j];
						vBuff[@ j - 1] = vBuff[j];
						wire[@ j - 1] = wire[j];
						texPack[@ (j - 1)] = texPack[j mod texNum];
					}
				
					mBuff[@ k] = _mbuff;
					vBuff[@ k] = _vbuff;
					wire[@ k] = _wire;
					vis[@ k] = _vis;
					texPack[@ k] = _tex;
					
					selList[| i] = k;
				}
				skineditor_clear_tri_ind_model();
			}
			else if mouseScrollInd == 2 //Merge selected models
			{
				if show_question("Are you sure you want to merge the selected models?")
				{
					undo_save("Merge submodels", edtUndoType.Models);
					editor_show_message("Merged selected models");
				
					ds_list_sort(selList, true);
					num = ds_list_size(selList);
					for (var i = 1; i < num; i ++)
					{
						mbuff_combine(mBuff[selList[| 0]], mBuff[selList[| i]]);					
					}
					ds_list_sort(selList, false);
				
					for (var i = 0; i < num - 1; i ++)
					{
						model.mBuff = mbuff_remove(model.mBuff, selList[| i]);
						model.texPack = texpack_remove_sprite(texPack, selList[| i]);
					}
					
					vbuff_delete(vBuff);
					model.vBuff = vbuff_create_from_mbuff(model.mBuff);
					modeleditor_update_wireframe();
					var ind = selList[| num - 1];
					ds_list_clear(selList);
					selList[| 0] = ind;
					buttons_update();
					skineditor_clear_tri_ind_model();
				}
			}
			else if mouseScrollInd == 3 //Delete selected models
			{
				if show_question("Are you sure you want to delete the selected models?")
				{
					undo_save("Delete selected models", edtUndoType.Models);
					editor_show_message("Deleted selected models");
					ds_list_sort(selList, false);
					var num = ds_list_size(selList);
					for (var i = 0; i < num; i ++)
					{
						var ind = selList[| i];
						if is_undefined(ind){break;}
						mbuff_delete(mBuff[ind]);
						var oldMbuff = mBuff;
						var size = array_length(oldMbuff) - 1;
						model.mBuff = array_create(size);
						mBuff = model.mBuff;
						array_copy(mBuff, 0, oldMbuff, 0, ind);
						for (var j = ind; j < size; j ++)
						{
							mBuff[@ j] = oldMbuff[j + 1];
							vis[@ j] = vis[j + 1];
							texPack[@ j] = texPack[j + 1];
						}
					}
					ds_list_clear(selList);
					vbuff_delete(vBuff);
					model.vBuff = vbuff_create_from_mbuff(mBuff);
					modeleditor_update_wireframe();
					buttons_update();
					skineditor_clear_tri_ind_model();
				}
			}
			break;
	}
	ds_list_destroy(editorScrollmenu);


}
