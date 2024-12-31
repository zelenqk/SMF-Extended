//Intialialize variables
game_set_speed(100, gamespeed_fps)

editor_init();
move_camera();

//Create splash screen
instance_create_depth(0, 0, -10, oAnimEditSplash);

//Load various models
globalvar modSphere, modCube, modUnitarrows, modWall, modArrow;
modSphere = vbuff_load_obj("AnimEditor/Geosphere.obj");
modCube = vbuff_load_obj("AnimEditor/Cube.obj");
modUnitarrows = vbuff_load_obj("AnimEditor/UnitDimensionArrows.obj");
modArrow = vbuff_load_obj("AnimEditor/RotateXArrow.obj");
modArrow2 = vbuff_load_obj("AnimEditor/RotateYArrow.obj");
modArrow3 = vbuff_load_obj("AnimEditor/RotateZArrow.obj");
modWall = mod_create_wall();