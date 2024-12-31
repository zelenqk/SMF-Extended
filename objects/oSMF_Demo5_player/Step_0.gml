/// @description
/////////////////////////////////////////////////////////
//------------------Register input---------------------//
/////////////////////////////////////////////////////////
var hInput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var vInput = keyboard_check(ord("W")) - keyboard_check(ord("S"));
var jump = keyboard_check(vk_space);

/////////////////////////////////////////////////////////
//-------------------Move camera-----------------------//
/////////////////////////////////////////////////////////
var mousedx = window_mouse_get_x() - window_get_width() / 2;
var mousedy = window_mouse_get_y() - window_get_height() / 2;
window_mouse_set(window_get_width() / 2, window_get_height() / 2);
camYaw += mousedx * .1 + speed * hInput;
camPitch = clamp(camPitch - mousedy * .1, -80, -2);
var c = dcos(camYaw);
var s = dsin(camYaw);
var d = 64;
var camX = x - d * c * dcos(camPitch);
var camY = y - d * s * dcos(camPitch);
var camZ = z - d * dsin(camPitch);
camera_set_view_mat(view_camera[0], matrix_build_lookat(camX, camY, camZ, x, y, z + 16, 0, 0, 1));

/////////////////////////////////////////////////////////
//------------------------Move-------------------------//
/////////////////////////////////////////////////////////
var diff = clamp(angle_difference(-camYaw, direction), -40, 40);
direction += .03 * abs(speed) * diff;
var target = vInput * 2;
speed += (target - speed) * 0.1;

/////////////////////////////////////////////////////////
//-----------------Update instance---------------------//
/////////////////////////////////////////////////////////
smf_instance_step(mainInst, 1);

/////////////////////////////////////////////////////////
//------------------Rotate chassis---------------------//
/////////////////////////////////////////////////////////
chassisAngleSpeed *= 0.97 //"Friction"
chassisAngleSpeed += (-3 * speed - chassisAngle) * 0.015; //Smoothly change the chassis angle speed. Big changes will cause oscillation
chassisAngle += chassisAngleSpeed; //Add the chassis angle speed to the chassis angle
chassisRoll += (.13 * diff * speed - chassisRoll) * 0.1; //Make the chassis roll sideways
mainInst.node_rotate_y(1, chassisAngle);
mainInst.node_rotate_x(1, chassisRoll);

/////////////////////////////////////////////////////////
//--------------------Spin wheels----------------------//
/////////////////////////////////////////////////////////
wheelSpin += speed * 10;
mainInst.node_rotate_y(3, wheelSpin);
mainInst.node_rotate_y(5, wheelSpin);
mainInst.node_rotate_y(7, wheelSpin);
mainInst.node_rotate_y(9, wheelSpin);

/////////////////////////////////////////////////////////
//----------------Turn front wheels--------------------//
/////////////////////////////////////////////////////////
var diff = clamp(angle_difference(-camYaw, direction), -40, 40); //Find the angle difference between the camera direction and the current moving direction
var targetAngle = - diff * .8; //The target angle
if (speed < 0){targetAngle *= -1;} //If the car is backing up, I want the wheels to turn the other way
targetAngle += hInput * 25; //Make the horizontal input affect the wheel angle
targetAngle = clamp(targetAngle, -30, 30); //Limit the target angle to +-30 degrees
wheelAngle += (targetAngle - wheelAngle) * 0.1; //Smoothly rotate towards the target angle
mainInst.node_rotate_z(3, wheelAngle);
mainInst.node_rotate_z(5, wheelAngle);