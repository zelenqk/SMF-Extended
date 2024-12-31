/// @description

////////////////////////////////////////////////////
//----------------Set world matrix----------------//
////////////////////////////////////////////////////
var M = matrix_build(x, y, z, 0, 0, faceDir, 2, 2, 2);
matrix_set(matrix_world, M);

////////////////////////////////////////////////////
//---------------------Shadows--------------------//
////////////////////////////////////////////////////
//Turn off z-testing when drawing shadows
gpu_set_ztestenable(false);

//Shadow under left foot
var pos = mainInst.node_get_position(24); 
draw_sprite_ext(sShadow, 0, pos[0], pos[1], .06, .06, 0, c_white, .4);

//Shadow under right foot
var pos = mainInst.node_get_position(28);
draw_sprite_ext(sShadow, 0, pos[0], pos[1], .06, .06, 0, c_white, .4);

//Draw larger shadow under the whole body
draw_sprite_ext(sShadow, 0, 0, 0, .16, .16, 0, c_white, .4);
gpu_set_ztestenable(true);

////////////////////////////////////////////////////
//------------------Draw instance-----------------//
////////////////////////////////////////////////////
gpu_set_cullmode(cull_counterclockwise);
shader_set(sh_smf_animate);
mainInst.draw();

////////////////////////////////////////////////////
//-----------------Draw weapon--------------------//
////////////////////////////////////////////////////
if (currWeapon >= 0)
{
	shader_set(sh_smf_static);
	
	//Combine the weapon's matrix with the world matrix
	var weaponM = mainInst.node_get_matrix(17); //Get the orientation of the hand node
	matrix_set(matrix_world, matrix_multiply(weaponM, M));
	
	if (currWeapon == 0)
	{
		//Draw axe
		global.modAxe.submit();
	}
	else if (currWeapon == 1)
	{
		//Draw hammer
		global.modHammer.submit();
	}
}

////////////////////////////////////////////////////
//-----------------Reset settings-----------------//
////////////////////////////////////////////////////
matrix_set(matrix_world, matrix_build_identity());
shader_reset();