globalvar models;
models = {};

function load_model(fname){
	if (models[$ fname] != undefined){
		
		return models[$ fname];
	}
	
	if (!file_exists(fname)){
		show_debug_message("file doesnt exist " + fname);
		return;
	}
	
	var model = noone;
	
	switch (filename_ext(fname)){
	case ".smf":
		model = smf_model_load(fname);
		break;
	case ".obj":
		model = smf_model_load_obj(fname);
		break;
	}
	
	if (model == noone){
		show_debug_message("Couldnt load model" + fname);
		return noone;
	}
	
	for(var i = 0; i < array_length(model.texPack); i++){
		var spr = model.texPack[i];
		var tex = -1;
		
		if (sprite_exists(spr)) tex = sprite_get_texture(spr, 0);

		model.texPackPTR[i] = tex;
	}
	
	model.texPackSurf = array_create(i, -1);
	
	model = {
		"smf": model,
		"cm": cm_list(),
		"path": fname,
	}
	
	
	//convert smf to cm for collision;
	for(var i = 0; i < array_length(model.smf.mBuff); i++){
		cm_add_buffer(model.cm, model.smf.mBuff[i], 44, undefined, true, false);
	}
	
	models[$ fname] = model;
	
	return model;
}