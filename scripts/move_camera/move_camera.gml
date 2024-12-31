function move_camera() {
	//Zoom
	camZoom *= 1 + (mouse_wheel_down() - mouse_wheel_up()) / 10;

	mouseWorldPrevPos = mouseWorldPos; mouseWorldPrevPos[0] += 0;
	if mouse_check_button(mb_middle) || mouse_check_button(mb_right) || keyboard_check(vk_space)
	{
		if mouseViewInd == 1
		{
			//Rotate camera when middle mousebutton is pressed over the perspective view
			camPos[camTransform[1, 0]] += mouseDx / 2;
			camPos[camTransform[1, 1]] += mouseDy / 2;
		}
		else
		{
			//Move the camera when mouse is over an orthographic view
			if mouseViewInd == 3{camPos[camTransform[mouseViewInd, 0]] += mouseDx * camZoom;}
			else{camPos[camTransform[mouseViewInd, 0]] -= mouseDx * camZoom;}
			if mouseViewInd == 2{camPos[camTransform[mouseViewInd, 1]] -= mouseDy * camZoom;}
			else{camPos[camTransform[mouseViewInd, 1]] += mouseDy * camZoom;}
		}
	}
	//Move the camera with the arrow keys, in case the computer doesn't have a middle mouse button
	if mouseViewInd == 1
	{
		camPos[camTransform[1, 0]] -= 5 * (keyboard_check(vk_right) - keyboard_check(vk_left));
		camPos[camTransform[1, 1]] -= 5 * (keyboard_check(vk_down) - keyboard_check(vk_up));
	}
	else if mouseViewInd > 1 and mouseViewInd <= 4
	{
		var h, v;
		h = 10 * (keyboard_check(vk_right) - keyboard_check(vk_left));
		v = 10 * (keyboard_check(vk_down) - keyboard_check(vk_up));
		if mouseViewInd == 3{camPos[camTransform[mouseViewInd, 0]] += h * camZoom;}
		else{camPos[camTransform[mouseViewInd, 0]] -= h * camZoom;}
		if mouseViewInd == 2{camPos[camTransform[mouseViewInd, 1]] -= v * camZoom;}
		else{camPos[camTransform[mouseViewInd, 1]] += v * camZoom;}
	}

	//Update perspective view
	camPos[4] = median(camPos[4], -89, 89);
	dist = editHeight * camZoom / (2 * dtan(30));
	viewPos[1, 0] = camPos[0] + dist * dcos(camPos[3]) * dcos(camPos[4]);
	viewPos[1, 1] = camPos[1] + dist * dsin(camPos[3]) * dcos(camPos[4]);
	viewPos[1, 2] = camPos[2] + dist * dsin(camPos[4]);
	camera_set_view_mat(view_camera[1], matrix_build_lookat(viewPos[1, 0], viewPos[1, 1], viewPos[1, 2], camPos[0], camPos[1], camPos[2], 0, 0, 1));
	camera_set_proj_mat(view_camera[1], matrix_build_projection_perspective_fov(-60, -editWidth / editHeight, camZoom, 32000 * camZoom));

	//Update orthographic views
	for (var i = 2; i <= 4; i ++)
	{
		viewPos[i, 0] = 8000 * camZoom;
		viewPos[i, 1] = 8000 * camZoom;
		viewPos[i, 2] = 8000 * camZoom;
		viewPos[i, camTransform[i, 0]] = camPos[camTransform[i, 0]];
		viewPos[i, camTransform[i, 1]] = camPos[camTransform[i, 1]];
		projMat = matrix_build_projection_ortho(editWidth * camZoom, -editHeight * camZoom, camZoom, 32000 * camZoom);
		viewMat = matrix_build_lookat(viewPos[i, 0], viewPos[i, 1], viewPos[i, 2], camPos[0], camPos[1], camPos[2], 0, -(i == 2), i != 2)
		camera_set_view_mat(view_camera[i], viewMat);
		camera_set_proj_mat(view_camera[i], projMat);
	}

	//Update mouse position and mouse vector
	if mouseViewInd >= 1 and mouseViewInd <= 4
	{	
		if mouseViewInd == 1
		{
			mouseWorldPos[0] = viewPos[1, 0];
			mouseWorldPos[1] = viewPos[1, 1];
			mouseWorldPos[2] = viewPos[1, 2];
			to =smf_vector_normalize([camPos[0] - viewPos[mouseViewInd, 0], camPos[1] - viewPos[mouseViewInd, 1], camPos[2] - viewPos[mouseViewInd, 2]]);
			si =smf_vector_normalize(smf_vector_orthogonalize(to, [0, 0, 1]));
		
			var mx = (mouseX mod editWidth) / editWidth;
			var my = (mouseY mod editHeight) / editHeight;
		
			mouseWorldVec = smf_cam_convert_2d_to_3d(view_camera[1], mx * window_get_width(), my * window_get_height());
		}
		else
		{
			var mx, my, tx, ty;
			mx = (mouseX mod editWidth) - editWidth / 2;
			my = (mouseY mod editHeight) - editHeight / 2;

			tx = camTransform[mouseViewInd, 0];
			ty = camTransform[mouseViewInd, 1];
			if mouseViewInd == 3{mx *= -1;my *= -1;}
			if mouseViewInd == 4{my *= -1;}
			mouseWorldPos[0] = viewPos[mouseViewInd, 0];
			mouseWorldPos[1] = viewPos[mouseViewInd, 1];
			mouseWorldPos[2] = viewPos[mouseViewInd, 2];
			mouseWorldPos[tx] += mx * camZoom;
			mouseWorldPos[ty] += my * camZoom;
		
			mouseWorldVec[0] = -1;
			mouseWorldVec[1] = -1;
			mouseWorldVec[2] = -1;
			mouseWorldVec[tx] = 0;
			mouseWorldVec[ty] = 0;
		}
	}


}
