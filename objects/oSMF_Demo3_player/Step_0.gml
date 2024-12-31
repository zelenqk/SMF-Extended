/// @description
var timeStep = delta_time * 60 / 1000000;

//Register input
var hInput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var vInput = keyboard_check(ord("W")) - keyboard_check(ord("S"));
var run = keyboard_check(vk_shift) * (state != playerState.Jump);
var jump = keyboard_check(vk_space);

//Move camera
camUpdateTimer += delta_time;
if (camUpdateTimer >= 1000000 / 60) //Only update the mouse movement every 1/60th second
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
camX = x - d * c * dcos(camPitch);
camY = y - d * s * dcos(camPitch);
camZ = z - d * dsin(camPitch);
camera_set_view_mat(view_camera[0], matrix_build_lookat(camX, camY, camZ, x, y, z + 16, 0, 0, 1));


//Player control
var c = dcos(-walkDir);
var s = dsin(-walkDir);
var spd = (0.8 + 0.8 * run) * timeStep;
if (hInput != 0 && vInput != 0)
{
	spd *= 0.7071; //If we're moving diagonally, divide acceleration by the square root of two
}
hspeed = spd * (c * vInput - s * hInput);
vspeed = spd * (s * vInput + c * hInput);

//Simple delta-time stable jump, not viable for an actual game
var jumpHeight = 17;
var jumpLength = 70;
var dt = (current_time - jumpTime) / jumpLength - sqrt(jumpHeight);
z = max(0, jumpHeight - dt * dt);

//Animation
if (jump)
{
	if (jumpStep == 0)
	{
		state = playerState.Jump;
		jumpStep = 1;
		smf_instance_set_timer(mainInst, 0);
	}
}
if (jumpStep > 0 && state == playerState.Jump)
{
	if (jumpStep == 4 && smf_instance_get_timer(mainInst) >= 1)
	{
		jumpStep = 0;
		state = playerState.Idle;
	}
	if (jumpStep == 3 && z <= 0)
	{
		jumpStep = 4;
		smf_instance_set_timer(mainInst, 0);
	}
	if (jumpStep == 2 && smf_instance_get_timer(mainInst) >= 1)
	{
		jumpStep = 3;
	}
	if (jumpStep == 1 && smf_instance_get_timer(mainInst) >= .5)
	{
		jumpTime = current_time;
		jumpStep = 2;
	}
}
else if (hInput != 0 || vInput != 0)
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
	case playerState.Jump:
		if (jumpStep == 1 || jumpStep == 2)
		{
			var animSpd = .04;
			var lerpSpd = .2;
			smf_instance_play_animation(mainInst, "Jump", animSpd, lerpSpd, false);
		}
		if (jumpStep == 3)
		{
			var animSpd = .03;
			var lerpSpd = .1;
			smf_instance_play_animation(mainInst, "Airborne", animSpd, lerpSpd, false);
		}
		if (jumpStep == 4)
		{
			var animSpd = .06;
			var lerpSpd = .2;
			smf_instance_play_animation(mainInst, "Land", animSpd, lerpSpd, false);
		}
		break;
}

//Update the sample
smf_instance_step(mainInst, timeStep);

/*
	Head turning is performed by rotating the torso and the head bones around the z-axis.
	This also requires transforming all descending bones. Ie. when rotating the torso, we
	also need to rotate shoulders, elbows, hands, fingers, head and hair bones. The script
	does this automatically, but the more bones are rotated in real time, the slower it gets.
*/
//Head turning is done by rolling bone 1 (the torso) and bone 2 (the head).
if (abs(angle_difference(-camYaw, faceDir)) < 120)
{
	diff = angle_difference(headDir, - camYaw);
}
else
{
	diff = angle_difference(headDir, faceDir);
}
headDir -= diff * 0.2 * timeStep;
var diff = angle_difference(headDir, faceDir);
mainInst.node_roll(1, - diff * .6); //Rotate torso
mainInst.node_roll(2, - diff * .4); //Rotate head