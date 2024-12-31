/// @description
//Set player position and previous coordinates
z = 0;
prevX = x;
prevY = y;
prevZ = z;
faceDir = random(360);
headDir = 0;
turn = false;

//Load models
mainInst = smf_instance_create(global.modMan);
if floor(random(4)) == 0
{
	smf_instance_play_animation(mainInst, choose("Dance", "Dance2"), .015, 1, true);
}
else
{
	smf_instance_play_animation(mainInst, "Idle", .01, 1, true);
}
smf_instance_set_timer(mainInst, random(1));

M = matrix_build(x, y, z, 0, 0, -faceDir, 16, 16, 16);