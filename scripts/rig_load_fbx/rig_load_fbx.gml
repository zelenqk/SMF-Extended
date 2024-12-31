/// @description rig_load_fbx(fname)
/// @param fname
function rig_load_fbx() {
	/*
	Loads an .fbx model into SMF
	*/
	/*
	var fname, meshNum, i, vertNum, vertPosBuff, triNum, triVertIndices, norBuff, uvBuff, vertInd, vx, vy, vz, nx, ny, nz, u, v;
	fname = argument0;
	var meshNum = ImportModelAndSplitMeshes(fname);
	if meshNum <= 0{show_debug_message("Failed to load model " + string(fname)); exit;}
	show_debug_message("Loading FBX file " + string(fname) + " into SMF");

	/*
	Load the nodes from the FBX
	Nodes may already have been transformed, and as such, they can not be used directly to create the bind pose.
	Each node stores its position and rotation within the parent node, meaning they have to be hierarchichally
	multiplied together to create the world orientation
	*/
	/*
	fbxNodeNum = GetNumNodes();
	nodeBuff = buffer_create(80 * fbxNodeNum, buffer_grow, 8);
	GetNodes(buffer_get_address(nodeBuff));
	averageBoneLength = 0;
	for (var i = 0; i < fbxNodeNum; i ++)
	{
		//The index of this node's parent
		fbxNodeParent[i] = buffer_read(nodeBuff, buffer_f64);
		//Translation
		tx = buffer_read(nodeBuff, buffer_f64);
		ty = buffer_read(nodeBuff, buffer_f64);
		tz = buffer_read(nodeBuff, buffer_f64);
		//Rotation
		rx = buffer_read(nodeBuff, buffer_f64);
		ry = buffer_read(nodeBuff, buffer_f64);
		rz = buffer_read(nodeBuff, buffer_f64);
		//Scaling
		sx = buffer_read(nodeBuff, buffer_f64);
		sy = buffer_read(nodeBuff, buffer_f64);
		sz = buffer_read(nodeBuff, buffer_f64);
	
		fbxNodeT[i] = [tx, ty, tz];
		fbxNodeR[i] = [rx, ry, rz];
		fbxNodeS[i] = [sx, sy, sz];
		fbxNodeLength[i] = point_distance_3d(0, 0, 0, tx / sx, ty / sy, tz / sz);
		averageBoneLength += fbxNodeLength[i];
		fbxNodeChildren[i] = -1;
		fbxNodeChildNum[i] = 0;
		if fbxNodeParent[i] >= 0{
			fbxNodeChildren[fbxNodeParent[i], fbxNodeChildNum[fbxNodeParent[i]]++] = i;}
	}
	buffer_delete(nodeBuff);
	averageBoneLength /= fbxNodeNum;
	//Append all leaf bones
	for (var i = 0; i < fbxNodeNum; i ++)
	{
		if fbxNodeChildNum[i] > 0{continue;}
		fbxNodeInd = array_length(fbxNodeLength);
		fbxNodeChildren[i, fbxNodeChildNum[i]++] = fbxNodeInd;
		fbxNodeParent[fbxNodeInd] = i;
		fbxNodeLength[fbxNodeInd] = fbxNodeLength[i];
		fbxNodeChildren[fbxNodeInd] = -1;
		fbxNodeChildNum[fbxNodeInd] = 0;
		fbxNodeT[fbxNodeInd] = [fbxNodeLength[i], 0, 0];
		fbxNodeR[fbxNodeInd] = [0, 0, 0];
		fbxNodeS[fbxNodeInd] = [1, 1, 1];
	}

	//Lists used for indexing bones
	boneMatList = ds_list_create();
	boneIndList = ds_list_create();
	boneMap = ds_map_create();
	boneWeightPriority = ds_priority_create();

	for (var i = 0; i < meshNum; i ++)
	{
		//Get number of vertices and their positions
		vertNum = GetMeshNumVertices(i);
		vertPosBuff = buffer_create(vertNum * 24, buffer_grow, 8);
		GetMeshVertexPositions(i, buffer_get_address(vertPosBuff));
	
		//Get number of triangles and their vertex indices
		triNum = GetMeshNumTriangles(i);
		triVertIndices = buffer_create(triNum * 12, buffer_grow, 4);
		GetMeshTriangleVertexIndices(i, buffer_get_address(triVertIndices));
	
		//Get number of normals and their vectors
		norNum = GetMeshTriangleNormalsSize(i);
		norPerVert = norNum / triNum / 9;
		norBuff = buffer_create(max(1, norNum) * 8, buffer_grow, 8);
		GetMeshTriangleNormals(i, buffer_get_address(norBuff));
	
		//Get UVs
		uvNum = GetMeshTriangleUVsSize(i);
		uvPerVert = uvNum / triNum / 6;
		uvBuff = buffer_create(max(1, uvNum) * 8, buffer_grow, 8);
		GetMeshTriangleUVs(i, buffer_get_address(uvBuff));
		
		//Create a buffer for bone indices and weights
		bonePerVertBuff = buffer_create(vertNum * 8 * 4, buffer_grow, 4); //Four indices + four weights per vert, buffer_f32
	
		/*
		Load the skins of this mesh
		A skin is basically the part of the rig that affects this mesh. Usually, each skin stores the entire rig
		*/
		/*
		skinNum = GetMeshNumSkins(i);
		for (var j = 0; j < skinNum; j ++)
		{
			for (var n = 0; n < fbxNodeNum; n ++){	//Reset the child counter
				fbxNodeChildCounter[n] = 0;}
			//Load the bones of this skin
			boneNum = GetMeshSkinNumBones(i, j);
			boneBuff = buffer_create(boneNum * 88, buffer_grow, 8);
			GetMeshSkinBoneData(i, j, buffer_get_address(boneBuff));
			for (var k = 0; k < boneNum; k ++)
			{
				//The index of the parent node of this bone
				parentNode = buffer_read(boneBuff, buffer_f64);
				//The number of vertices affected by this bone
				boneVertNum = buffer_read(boneBuff, buffer_f64);
				//Translation of this bone in world space
				tx = buffer_read(boneBuff, buffer_f64);
				ty = buffer_read(boneBuff, buffer_f64);
				tz = buffer_read(boneBuff, buffer_f64);
				//Rotation of this bone in world space
				rx = buffer_read(boneBuff, buffer_f64);
				ry = buffer_read(boneBuff, buffer_f64);
				rz = buffer_read(boneBuff, buffer_f64);
				//Scaling of this bone in world space
				sx = buffer_read(boneBuff, buffer_f64);
				sy = buffer_read(boneBuff, buffer_f64);
				sz = buffer_read(boneBuff, buffer_f64);
				//Create the bone's world matrix. Note that this is tail-oriented, meaning it omits the end bones. SMF is head-oriented, so it needs to be converted later
				boneMat = matrix_multiply(matrix_build(ty / sy, tx / sx, tz / sz, ry, rx, rz, 1, 1, 1), matrix_build(0, 0, 0, 0, 90, -90, 1, 1, 1));
				//Find the index of the node of this bone
				fbxNodeIndex = -1;
				if fbxNodeChildCounter[parentNode] < fbxNodeChildNum[parentNode]{
					fbxNodeIndex = fbxNodeChildren[parentNode, fbxNodeChildCounter[parentNode]++];}
				boneIndex = ds_list_find_index(boneIndList, fbxNodeIndex)
				//If this bone hasn't been added before
				if boneIndex < 0
				{
					boneIndex = ds_grid_height(RigBoneGrid);
					boneParent[boneIndex] = ds_list_find_index(boneIndList, parentNode);
					ds_grid_resize(RigBoneGrid, BoneGridValues, boneIndex + 1);
			
					//Loop through all bones and see if a bone has been added at this position before
					delta = fbxNodeLength[fbxNodeIndex] / 1000;
					var A = boneIndex;
					while A--{
						testMat = boneMatList[| A];
						if abs(boneMat[SMF_X] - testMat[SMF_X]) > delta or abs(boneMat[SMF_Y] - testMat[SMF_Y]) > delta or abs(boneMat[SMF_Z] - testMat[SMF_Z]) > delta{
							continue;}
						if boneParent[boneIndex] < 0{boneParent[boneIndex] = A;}
						break;}
			
					//If this detached bone has not been added before
					if A < 0
					{
						grandParent = ds_list_find_index(boneIndList, fbxNodeParent[parentNode]);
						parentMat = boneMatList[| max(0, grandParent)];
						if !is_array(parentMat){parentMat = matrix_build_identity();}
						//The grandparent is the tip of the "parent bone"
						//Now we're comparing the bone to its grandparent. If they do not equal, create an additional detached bone.
						if grandParent < 0 or abs(boneMat[SMF_X] - parentMat[SMF_X]) > delta or abs(boneMat[SMF_Y] - parentMat[SMF_Y]) > delta or abs(boneMat[SMF_Z] - parentMat[SMF_Z]) > delta
						{
							boneParent[boneIndex] = max(0, grandParent+1);
							//Create the bone's orientation from the relation between the node's orientation and its parent
							RigBoneGrid[# BoneDQ, boneIndex] = dq_create(0, 0, 0, 0, boneMat[SMF_X], boneMat[SMF_Y], boneMat[SMF_Z]);
							RigBoneGrid[# BoneAttach, boneIndex] = false; //Detached
							RigBoneGrid[# BoneParent, boneIndex] = boneParent[boneIndex];
						
							boneIndList[| boneIndex] = parentNode;
							boneMatList[| boneIndex] = array_create(16); 
							array_copy(boneMatList[| boneIndex], 0, boneMat, 0, 16);
				
							boneIndex ++;
							boneParent[boneIndex] = max(boneIndex - 1, 0);
							ds_grid_resize(RigBoneGrid, BoneGridValues, boneIndex + 1);
						}
					}
			
					//The bind pose puts each bone at the position of the parent and pointing at the child
					//SMF puts the bone at the child's position. This piece of code makes sure the bone ends up at the right position
					boneMat[SMF_X] += fbxNodeLength[fbxNodeIndex] * boneMat[SMF_XTO];
					boneMat[SMF_Y] += fbxNodeLength[fbxNodeIndex] * boneMat[SMF_YTO];
					boneMat[SMF_Z] += fbxNodeLength[fbxNodeIndex] * boneMat[SMF_ZTO];
			
					boneIndList[| boneIndex] = fbxNodeIndex;
					boneMatList[| boneIndex] = array_create(16); 
					array_copy(boneMatList[| boneIndex], 0, boneMat, 0, 16);
			
					RigBoneGrid[# BoneDQ, boneIndex] = dq_create_from_matrix(boneMat);
					RigBoneGrid[# BoneParent, boneIndex] = boneParent[boneIndex];
					RigBoneGrid[# BoneAttach, boneIndex] = true;
					RigBoneGrid[# BoneLength, boneIndex] = fbxNodeLength[fbxNodeIndex];
				}
			
				//Apply the bone indices and weights to the affected vertices
				if boneVertNum > 0
				{
					boneVerts = buffer_create(boneVertNum * 16, buffer_grow, 8);
					GetMeshSkinBoneVertexData(i, j, k, buffer_get_address(boneVerts));
					for (var h = 0; h < boneVertNum; h ++)
					{
						vert = buffer_read(boneVerts, buffer_f64);
						weight = buffer_read(boneVerts, buffer_f64);
						var sum = 0;
						var text = "";
						ds_priority_clear(boneWeightPriority);
						ds_priority_add(boneWeightPriority, boneIndex, weight);
						buffer_seek(bonePerVertBuff, buffer_seek_start, vert * 8 * 4);
						for (var l = 0; l < 4; l ++){
							boneInd[l] = buffer_read(bonePerVertBuff, buffer_f32);}
						for (var l = 0; l < 4; l ++){
							boneWth[l] = buffer_read(bonePerVertBuff, buffer_f32);
							ds_priority_add(boneWeightPriority, boneInd[l], boneWth[l]);}
						for (var l = 0; l < 4; l ++){
							boneWth[l] = ds_priority_find_priority(boneWeightPriority, ds_priority_find_max(boneWeightPriority));
							boneInd[l] = ds_priority_delete_max(boneWeightPriority);}
						buffer_seek(bonePerVertBuff, buffer_seek_start, vert * 8 * 4);
						for (var l = 0; l < 4; l ++){
							buffer_write(bonePerVertBuff, buffer_f32, boneInd[l]);}
						for (var l = 0; l < 4; l ++){
							buffer_write(bonePerVertBuff, buffer_f32, boneWth[l]);}
					}
					buffer_delete(boneVerts);
				}
			}
			buffer_delete(boneBuff);
		}
	
		/*
		Generate a buffer that will later be converted to vertex buffer
		*/
		/*
		mBuff[i] = buffer_create(triNum * 3 * SMF_format_bytes, buffer_fixed, 1);
		repeat triNum * 3
		{
			vertInd = buffer_read(triVertIndices, buffer_s32);
			buffer_seek(vertPosBuff, buffer_seek_start, vertInd * 24);
			buffer_seek(bonePerVertBuff, buffer_seek_start, vertInd * 8 * 4);
			vx = buffer_read(vertPosBuff, buffer_f64);
			vy = buffer_read(vertPosBuff, buffer_f64);
			vz = buffer_read(vertPosBuff, buffer_f64);
			nx = 0; ny = 0; nz = 0;
			u = 0; v = 0;
			if norPerVert >= 1{
				nx = buffer_read(norBuff, buffer_f64);
				ny = buffer_read(norBuff, buffer_f64);
				nz = buffer_read(norBuff, buffer_f64);
				repeat (norPerVert - 1) * 3{
					buffer_read(norBuff, buffer_f64);}}
			if uvPerVert >= 1{
				u = buffer_read(uvBuff, buffer_f64);
				v = 1 - buffer_read(uvBuff, buffer_f64);
				repeat (uvPerVert - 1) * 2{
					buffer_read(uvBuff, buffer_f64);}}
			buffer_write(mBuff[i], buffer_f32, -vx);
			buffer_write(mBuff[i], buffer_f32, vy);
			buffer_write(mBuff[i], buffer_f32, vz);
			buffer_write(mBuff[i], buffer_f32, -nx);
			buffer_write(mBuff[i], buffer_f32, ny);
			buffer_write(mBuff[i], buffer_f32, nz);
			buffer_write(mBuff[i], buffer_f32, u);
			buffer_write(mBuff[i], buffer_f32, v);
			repeat 4{buffer_write(mBuff[i], buffer_u8, 255);}
			repeat 4{
				b = 0;
				if ds_list_size(RigBindPose) > 0{
					b = RigBindPoseMappingList[| buffer_read(bonePerVertBuff, buffer_f32)];}
				buffer_write(mBuff[i], buffer_u8, b);}
		
			var sum = 0;
			for (var j = 0; j < 4; j ++){
				wth[j] = buffer_read(bonePerVertBuff, buffer_f32);
				sum += wth[j];}
			if sum == 0{wth[0] = 1; sum = 1}
			wth = [1, 0, 0, 0]; sum = 1;
			for (var j = 0; j < 4; j ++){buffer_write(mBuff[i], buffer_u8, 255 * wth[j] / sum);}
		}
	
	
		buffer_delete(vertPosBuff);
		buffer_delete(triVertIndices);
		buffer_delete(norBuff);
		buffer_delete(uvBuff);
		buffer_delete(bonePerVertBuff);
	}
	//rig_create_sample_static();
	//rig_update_skeleton();

	/*
	Load animations
	*/
	/*
	var animNum = GetNumAnims();
	for (var i = 0; i < animNum; i ++)
	{
		var timelineMap = ds_map_create();
		var numCurves = GetAnimNumCurves(i);
		totalTime = 0;
		//Index the "animation curves" by their time stamps
		for (var j = 0; j < numCurves; j ++)
		{
			localFrame = ds_list_create();
			var numKeyframes = GetAnimCurveNumKeyframes(i, j);
			var keyframeBuff = buffer_create((2 + 4 * numKeyframes) * 8, buffer_grow, 8);
			GetAnimCurveData(i, j, buffer_get_address(keyframeBuff));
			nodeIndex = buffer_read(keyframeBuff, buffer_f64);
			curveType = buffer_read(keyframeBuff, buffer_f64) - 1; //1 = translation, 2 = rotation, 3 = scaling
			for (var k = 0; k < numKeyframes; k ++)
			{
				time = buffer_read(keyframeBuff, buffer_f64);
				totalTime = max(totalTime, time);
				_x = buffer_read(keyframeBuff, buffer_f64);
				_y = buffer_read(keyframeBuff, buffer_f64);
				_z = buffer_read(keyframeBuff, buffer_f64);
				var transformBoneGrid = timelineMap[? time];
				if is_undefined(transformBoneGrid){
					transformBoneGrid = ds_grid_create(fbxNodeNum, 3);
					timelineMap[? time] = transformBoneGrid;}
				transformBoneGrid[# nodeIndex, curveType] = [_x, _y, _z];
			}
			buffer_delete(keyframeBuff)
		}

		AnimName[i] = GetAnimName(i);
		var boneList = ds_list_create();
		var timeList = ds_list_create();
		AnimKeyframeBones[i] = boneList; //Bonelist stores a list of the transformations for each bone
		AnimKeyframeTime[i] = timeList; //Timelist stores the time of the given keyframe
	
		//Sort the frames into a list
		var frameList = ds_list_create();
		while ds_map_size(timelineMap){
			//Find the timestamp of this frame
			var keyframeTime = ds_map_find_first(timelineMap);
			var time = 9999999;
			while !is_undefined(keyframeTime){
				time = min(keyframeTime, time);
				keyframeTime = ds_map_find_next(timelineMap, keyframeTime);}
			ds_list_add(timeList, time / totalTime);
			ds_list_add(frameList, timelineMap[? time]);
			ds_map_delete(timelineMap, time);}
		
		var keyframeNum = ds_list_size(frameList);
		for (var j = 0; j < keyframeNum; j ++)
		{
			transformBoneGrid = frameList[| j];
			time = timeList[| j];
			var localFrame = ds_list_create();
			boneList[| j] = localFrame;
			for (var n = 0; n < fbxNodeNum; n ++)
			{
				var keyframeT = transformBoneGrid[# n, 0];
				var keyframeR = transformBoneGrid[# n, 1];
				var keyframeS = transformBoneGrid[# n, 2];
				if !is_array(keyframeT){ //If this bone does not have a curve in this keyframe, look for the nearest keyframe both backwards and forwards in time, and interpolate between them
					prevKeyframeT = -1;
					nextKeyframeT = -1;
					keyframeT = fbxNodeT[n];
					//Check backwards in time
					for (var k = j-1; k >= 0; k --){
						prevTime = timeList[| k];
						prevTransformBoneGrid = frameList[| k];
						prevKeyframeT = prevTransformBoneGrid[# n, 0];
						if is_array(prevKeyframeT){keyframeT = prevKeyframeT; break;}}
					//Check forwards in time
					for (var k = j+1; k < keyframeNum; k ++){
						nextTime = timeList[| k];
						nextTransformBoneGrid = frameList[| k];
						nextKeyframeT = nextTransformBoneGrid[# n, 0];
						if is_array(nextKeyframeT){keyframeT = array_lerp(fbxNodeT[n], nextKeyframeT, time / nextTime); break;}}
					//Compare the two, and if both exist, interpolate between them
					if is_array(prevKeyframeT) and is_array(nextKeyframeT){
						dt = nextTime - prevTime;
						amount = 0;
						if dt > 0{
							amount = (time - nextTime) / dt;}
						keyframeT = array_lerp(prevKeyframeT, nextKeyframeT, amount);}
					else {keyframeT = fbxNodeT[n];}}
				if !is_array(keyframeR){ //If this bone does not have a curve in this keyframe, look for the nearest keyframe both backwards and forwards in time, and interpolate between them
					prevKeyframeR = -1;
					nextKeyframeR = -1;
					keyframeR = fbxNodeR[n];
					//Check backwards in time
					for (var k = j-1; k >= 0; k --){
						prevTime = timeList[| k];
						prevTransformBoneGrid = frameList[| k];
						prevKeyframeR = prevTransformBoneGrid[# n, 1];
						if is_array(prevKeyframeT){keyframeR = prevKeyframeR; break;}}
					//Check forwards in time
					for (var k = j+1; k < keyframeNum; k ++){
						nextTime = timeList[| k];
						nextTransformBoneGrid = frameList[| k];
						nextKeyframeR = nextTransformBoneGrid[# n, 1];
						if is_array(nextKeyframeR){keyframeR = array_lerp(fbxNodeR[n], nextKeyframeR, time / nextTime); break;}}
					//Compare the two, and if both exist, interpolate between them
					if is_array(prevKeyframeR) and is_array(nextKeyframeR){
						dt = nextTime - prevTime;
						amount = 0;
						if dt > 0{
							amount = (time - nextTime) / dt;}
						keyframeR = array_lerp(prevKeyframeR, nextKeyframeR, amount);}}
			
				keyframeNodeLocalMat[n] = matrix_build(keyframeT[1], keyframeT[0], keyframeT[2], keyframeR[1], keyframeR[0], keyframeR[2], 1, 1, 1);
			
				if fbxNodeParent[n] >= 0{
					keyframeNodeWorldMat[n] = matrix_multiply(keyframeNodeLocalMat[n], keyframeNodeWorldMat[fbxNodeParent[n]]);}
				else{
					keyframeNodeWorldMat[n] = keyframeNodeLocalMat[n];}
				keyframeNodeWorldDQ[n] = dq_create_from_matrix(matrix_multiply(keyframeNodeWorldMat[n], matrix_build(0, 0, 0, 0, 90, -90, 1, 1, 1)));
			
				if i == 0
				{
					TESTANIMATIONMATARRAY[j, n] = keyframeNodeWorldMat[n];
				}
			}
			//Now I've constructed the world positions of all the bones in the keyframe. These are stored in keyframeNodeWorldMat.
			//Compare these to the bindpose, and trace back to the delta local dual quat
		
			//Start by generating a sample for the entire skeleton
			for (var n = 0; n < ds_grid_height(RigBoneGrid); n ++)
			{
				var smfNodeInd = n;
				var fbxNodeInd = boneIndList[| smfNodeInd];
			
				boneBindDQ = RigBoneGrid[# BoneDQ, smfNodeInd];
			
				var fbxParentNode = fbxNodeParent[fbxNodeInd];
				boneWorldMat = keyframeNodeWorldMat[fbxParentNode];
				boneWorldMat[SMF_X] += boneWorldMat[SMF_XTO] * fbxNodeLength[fbxNodeInd];
				boneWorldMat[SMF_Y] += boneWorldMat[SMF_YTO] * fbxNodeLength[fbxNodeInd];
				boneWorldMat[SMF_Z] += boneWorldMat[SMF_ZTO] * fbxNodeLength[fbxNodeInd];
				boneWorldDQ = dq_create_from_matrix(boneWorldMat);
				
				//This is the sample for the entire smf node hierarchy
				deltaWorldDQ[smfNodeInd] = dq_multiply(boneWorldDQ, dq_get_conjugate(boneBindDQ));
			}
			//Then figure out the local changes in orientation
			for (var n = 0; n < ds_grid_height(RigBoneGrid); n ++)
			{
				var smfNodeInd = n;
				var smfNodeParent = RigBoneGrid[# BoneParent, smfNodeInd];
			
				var smfNodeWorldDQ = dq_multiply(deltaWorldDQ[smfNodeInd], RigBoneGrid[# BoneDQ, smfNodeInd]);
				var smfParentWorldDQ = dq_multiply(deltaWorldDQ[smfNodeParent], RigBoneGrid[# BoneDQ, smfNodeParent]);
			
				var keyframeLocalDQ = dq_multiply(dq_get_conjugate(smfParentWorldDQ), smfNodeWorldDQ);
				var bindLocalDQ = dq_multiply(dq_get_conjugate(RigBoneGrid[# BoneDQ, smfNodeParent]), RigBoneGrid[# BoneDQ, smfNodeInd]);
			
				var Q = dq_normalize(dq_multiply(dq_get_conjugate(bindLocalDQ), keyframeLocalDQ));
				localFrame[| n] = Q;
			}
		}
		ds_map_destroy(timelineMap);
	}


	for (var i = 0; i < meshNum; i ++)
	{
		modelBufferList[i] = mBuff[i];
		animationModelList[i] = vertex_create_buffer_from_buffer(mBuff[i], SMF_format);
		modelVisible[i] = true;
		RigVertsPerPointList[i] = ds_list_create();
		RigFaceList[i] = ds_list_create();
		skinSelectionList[i] = ds_list_create();
		RigNormalMapFactor[i] = 0.5;
		RigHeightMapDepth[i] = 0;
		editorNormalIndex[i] = "NomDefault";
		editorTextureIndex[i] = "TexDefault";
		editorMaterialIndex[i] = "Default material";
		if GetMeshNumMaterials(i) > 0
		{
			if GetMeshMaterialNumTextures(i, 0) > 0
			{
				fname = filename_name(GetMeshMaterialTextureFilename(i, 0, 0));
				editorTextureIndex[i] = fname;
				if is_undefined(editorTextureMap[? fname]){
					editorTextureMap[? fname] = sprite_duplicate(editorTextureMap[? "TexDefault"]);}
			}
		}
	}
	smf_model_flip_triangles(edtModelIndex);

/* end rig_load_fbx */
}
