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
	"background": make_color_rgb(24, 24, 24),
	"contentOffsetY": 0,
	"step": function(){
		var maxOffset = max(0, theight - self.height); // Max scrollable offset

		if (hovering){
			self.contentOffsetY += (mouse_wheel_up() - mouse_wheel_down()) * 10;
			self.contentOffsetY = clamp(self.contentOffsetY, -maxOffset, 0);
		}
	}
}


maps = [];
var mapNames = ["Diffuse", "Normal map", "Metallic", "Roughness", "Specular reflections", "Alpha", "Specular", "Transmission", "Coat", "Sheen", "Emission", "LightMap"];

for(var i = 0; i < array_length(mapNames); i++){
	maps[i] = new mapStyle(sidebar.width, sidebar.height / 16, mapNames[i]);
}

material = new dropdown(sidebar.width, sidebar.height / 12, "Material name", noone, maps);

sidebar.content = [material];

viewheader = {
	"width": modelview.width,
	"height": modelview.height / 24,
	"background": make_color_rgb(16, 16, 16),
}

loadModel = new jui_button(viewheader.width / 5, viewheader.height, "Load Model", false, fa_center);
loadModel.onClick = function(){
	var path = get_open_filename_ext("3D models|*.obj;*.smf;*.smfe", "", "", "load a 3d model");
	if (file_exists(path)){
		var previousModel = model;
		model = load_model(path);
		if (model != noone && previousModel != noone){
			previousModel.smf.destroy();
		}
	}
}

viewheader.content = [loadModel];
modelview.content = [viewheader];
main.content = [modelview, sidebar];