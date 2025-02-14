function load_model(fname){
	if (!file_exists(fname)){
		show_debug_message("file doesnt exist " + fname);
		return;
	}
	
	var model = noone;
	
	switch (filename_ext(fname)){
	case ".smf":
		model = smf_model_load(fname);
		break;
	case ".smfe":
		model = smf_ext_model_load(fname);
		break
	case ".obj":
		model = smf_model_load_obj(fname);
		break;
	}
	
	if (model == noone){
		show_debug_message("Couldnt load model " + fname);
		return noone;
	}
	
	model = {
		"smf": model,
		"instance": new smf_instance(model),
		"path": fname,
	}
	
	return model;
}