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
if (camUpdateTimer >= 1) //Only update the camera every 1/60th second
{
	camUpdateTimer = 0;
	var mousedx = window_mouse_get_x() - window_get_width() / 2;
	var mousedy = window_mouse_get_y() - window_get_height() / 2;
	window_mouse_set(window_get_width() / 2, window_get_height() / 2);
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
var run = keyboard_check(vk_shift);

headDir -= clamp(angle_difference(headDir, - camYaw) * 0.1, -2, 2) * timeStep;
var c = dcos(-headDir);
var s = dsin(-headDir);
var spd = (.5 + .5 * run) * timeStep; //Run faster if the run button is held down
if (hInput != 0 && vInput != 0)
{
	spd *= 0.7071; //If we're moving diagonally, divide acceleration by the square root of two
}
hspeed = spd * (c * vInput - s * hInput);
vspeed = spd * (s * vInput + c * hInput);

/////////////////////////////////////////////////////////
//------------------Update sample----------------------//
/////////////////////////////////////////////////////////
//Set animation speed based on how fast the spider is moving
mainInst.animSpeed = timeStep * 0.01 + .02 * abs(speed);

//Update the sample
mainInst.step(1);

/////////////////////////////////////////////////////////
//-----------------Moving the legs---------------------//
/////////////////////////////////////////////////////////
//Create spider's world matrix
matrix = matrix_build(x, y, z, 0, 0, headDir, scale, scale, scale);

//Update the inverse world matrix. Together, these matrices let you transform between rig-space and world-space.
//This is important, since we want to move the leg to a world-space position, but the inverse kinematics is performed in rig-space.
smf_mat_invert_fast(matrix, invMat);

//Loop through the legs
for (var i = 0; i < footNum; i ++)
{
	var T = footTarget[i]; //The target position in rig-space
	var C = footCurrent[i]; //The current position in world-space
	var T_world = matrix_transform_vertex(matrix, T[0], T[1], T[2]); //The target position transformed to world-space
	if (!feetMoving)
	{	//This foot is not currently moving
		//If this foot is far enough away from its target, and there are no feet already moving
		if (point_distance(T_world[0], T_world[1], C[0], C[1]) > footMaxDist)
		{
			for (var j = (i mod 2); j < footNum; j += 2)
			{
				//Make every second foot move, creating a "spidery" movement
				footMove[j] = footMoveSpeed;
				feetMoving ++; //Increase the number of feet currently moving
			}
		}
	}
	if (footMove[i] > 0)
	{	//This foot is currently moving!! Figure out the distance between the target position and the previous target position:
		var P = footPrev[i];
		var dx = (T_world[0] - P[0]);
		var dy = (T_world[1] - P[1]);
		var d = sqrt(dx * dx + dy * dy);
		
		//Make the foot "overshoot" the target position
		var t = footMaxDist * .5 / d;
		T_world[0] += dx * t;
		T_world[1] += dy * t;
		
		//Smoothen the movement parameter with smoothstep
		var a = smf_smoothstep(0, 1, footMove[i]);
		
		//Linearly interpolate between the previous and the current target positions
		C[@ 0] = lerp(P[0], T_world[0], a);
		C[@ 1] = lerp(P[1], T_world[1], a);
		
		//Make the foot move in an arc
		C[@ 2] = (1 - sqr(a * 2 - 1)) * 6;
		
		//Increase the movement parameter. If the foot is done moving, stop moving
		footMove[i] += footMoveSpeed * (1 + .5 * run + .5 * abs(hInput)) * timeStep;
		if (footMove[i] >= 1)
		{
			footMove[i] = 0;
			array_copy(P, 0, C, 0, 3); //Save the current world-space position as the previous position
			feetMoving --; //Decrease the number of feet currently moving
		}
	}
	
	//Transform world leg position back into rig-space
	var C_local = matrix_transform_vertex(invMat, C[0], C[1], C[2]);
	
	//Move the node using inverse kinematics
	mainInst.node_move_ik_fast(3 + i * 2, C_local[0], C_local[1], C_local[2], false, false);
}