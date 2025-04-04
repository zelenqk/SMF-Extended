/// @description
draw_text(10, 20, 
	"SMF demo 1: Drawing a looping animation:\n" +
	"FPS: " + string(fps) + " FPS_real: " + string(fps_real) + "\n" +
	"This shows how to draw a simple looping animation, nothing fancy.\n" +
	"The animation is drawn using fast sampling, which is ridiculously fast, but may produce \"stuttery\" animations.\n" +
	"For real-time sample editing, fast sampling must be disabled.\n" +
	"When fast sampling is disabled, the animation linearly interpolates between frames, producing a smoother animation at the cost of a little more processing.\n" +
	"Press E to disable/enable fast sampling.\n" +
	"Fast sampling: " + (smf_instance_get_fast_sampling(mainInst) ? "Enabled" : "Disabled") + "\n" + 
	"Press 1 through 6 to switch rooms");