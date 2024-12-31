/// @description mbuff_load_obj_from_buffer(fname, load_textures)
/// @param fname
/// @param load_textures

function mbuff_load_obj_from_buffer(buffer, path = "", load_textures = true) {
	/*
		Loads an OBJ file and returns an array containing the following:
		[mBuff, texPack]
	
		Script created by TheSnidr, 2019
		www.thesnidr.com
	*/
	var contents = buffer_read(buffer, buffer_text);
	var lines = string_split(contents, "\n");
	var num = array_length(lines);

	//Create the necessary data structures
	var usemtl = "None";
	var mtlind = 0;
	var materials = [];
	var submodels = [];
	var faces = [];
	var mtlFname = "";
	var face_verts = array_create(5);
	var V = array_create(num);
	var N = array_create(num);
	var T = array_create(num);
	var V_num = 0;
	var N_num = 0;
	var T_num = 0;
	
	//Read .obj as text
	for (var i = 0; i < num; ++i)
	{
		//Remove the newline from the end of the string
		var this_line = string_delete(lines[i], string_length(lines[i]), 1);
		
		//Continue if the string is empty
		if (this_line == "") continue;
		
		var tokens = string_split(this_line, " ");
		//Different types of information in the .obj starts with different headers
		switch tokens[0]
		{
			//Load vertex positions
			case "v":
				V[V_num ++] = [real(tokens[1]), real(tokens[2]), real(tokens[3])];
				break;
			//Load normals
			case "vn":
				N[N_num ++] = [real(tokens[1]), real(tokens[2]), real(tokens[3])];
				break;
			//Load texture coordinates
			case "vt":
				T[T_num ++] = [real(tokens[1]), real(tokens[2])];
				break;
			//Load faces
			case "f":
				var vert_num = array_length(tokens) - 1;
				for (var j = 0; j < vert_num; ++j)
				{
					var info = tokens[j + 1];
					var indices = string_split(info, "/");
					var slashnum = string_count("/", info);
					var doubleslashnum = string_count("//", info);
					
					if (slashnum == 2 && doubleslashnum == 0)
					{	//If the vertex contains a position, texture coordinate and normal
						face_verts[j] = [real(indices[0]) - 1, real(indices[2]) - 1, real(indices[1]) - 1];
					}
					else if (slashnum == 1)
					{	//If the vertex contains a position and a texture coordinate
						face_verts[j] = [real(indices[0]) - 1, 0, real(indices[1]) - 1];
					}
					else if (slashnum == 0)
					{	//If the vertex only contains a position
						face_verts[j] = [real(indices[0]) - 1, 0, 0];
					}
					else if (doubleslashnum == 1)
					{	//If the vertex contains a position and normal
						face_verts[j] = [real(indices[0]) - 1, real(indices[2]) - 1, 0];
					}
				}
				
				//Add vertices in a triangle fan
				var F = submodels[mtlind];
				for (var j = 0; j <= vert_num - 3; ++j)
				{
					F[faces[mtlind] ++] = face_verts[0];
					F[faces[mtlind] ++] = face_verts[j + 2];
					F[faces[mtlind] ++] = face_verts[j + 1];
				}
				break;
			//Load name of MTL library
			case "mtllib":
				mtlFname = tokens[1];
				break;
			//Load material name
			case "usemtl":
				usemtl = tokens[1];
				mtlind = array_get_index(materials, usemtl);
				if (mtlind < 0)
				{
					mtlind = array_length(materials);
					materials[mtlind] = usemtl;
					submodels[mtlind] = array_create(num);
					faces[mtlind] = 0;
				}
				break;
		}
	}

	//Loop through the loaded information and generate a mesh
	var bytesPerVert, modelNum, vnt, vertNum, mBuff, v, n, t;
	bytesPerVert = mBuffBytesPerVert;
	modelNum = array_length(submodels);
	mBuff = array_create(modelNum);
	for (var m = 0; m < modelNum; m ++)
	{
		var F = submodels[m];
		vertNum = faces[m];
		mBuff[m] = buffer_create(vertNum * bytesPerVert, buffer_fixed, 1);
		for (var f = 0; f < vertNum; f ++)
		{
			vnt = F[f];
		
			//Add the vertex to the model buffer
			v = V[vnt[0]];
			buffer_write(mBuff[m], buffer_f32, v[0]);
			buffer_write(mBuff[m], buffer_f32, v[2]);
			buffer_write(mBuff[m], buffer_f32, v[1]);
		
			//Vertex normal
			n = N[vnt[1]];
			buffer_write(mBuff[m], buffer_f32, n[0]);
			buffer_write(mBuff[m], buffer_f32, n[2]);
			buffer_write(mBuff[m], buffer_f32, n[1]);
		
			//Vertex UVs
			t = T[vnt[2]];
			buffer_write(mBuff[m], buffer_f32, t[0]);
			buffer_write(mBuff[m], buffer_f32, 1-t[1]);
			
			//Auxiliary attributes
			buffer_write(mBuff[m], buffer_u32, c_white); //Colour, white by default
			buffer_write(mBuff[m], buffer_u32, 0); //Bone indices
			buffer_write(mBuff[m], buffer_u32, 1); //Bone weights
		}
	}

	//Load MTL file
	var texPack = [];
	if load_textures
	{
		var mtlPath = filename_path(path) + filename_name(mtlFname);
		texPack = texpack_load_mtl(mtlPath, materials);
	}

	//Return array containing the mBuff array, the name of the mtl file and the names of the materials of the submodels
	return [mBuff, texPack];
}
/*

function mbuff_load_obj_from_buffer(buffer, path = "", load_textures = true) {

	var currentMaterial = "Default";
	var materialList = ds_list_create();
	var mtlFname = "";

	//Create the necessary lists
	var V, N, T, Fa, F, m, ind;
	var V = ds_list_create();
	var N = ds_list_create();
	var T = ds_list_create();
	Fa[0] = ds_list_create();

	//Read .obj as textfile
	var file = buffer_read(buffer, buffer_string);
	while true
	{
		var pos = string_pos("\n", file);
		var str = string_copy(file, 1, pos);
		if (str == "")
		{
			break;
		}
		file = string_delete(file, 1, pos);
		str = string_replace_all(str,"  "," ");
		
		//Different types of information in the .obj starts with different headers
		switch string_copy(str, 1, 2)
		{
			//Load name of MTL library
			case "mt":
				mtlFname = string_delete(str, 1, string_pos(" ", str));
				mtlFname = filename_name(mtlFname);
				while string_count(".", mtlFname){
					mtlFname = filename_change_ext(mtlFname, "");}
				mtlFname += ".mtl";
				break;
			//Load vertex positions
			case "v ":
				ds_list_add(V, _mbuff_read_obj_line(str));
				break;
			//Load vertex normals
			case "vn":
				ds_list_add(N, _mbuff_read_obj_line(str));
				break;
			//Load vertex texture coordinates
			case "vt":
				ds_list_add(T, _mbuff_read_obj_line(str));
				break;
			//Load material name
			case "us":
				currentMaterial = string_delete(str, 1, string_pos(" ", str));
				if (ds_list_find_index(materialList, currentMaterial) < 0)
				{
					ds_list_add(materialList, currentMaterial);
					ind = ds_list_find_index(materialList, currentMaterial);
					Fa[ind] = ds_list_create();
				}
				break;
			//Load faces
			case "f ":
				m = max(ds_list_find_index(materialList, currentMaterial), 0);
				_mbuff_read_obj_face(Fa[m], str);
				break;
		}
	}

	//Loop through the loaded information and generate a mesh
	var bytesPerVert, modelNum, vnt, vertNum, mBuff, v, n, t;
	bytesPerVert = mBuffBytesPerVert;
	modelNum = array_length(Fa);
	mBuff = array_create(modelNum);
	for (var m = 0; m < modelNum; m ++)
	{
		F = Fa[m];
		vertNum = ds_list_size(F);
		mBuff[m] = buffer_create(vertNum * bytesPerVert, buffer_fixed, 1);
		for (var f = 0; f < vertNum; f ++)
		{
			vnt = F[| f];
		
			//Add the vertex to the model buffer
			v = V[| vnt[0]];
			if !is_array(v){v = [0, 0, 0];}
			buffer_write(mBuff[m], buffer_f32, v[0]);
			buffer_write(mBuff[m], buffer_f32, v[2]);
			buffer_write(mBuff[m], buffer_f32, v[1]);
		
			//Vertex normal
			n = N[| vnt[1]];
			if !is_array(n){n = [0, 0, 1];}
			buffer_write(mBuff[m], buffer_f32, n[0]);
			buffer_write(mBuff[m], buffer_f32, n[2]);
			buffer_write(mBuff[m], buffer_f32, n[1]);
		
			//Vertex UVs
			t = T[| vnt[2]];
			if !is_array(t){t = [.5, .5];}
			buffer_write(mBuff[m], buffer_f32, t[0]);
			buffer_write(mBuff[m], buffer_f32, 1-t[1]);
			
			//Auxiliary attributes
			buffer_write(mBuff[m], buffer_u32, c_white); //Colour, white by default
			buffer_write(mBuff[m], buffer_u32, 0); //Bone indices
			buffer_write(mBuff[m], buffer_u32, 1); //Bone weights
		}
	}

	//Copy the contents of the materialList over to an array
	n = ds_list_size(materialList);
	var mtlNames = array_create(n);
	for (var i = 0; i < n; i ++)
	{
		mtlNames[i] = materialList[| i];
	}

	ds_list_destroy(F);
	ds_list_destroy(V);
	ds_list_destroy(N);
	ds_list_destroy(T);
	ds_list_destroy(materialList);

	//Load MTL file
	var texPack = [];
	if load_textures
	{
		var mtlPath = filename_path(path) + filename_name(mtlFname);
		texPack = texpack_load_mtl(mtlPath, mtlNames);
	}

	//Return array containing the mBuff array, the name of the mtl file and the names of the materials of the submodels
	return [mBuff, texPack];
}
