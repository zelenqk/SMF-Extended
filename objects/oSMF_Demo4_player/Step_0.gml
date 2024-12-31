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
var d = 45;
camX = x - d * c * dcos(camPitch) + random(screenShake);
camY = y - d * s * dcos(camPitch) + random(screenShake);
camZ = z - d * dsin(camPitch) + random(screenShake);
screenShake = max(screenShake - .2 * timeStep, 0);
camera_set_view_mat(view_camera[0], matrix_build_lookat(camX, camY, camZ, x, y, z + 16, 0, 0, 1));

/////////////////////////////////////////////////////////
//-------------Register input and move-----------------//
/////////////////////////////////////////////////////////
var hInput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var vInput = keyboard_check(ord("W")) - keyboard_check(ord("S"));
var run = keyboard_check(vk_shift) * (state != playerState.Jump);
var c = dcos(-walkDir);
var s = dsin(-walkDir);
var spd = (.8 + .5 * run) * timeStep;
if (hInput != 0 && vInput != 0)
{
	spd *= .7071; //If we're moving diagonally, divide acceleration by the square root of two
}
hspeed = spd * (c * vInput - s * hInput);
vspeed = spd * (s * vInput + c * hInput);
		
//Smoothly change the facing direction towards the moving directon
if (hInput != 0 || vInput != 0)
{
	var diff = angle_difference(faceDir, direction);
	faceDir -= diff * .1 * timeStep;
}

/////////////////////////////////////////////////////////
//------------If the character is rolling--------------//
/////////////////////////////////////////////////////////
if (state == playerState.Roll)
{
	hit = (mouse_check_button_pressed(mb_left) || hit); //If MB1 is hit, save the input for when we're done rolling to attack
	roll = (keyboard_check_pressed(vk_space) || roll); //If space is hit, save the input for when we're done rolling to roll again
	var time = mainInst.timer;
	
	//Move forward during the animation. This equation will make him move faster in the middle of the animation
	speed = 2 * (1 - sqr(2 * time - 1)) * timeStep;
	direction = faceDir;
	
	//If we've pressed the "hit" button, cancel the animation early and start the attack animation
	if (time >= .75 && currWeapon >= 0 && hit)
	{
		state = playerState.Attack;
		hit = false;
		var animSpd = .02;
		var lerpSpd = .12;
		mainInst.play("Hit", animSpd, lerpSpd, true);
		mainInst.newTimer = .3; //This is a simple trick to make the attack animation start 30% into the animation, allowing for a faster attack after rolling
	}
	
	//If the animation is done playing, go back to an idle state
	if (time >= 1)
	{
		state = playerState.Idle;
	}
}

/////////////////////////////////////////////////////////
//-----------If the character is attacking-------------//
/////////////////////////////////////////////////////////
if (state == playerState.Attack)
{
	hit = (mouse_check_button_pressed(mb_left) || hit); //If MB1 is hit, save the input for when we're done rolling to attack
	roll = (keyboard_check_pressed(vk_space) || roll); //If space is hit, save the input for when we're done rolling to roll again
	speed = 0;
	var time = mainInst.timer;
	
	//Make the screen shake when the weapon hits the ground
	if (time > .6 && time < .7)
	{
		screenShake = 2;
	}
	
	//If the animation is almost done playing, go back to an idle state
	if (time >= 0.9)
	{
		state = playerState.Idle;
	}
}

/////////////////////////////////////////////////////////////////////
//-------If the character is neither attacking nor rolling---------//
/////////////////////////////////////////////////////////////////////
if (state != playerState.Attack && state != playerState.Roll)
{
	//If the character has a weapon in his hand, and the attack button has been pressed
	if (currWeapon >= 0 && hit)
	{
		state = playerState.Attack;
		hit = false;
		var animSpd = .02;
		var lerpSpd = .12;
		mainInst.play("Hit", animSpd, lerpSpd, true);
	}
	
	//If the roll button has been pressed
	else if (roll)
	{
		state = playerState.Roll;
		roll = false;
		var animSpd = .022;
		var lerpSpd = .12;
		mainInst.play("Roll", animSpd, lerpSpd, true);
	}
}

///////////////////////////////////////////////////////////////////////////
//-------If the character is still neither attacking nor rolling---------//
///////////////////////////////////////////////////////////////////////////
if (state != playerState.Attack && state != playerState.Roll)
{
	//Update the hit and attack inputs here, to allow for "caching" of these inputs while performing one or the other
	hit = mouse_check_button_pressed(mb_left);
	roll = keyboard_check_pressed(vk_space);
	
	//If a walk button has been pressed
	if (hInput != 0 || vInput != 0)
	{
		//Smoothly change the walking direction towards the camera's looking direction
		var diff = angle_difference(walkDir, -camYaw);
		walkDir -= diff * .1 * timeStep;
		
		if (run)
		{	
			//If a run input has been pressed, play the running animation
			state = playerState.Run;
			var animSpd = .032;
			var lerpSpd = .12;
			mainInst.play("Run", animSpd, lerpSpd, false);
		}
		else
		{
			//Otherwise play the walking animation
			state = playerState.Walk;
			var animSpd = .023;
			var lerpSpd = .12;
			mainInst.play("Walk", animSpd, lerpSpd, false);
		}
	}
	else
	{
		//No input has been pressed, play the idle animation
		state = playerState.Idle;
		var animSpd = .01;
		var lerpSpd = .12;
		mainInst.play("Idle", animSpd, lerpSpd, false);
	}
}

/////////////////////////////////////////////////////////
//-----------------Update instance---------------------//
/////////////////////////////////////////////////////////
mainInst.step(timeStep);

/////////////////////////////////////////////////////////////////////
//----------Turn the head towards the camera direction-------------//
/////////////////////////////////////////////////////////////////////
if (state != playerState.Roll)
{
	//Only turn the head if the angle difference is less than 95 degrees
	diff = angle_difference(headDir, - camYaw);
}
else
{
	//Turn towards the facing direction if rolling or if the camera angle is too far away
	diff = angle_difference(headDir, faceDir);
}
headDir -= diff * 0.2 * timeStep;
var rotate = 30 * dsin(angle_difference(faceDir, headDir));

/*
	Head turning is performed by rotating the torso and the head bones around the z-axis.
	This also requires transforming all descending bones. Ie. when rotating the torso, we
	also need to rotate shoulders, elbows, hands, fingers, head and hair bones. The script
	does this automatically, but the more bones are rotated in real time, the slower it gets.
*/
mainInst.node_rotate_z(1, rotate); //Rotate the torso bone half the angle
mainInst.node_rotate_z(2, rotate); //And rotate the head bone half the angle