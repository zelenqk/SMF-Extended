/// @description

//Create a simple 3D camera

view_enabled = true;
view_visible[0] = true;
view_set_camera(0, camera_create());
camera_set_proj_mat(view_camera[0], matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000));

//Set player position and previous coordinates
z = 0;
faceDir = 0;
wheelSpin = 0;
wheelAngle = 0;
chassisAngle = 0;
chassisAngleSpeed = 0;
chassisRoll = 0;

//Set mouse look variables
camYaw = 0;
camPitch = -45;
window_mouse_set(window_get_width() / 2, window_get_height() / 2);

//Load models
mainInst = new smf_instance(global.modCar);

camUpdateTimer = 0;

state = playerState.Idle;