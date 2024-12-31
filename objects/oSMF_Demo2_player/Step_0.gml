/// @description
/////////////////////////////////////////////////////////
//-------------------Delta time------------------------//
/////////////////////////////////////////////////////////
//Simulate 60 fps even though the framerate is unlimited
var timeStep = delta_time * 60 / 1000000;

/////////////////////////////////////////////////////////
//-------------------Move camera-----------------------//
/////////////////////////////////////////////////////////
camUpdateTimer += timeStep;
if (camUpdateTimer >= 1 || fps < 70) //Only update the mouse movement every 1/60th second
{
	var mousedx = window_mouse_get_x() - window_get_width() / 2;
	var mousedy = window_mouse_get_y() - window_get_height() / 2;
	window_mouse_set(window_get_width() / 2, window_get_height() / 2);
	camUpdateTimer = 0;
	camYaw += mousedx * .1;
	camPitch = clamp(camPitch - mousedy * .1, -80, -2);
}
var c = dcos(camYaw);
var s = dsin(camYaw);
var d = 64;
var camX = x - d * c * dcos(camPitch);
var camY = y - d * s * dcos(camPitch);
var camZ = z - d * dsin(camPitch);
camera_set_view_mat(view_camera[0], matrix_build_lookat(camX, camY, camZ, x, y, z + 16, 0, 0, 1));

/////////////////////////////////////////////////////////
//-------------Register input and move-----------------//
/////////////////////////////////////////////////////////
var hInput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var vInput = keyboard_check(ord("W")) - keyboard_check(ord("S"));
var run = keyboard_check(vk_shift) * (state != playerState.Jump);

var c = dcos(-walkDir);
var s = dsin(-walkDir);
var spd = (0.8 + 0.5 * run) * timeStep;
if (hInput != 0 && vInput != 0)
{
	spd *= 0.7071; //If we're moving diagonally, divide acceleration by the square root of two
}
hspeed = spd * (c * vInput - s * hInput);
vspeed = spd * (s * vInput + c * hInput);

//Hacked together delta-time stable jump, not viable for an actual game!!
var jumpHeight = 17;
var jumpLength = 70;
var dt = (current_time - jumpTime) / jumpLength - sqrt(jumpHeight);
z = max(0, jumpHeight - dt * dt);

/////////////////////////////////////////////////////////
//------------------Switch states----------------------//
/////////////////////////////////////////////////////////
if (hInput != 0 || vInput != 0)
{
	var diff = angle_difference(walkDir, -camYaw);
	walkDir -= diff * .1 * timeStep;
	var diff = angle_difference(faceDir, direction);
	faceDir -= diff * .1 * timeStep;
	if (run)
	{
		state = playerState.Run;
	}
	else
	{
		state = playerState.Walk;
	}
}
else
{
	state = playerState.Idle;
}

/////////////////////////////////////////////////////////
//--------------------Animation------------------------//
/////////////////////////////////////////////////////////
switch state
{
	case playerState.Idle:
		var animSpd = .01;
		var lerpSpd = .05;
		smf_instance_play_animation(mainInst, "Idle", animSpd, lerpSpd, false);
		break;
	case playerState.Walk:
		var animSpd = .023;
		var lerpSpd = .05;
		smf_instance_play_animation(mainInst, "Walk", animSpd, lerpSpd, false);
		break;
	case playerState.Run:
		var animSpd = .025;
		var lerpSpd = .05;
		smf_instance_play_animation(mainInst, "Run", animSpd, lerpSpd, false);
		break;
}

/////////////////////////////////////////////////////////
//----------Enable or disable fast sampling------------//
/////////////////////////////////////////////////////////
if global.enableInterpolation
{
	smf_instance_enable_fast_sampling(mainInst, false);
}
else
{
	smf_instance_enable_fast_sampling(mainInst, true);
}

/////////////////////////////////////////////////////////
//-----------------Update instance---------------------//
/////////////////////////////////////////////////////////
smf_instance_step(mainInst, timeStep);