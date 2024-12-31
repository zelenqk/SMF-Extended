/// @description

/////////////////////////////////////////////////////////
//----------------Player variables---------------------//
/////////////////////////////////////////////////////////
z = 0;
headDir = 0;

/////////////////////////////////////////////////////////
//-----------------Camera settings---------------------//
/////////////////////////////////////////////////////////
camYaw = 0;
camPitch = -45;
camUpdateTimer = 0;

view_enabled = true;
view_visible[0] = true;
view_set_camera(0, camera_create());
camera_set_proj_mat(view_camera[0], matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000));
window_mouse_set(window_get_width() / 2, window_get_height() / 2);

/////////////////////////////////////////////////////////
//------------Create animation instance----------------//
/////////////////////////////////////////////////////////
mainInst = new smf_instance(global.modSpider);
mainInst.play("anim0", .01, 1, true);
mainInst.step(0);

/////////////////////////////////////////////////////////
//---------Create matrix and inverse matrix------------//
/////////////////////////////////////////////////////////
scale = 6;
matrix = matrix_build(x, y, z, 0, 0, headDir, scale, scale, scale);
invMat = smf_mat_invert(matrix, array_create(16));

/////////////////////////////////////////////////////////
//-----------------Initialize feet---------------------//
/////////////////////////////////////////////////////////
footNum = 8; //The number of feet. This needs to correspond with the SMF model, and shouldn't be changed!
feetMoving = 0; //The number of feet currently moving. This prevents all fet from moving at the same time
footMaxDist = 6; //The threshhold for when a leg will move towards the target position
footMoveSpeed = 0.055; //The speed at which the leg will move (in distance per 1/60th second)
footCurrent = array_create(footNum); //Current foot position in world-space
footTarget = array_create(footNum); //Target foot position in rig-space
footPrev = array_create(footNum); //Previous foot position in world-space
footMove = array_create(footNum); //Movement parameter for this foot
for (var i = 0; i < footNum; i ++)
{
	//I've created the rig so that this simple equation will return the end node of each leg
	var nodeInd = 3 + i * 2;
	
	//Find rig-space position of the leg
	var pos = mainInst.node_get_position(nodeInd);
	
	//Find the target position in rig-space
	footTarget[i] = [pos[0], pos[1], pos[2]];
	
	//Find the current foot position in world-space. Multiply the y-component by 0.5 to make the spider move its legs from the moment the room starts
	footCurrent[i] = matrix_transform_vertex(matrix, pos[0], pos[1] * .5, pos[2]);
	
	//Find the previous foot position in world-space. This is initially the same as the current position.
	footPrev[i] = matrix_transform_vertex(matrix, pos[0], pos[1] * .5, pos[2]);
	
	//This foot is not moving.
	footMove[i] = 0;
}