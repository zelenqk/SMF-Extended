/// @description

//Create a 3D camera
camUpdateTimer = 0;
view_enabled = true;
view_visible[0] = true;
view_set_camera(0, camera_create());
camera_set_proj_mat(view_camera[0], matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000));

//Set player position and previous coordinates
z = 0;
faceDir = 0;
headDir = 0;
walkDir = 0;
screenShake = 0;

//Input variables
roll = false;
hit = false;

//Set mouse look variables
camYaw = 0;
camPitch = -45;
window_mouse_set(window_get_width() / 2, window_get_height() / 2);

//Load models
mainInst = new smf_instance(global.modDwarf);
mainInst.play("Idle", .01, 1, true);

state = playerState.Idle;

//Init weapon
currWeapon = -1; //0 = axe, 1 = hammer