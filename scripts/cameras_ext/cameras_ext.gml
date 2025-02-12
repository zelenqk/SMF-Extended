globalvar cameras;
cameras = 0;

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_alphatestenable(true);
gpu_set_tex_repeat(true);
gpu_set_tex_mip_enable(true);
draw_clear_alpha(c_black, 0);
gpu_set_cullmode(cull_counterclockwise);

// Initialize the camera with a third-person distance
function camera_init(resW, resH, distance = 0, fov = 60, view = true, surface = true) {
	var camera = noone;
	
	if (view){
		view_enabled = true;
		view_visible[cameras] = true;
		if (surface){
			surface = create_surface(display_get_gui_width(), display_get_gui_height());
			view_set_surface_id(cameras, surface);
		}
		
		view_camera[cameras] = camera_create();
		
		camera = {
			"camera": view_camera[cameras],
			"surface": surface,
			"pitch": 0,
			"fov": fov,
			"direction": 0,
			"distance": distance, // Third-person camera distance
			"tdistance": distance, // Third-person camera target distance (if a collision is found it will adjust)
			"w": resW,
			"h": resH,
			"active": true,
			"forward": {
				"x": 0,
				"y": 0,
				"z": 0,
			}
		}
		
		cameras++;
	}else{
		
		surface = (surface) ? create_surface(resW, resH) : noone;
		
		camera = {
			"camera": camera_create(),
			"pitch": 0,
			"surface": surface,
			"direction": 0,
			"distance": 0,
			"fov": fov,
			"tdistance": 0,
			"w": resW,
			"h": resH,
			"active": true,
			"forward": {
				"x": 0,
				"y": 0,
				"z": 0,
			}
		}
		
	}
	
	camera_set_proj_mat(camera.camera, matrix_build_projection_perspective_fov(camera.fov, - resW / resH, 1, 3200));
	return camera;
}

// Variables to store last known mouse position
global.lockx = display_get_gui_width() / 2;
global.locky = display_get_gui_height() / 2;

function camera_control(camera, targetX = x, targetY = y, targetZ = z){
	if (!camera.active) return;
	
	camera.direction = (camera.direction % 360) + 360 * (camera.direction < 0);
	camera.pitch = clamp(camera.pitch, -90, 90);
	camera.fov = clamp(camera.fov, 1, camera.fov);

	// Calculate forward vector
	camera.forward.x = dcos(camera.direction);
	camera.forward.y = dsin(camera.direction);
	camera.forward.z = dsin(camera.pitch);
	
	// Calculate camera position based on distance and direction
	if (camera.tdistance <= 0){
		var camX = targetX - camera.forward.x * dcos(camera.pitch);
		var camY = targetY - camera.forward.y * dcos(camera.pitch);
		var camZ = targetZ + camera.forward.z;
	}else{
		var camX = targetX - camera.forward.x * camera.tdistance * dcos(-camera.pitch);
		var camY = targetY - camera.forward.y * camera.tdistance * dcos(-camera.pitch);
		var camZ = targetZ - camera.forward.z * camera.tdistance;
	}
	// Calculate up vector for the camera
	var salting = camera.distance == 0 ? (camera.pitch <= -90) - (camera.pitch >= 90) : (camera.pitch >= 90) - (camera.pitch <= -90);
	var upX = dcos(camera.direction) * salting;
	var upY = dsin(camera.direction) * salting;
	var upZ = -1;
	
	// Set the camera's view matrix	
	camera_set_view_mat(camera.camera, matrix_build_lookat(camX, camY, camZ, targetX, targetY, targetZ, upX, upY, upZ));
}
