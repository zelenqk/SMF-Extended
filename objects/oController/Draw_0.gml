if (model == noone) exit;

shader_set(sh_smf_static);

// Draw the model
matrix_set(matrix_world, modelMat);
model.instance.draw();
matrix_set(matrix_world, identity);

shader_reset();