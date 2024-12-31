/// @description animeditor_draw_loop3(radius, thickness)
/// @param radius
/// @param thickness
function animeditor_draw_loops(argument0, argument1) {
	var radius = argument0;
	var thickness = argument1;

	var worldMatrix = matrix_get(matrix_world);
	gpu_set_cullmode(cull_counterclockwise);
			
	var shader = sh_anim_loop;
	shader_set(shader);
	shader_set_uniform_f(shader_get_uniform(shader, "u_radius"), radius);

	//Draw loop on xy-plane
	matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1), worldMatrix));
	shader_set_uniform_f(shader_get_uniform(shader, "u_thickness"), thickness);
	shader_set_uniform_f(shader_get_uniform(shader, "u_colour"), 1, 0, 0, lerp(0.75, 1, edtAnimMouseoverHandle == 0 || edtAnimSelectedHandle == 0));
	vertex_submit(edtAnimLoopModel, pr_trianglelist, -1);

	//Draw loop on yz-plane
	matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 90, 0, 0, 1, 1, 1), worldMatrix));
	shader_set_uniform_f(shader_get_uniform(shader, "u_thickness"), thickness);
	shader_set_uniform_f(shader_get_uniform(shader, "u_colour"), 0, 0, 1, lerp(0.75, 1, edtAnimMouseoverHandle == 1 || edtAnimSelectedHandle == 1));
	vertex_submit(edtAnimLoopModel, pr_trianglelist, -1);

	//Draw loop on xz-plane
	matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 90, 90, 0, 1, 1, 1), worldMatrix));
	shader_set_uniform_f(shader_get_uniform(shader, "u_thickness"), thickness);
	shader_set_uniform_f(shader_get_uniform(shader, "u_colour"), 0, 1, 0, lerp(0.75, 1, edtAnimMouseoverHandle == 2 || edtAnimSelectedHandle == 2));
	vertex_submit(edtAnimLoopModel, pr_trianglelist, -1);

	shader_reset();


}
