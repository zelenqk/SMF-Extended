function draw_buttons() {
	draw_set_font(font_0);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	//Model settings
	var model = -1;
	var animation = -1;
	if edtSMFSel >= 0
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
		if selAnim < array_length(animArray)
		{
			animation = animArray[selAnim];;
		}
	}

	with oAnimEditButton
	{
		var drawText = text;
		var actualValue = 0;
		var sliderValue = 0;
		var col = c_white;
		draw_set_color(c_white);
		var ind = 0;
		if id == edtSelButton{ind = 1;}
		if global.editMode == eTab.Rigging && handle == "TOOL1" && selectedTool == RIGMOVEAFTERPLACE{ind = 1;}
		else if string_count("TOOL", handle) && selectedTool == real(string_delete(handle, 1, 4)){ind = 1;}
		else if string_count("SUBMODEL", handle)
		{
			var index = real(string_delete(handle, 1, 8));
			ind = vis[index];
			ind += 2 * (ds_list_find_index(selList, index) >= 0);
		}
		else if string_count("ANIMINDEX", handle)
		{
			var index = real(string_delete(handle, 1, 9));
			ind = (index == selAnim);
			if ind && string_width(drawText) > 49
			{
				drawText = string_copy(drawText, 1, 5) + "...";
			}
		}
		else if string_count("SUBRIG", handle)
		{
			var index = real(string_delete(handle, 1, 6));
			ind = (index == rigSelSubDiv);
			col = make_color_hsv((index * 106) mod 255, 255, 255);
		}
		switch handle
		{
			//Tabs
			case "MODELEDITOR": ind = (global.editMode == eTab.Model); break;
			case "RIGGING": ind = (global.editMode == eTab.Rigging); break;
			case "SKINNING": ind = (global.editMode == eTab.Skinning); break;
			case "ANIMATION": ind = (global.editMode == eTab.Animation); break;
		
			//Settings
			case "TOGGLESKELETON": ind = drawSkeleton; break;
			case "TOGGLENODES": ind = drawNodeIndices; break;
			case "TOGGLENDOEPERSPECTIVE": ind = enableNodePerspective; break;
			case "TOGGLEWIREFRAME": ind = drawWireframe; break;
			case "TOGGLETEXTURE": ind = drawTexture; break;
			case "TOGGLELIGHT": ind = lightFollowCam; break;
			case "TOGGLECULLING": ind = culling; break;
			case "TOGGLEDRAWGRID": ind = drawGrid; break;
			case "TOGGLEAUTOSAVE": ind = edtAutosaveEnabled; break;
			case "TOGGLEUNDO": ind = editorUndoEnabled; break;
			case "TOGGLESNAP": ind = snapToGrid; break;
			case "TOGGLEDTEXREPEAT": ind = enableTexRepeat; break;
			case "TOGGLEDTEXFILTER": ind = enableTexFilter; break;
			case "INCLUDETEX": ind = IncludeTex; break;
			case "TOGGLEVERTVISIBLE": ind = edtSkinVertVisible; break;
			case "TOGGLESHADER": ind = enableShader; break;
		
			//Model editing
			case "TEXFORCEPOWTWO": ind = TexForcePowerOfTwo; break;
		
			//Rigging
			case "TOGGLEPRIMARYAXIS": ind = edtRigShowPrimaryAxis; break;
		
			//Skinning
			case "SKINAUTONORMALIZE": ind = edtSkinAutoNormalize; break;
		
			//Animation
			case "TRANSFORMCHILDREN": ind = edtAnimTransformChildren; break;
			case "MOVEFROMCURRENT": ind = edtAnimMoveFromCurrent; break;
			case "ANIMLOOP": if (animation < 0){break;} ind = animation.loop; break;
			case "ANIMNOINTERPOLATION": if (animation < 0){break;} ind = (animation.interpolation == eAnimInterpolation.Keyframe); break;
			case "ANIMLINEARINTERPOLATION": if (animation < 0){break;} ind = (animation.interpolation == eAnimInterpolation.Linear); break;
			case "ANIMQUADRATICNTERPOLATION": if (animation < 0){break;} ind = (animation.interpolation == eAnimInterpolation.Quadratic); break;
			case "ANIMATIONSPEED": if (animation < 0){break;} drawText += string(animation.playTime); break;
			case "ADDKEYFRAME": ind = (edtAnimKeyframeTool == KEYFRAMEADDBLANK); break;
			case "INSERTKEYFRAME": ind = (edtAnimKeyframeTool == KEYFRAMEINSERT); break;
			case "PASTEKEYFRAME": ind = (edtAnimKeyframeTool == KEYFRAMEPASTE); break;
			case "COPYKEYFRAME": ind = 0; break;
		}
		draw_sprite_ext(sprite_index, ind, x, y, 1, 1, 0, col, 1);
	
	
		if (string_count("SUBMODEL", handle))
		{
			texNum = array_length(texPack);
			if (texNum > 0)
			{
				var ind = real(string_delete(handle, 1, 8));
				var spr = texPack[ind mod texNum];
				if !sprite_exists(spr){continue;}
				draw_sprite_stretched(spr, 0, x + 2, y - 2, 20, 20);
				draw_set_color(c_dkgray);
				draw_rectangle(x + 2, y - 2, x + 22, y + 18, true);
				draw_set_color(c_white);
			}
		}
	
	
		switch handle
		{
			default: draw_text(x + 2, y + 2, drawText); break;
			case "SELECTTEXTURE":
				//Draw dropdown menu
				var str = "Select texture";
				/*if !is_undefined(subModel)
				{
					str = texName;
					if string_length(texName) > 16
					{
						str = string_copy(texName, 1, 16) + "...";
					}
				}*/
				draw_text(x + 3, y + 2, str);
				//Draw texture
				var s = 64;
				/*if !is_undefined(subModel)
				{
					var ind = ds_list_find_index(texList, texName) + 1;
					if ind > 0
					{
						var spr = texList[| ind];
						draw_sprite_stretched(spr, 0, x, y + 16, s, s);
						draw_set_color(c_black);
						draw_text(x + 5, y + 65, "W: " + string(sprite_get_width(spr)) + "\nH: " + string(sprite_get_height(spr)));
						draw_text(x + 3, y + 65, "W: " + string(sprite_get_width(spr)) + "\nH: " + string(sprite_get_height(spr)));
						draw_text(x + 5, y + 67, "W: " + string(sprite_get_width(spr)) + "\nH: " + string(sprite_get_height(spr)));
						draw_text(x + 3, y + 67, "W: " + string(sprite_get_width(spr)) + "\nH: " + string(sprite_get_height(spr)));
						draw_set_color(c_white);
						draw_text(x + 4, y + 66, "W: " + string(sprite_get_width(spr)) + "\nH: " + string(sprite_get_height(spr)));
					}
				}*/
				draw_set_color(c_black);
				draw_rectangle(x, y + 16, x + s, y + 16+s, true);
				break;
			
			
			case "RIGOPACITY":
				actualValue = "Rig opacity";
				sliderValue = (edtRigOpacity - .2) / (1 - .2);
				break;
			case "RIGSCALE":
				actualValue = "Rig thickness";
				sliderValue = sqrt(edtRigScale);
				break;
			
			//Model editing
			case "TEXPAGEMAXSIZE":
				actualValue = "Max tex size: " + string(TexpageMaxSize);
				sliderValue = (log2(TexpageMaxSize) - 4) / 8;
				break;
			case "TEXPAGEEXTEND":
				actualValue = "Tex padding: " + string(TexpageExtendEdges);
				sliderValue = TexpageExtendEdges / 10;
				break;
			
			//Skinning
			case "AUTOSKINPOWER":
				actualValue = "Power: " + string(edtSkinPower);
				sliderValue = (edtSkinPower - 1) / 9;
				break;
			case "NORMALWEIGHTING":
				actualValue = "Normal weight: " + string(edtSkinNormalWeighting);
				sliderValue = edtSkinNormalWeighting;
				break;
			case "PAINTRADIUS":
				actualValue = "Paint radius: " + string(edtSkinPaintBrushSize);
				sliderValue = edtSkinPaintBrushSize / 20;
				break;
			case "PAINTWEIGHT":
				actualValue = "Paint weight: " + string(edtSkinPaintWeight);
				sliderValue = edtSkinPaintWeight;
				break;
			case "PAINTSIZE":
				actualValue = "Vert scale: " + string(edtSkinPaintVertScale);
				sliderValue = sqrt(edtSkinPaintVertScale) / 2;
				break;
			
			//Animation
			case "FRAMEMULTIPLIER":
				if (animation < 0){break;}
				var multiplier = anim_get_sample_frame_multiplier(animation);
				actualValue = "Multiplier: " + string(multiplier);
				sliderValue = (multiplier - 1) / 19;
				break;
		}
		draw_set_halign(fa_left);
		draw_set_color(c_white);
	
		if sprite_index = sSlider
		{
			draw_sprite(sSliderPoint, 0, x + 5 + sliderValue * (127 - 10), y + 8);
			draw_set_halign(fa_middle)
			draw_set_color(c_black)
			draw_text(x + 63, y + 1, actualValue);
			draw_text(x + 65, y + 1, actualValue);
			draw_text(x + 63, y + 3, actualValue);
			draw_text(x + 65, y + 3, actualValue);
			draw_set_color(c_white)
			draw_text(x + 64, y + 2, actualValue);
			draw_set_halign(fa_left)
		}
	}


}
