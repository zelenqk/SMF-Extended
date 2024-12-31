// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/// @description smf_cam_convert_2d_to_3d(camera, x, y)
/// @param camera
/// @param x
/// @param y
function smf_cam_convert_2d_to_3d(camera, x, y) {
	/*
		Transforms a 2D coordinate (in window space) to a 3D vector.
		Returns an array of the following format:
		[dx, dy, dz, ox, oy, oz]
		where [dx, dy, dz] is the direction vector and [ox, oy, oz] is the origin of the ray.

		Works for both orthographic and perspective projections.

		Script created by TheSnidr
	*/
	var V = camera_get_view_mat(camera);
	var P = camera_get_proj_mat(camera);
	var mx = 2 * (x / window_get_width() - .5) / P[0];
	var my = 2 * (y / window_get_height() - .5) / P[5];
	var camX = - (V[12] * V[0] + V[13] * V[1] + V[14] * V[2]);
	var camY = - (V[12] * V[4] + V[13] * V[5] + V[14] * V[6]);
	var camZ = - (V[12] * V[8] + V[13] * V[9] + V[14] * V[10]);
	if (P[15] == 0) 
	{    //This is a perspective projection
	    return [V[2]  + mx * V[0] - my * V[1], 
	            V[6]  + mx * V[4] - my * V[5], 
	            V[10] + mx * V[8] - my * V[9], 
	            camX, 
	            camY, 
	            camZ];
	}
	else 
	{    //This is an ortho projection
	    return [V[2], 
	            V[6], 
	            V[10], 
	            camX + mx * V[0] - my * V[1], 
	            camY + mx * V[4] - my * V[5], 
	            camZ + mx * V[8] - my * V[9]];
	}
}

function smf_cam_convert_3d_to_2d(camera, x, y, z) {
	/*
		Transforms a 3D coordinate to a 2D window-space coordinate. Returns an array of the following format:
		[x, y]
		Script created by TheSnidr
		www.thesnidr.com
	*/
	var cx, cy;
	var V = camera_get_view_mat(camera);
	var P = camera_get_proj_mat(camera);
	if (P[15] == 0)
	{	//This is a perspective projection
		var w = V[2] * x + V[6] * y + V[10] * z + V[14];
		if w <= 0{return [-1, -1];}
		cx = P[8] + P[0] * (V[0] * x + V[4] * y + V[8] * z + V[12]) / w;
		cy = P[9] + P[5] * (V[1] * x + V[5] * y + V[9] * z + V[13]) / w;
	}
	else 
	{    //This is an ortho projection
		cx = P[12] + P[0] * (V[0] * x + V[4] * y + V[8]  * z + V[12]);
		cy = P[13] + P[5] * (V[1] * x + V[5] * y + V[9]  * z + V[13]);
	}
	return [(.5 + .5 * cx) * window_get_width(), (.5 - .5 * cy) * window_get_height()];
}


function smf_convert_3d_to_2d(x, y, z, V, P) {
	/*
		Transforms a 3D coordinate to a 2D window-space coordinate. Returns an array of the following format:
		[x, y]
		Script created by TheSnidr
		www.thesnidr.com
	*/
	var cx, cy;
	if (P[15] == 0)
	{	//This is a perspective projection
		var w = V[2] * x + V[6] * y + V[10] * z + V[14];
		if w <= 0{return [-1, -1];}
		cx = P[8] + P[0] * (V[0] * x + V[4] * y + V[8] * z + V[12]) / w;
		cy = P[9] + P[5] * (V[1] * x + V[5] * y + V[9] * z + V[13]) / w;
	}
	else 
	{    //This is an ortho projection
		cx = P[12] + P[0] * (V[0] * x + V[4] * y + V[8]  * z + V[12]);
		cy = P[13] + P[5] * (V[1] * x + V[5] * y + V[9]  * z + V[13]);
	}
	return [(.5 + .5 * cx) * window_get_width(), (.5 - .5 * cy) * window_get_height()];
}

function smf_convert_2d_to_3d(x, y, V, P) {
	/*
		Transforms a 2D coordinate (in window space) to a 3D vector.
		Returns an array of the following format:
		[dx, dy, dz, ox, oy, oz]
		where [dx, dy, dz] is the direction vector and [ox, oy, oz] is the origin of the ray.

		Works for both orthographic and perspective projections.

		Script created by TheSnidr
	*/
	var mx = 2 * (x / window_get_width() - .5) / P[0];
	var my = 2 * (y / window_get_height() - .5) / P[5];
	var camX = - (V[12] * V[0] + V[13] * V[1] + V[14] * V[2]);
	var camY = - (V[12] * V[4] + V[13] * V[5] + V[14] * V[6]);
	var camZ = - (V[12] * V[8] + V[13] * V[9] + V[14] * V[10]);
	if (P[15] == 0) 
	{    //This is a perspective projection
	    return [V[2]  + mx * V[0] - my * V[1], 
	            V[6]  + mx * V[4] - my * V[5], 
	            V[10] + mx * V[8] - my * V[9], 
	            camX, 
	            camY, 
	            camZ];
	}
	else 
	{    //This is an ortho projection
	    return [V[2], 
	            V[6], 
	            V[10], 
	            camX + mx * V[0] - my * V[1], 
	            camY + mx * V[4] - my * V[5], 
	            camZ + mx * V[8] - my * V[9]];
	}
}