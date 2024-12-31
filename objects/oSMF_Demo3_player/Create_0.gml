/// @description

//Create a 3D camera
view_enabled = true;
view_visible[0] = true;
view_set_camera(0, camera_create());
camera_set_proj_mat(view_camera[0], matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000));

//Set player position and previous coordinates
z = 0;
prevX = x;
prevY = y;
prevZ = z;
zspeed = 0;
faceDir = 0;
headDir = 0;
torsoAngle = 0;
walkDir = 0;
jumpStep = 0;
jumpTime = -100;

//Set mouse look variables
camYaw = 0;
camPitch = -45;
window_mouse_set(window_get_width() / 2, window_get_height() / 2);

//Load models
mainInst = smf_instance_create(global.modMan);
smf_instance_play_animation(mainInst, "Idle", .01, 1, true);

camUpdateTimer = 0;

state = playerState.Idle;