globalvar delta, model;

targetDelta = 1 / 60;
delta = (delta_time / targetDelta) / 1000000;

model = noone;

main = {
	"width": display_get_gui_width(),
	"height": display_get_gui_height(),
	"background": noone,
}

modelview = {
	"width": main.width - (main.width / 3),
	"height": main.height,
	"background": noone,
}

sidebar = {
	"width": main.width - modelview.width,
	"height": main.height,
	"background": make_color_rgb(24, 24, 24)
}

viewheader = {
	"width": modelview.width,
	"height": modelview.height / 24,
	"background": make_color_rgb(16, 16, 16),
}

loadModel = new jui_button(viewheader.width / 5, viewheader.height, "Load Model", false, fa_center);
loadModel.onClick = function(){
	var path = get_open_filename_ext("3D models|*.obj;*.smf;*.smfe", "", "", "load a 3d model")
	if (file_exists(path)){
		var previousModel = model;
		model = load_model(path);
		
		if (model != noone){
			previousModel.smf.destroy();
		}
	}
}

modelMat = matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1);
identity = matrix_build_identity();

viewheader.content = [
	loadModel,
]

modelview.content = [
	viewheader,
]

main.content = [
	modelview,
	sidebar,
]