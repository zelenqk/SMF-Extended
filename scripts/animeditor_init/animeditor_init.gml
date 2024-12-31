function animeditor_init() {
	//Animation editor modes
	//////////////////////////////
	//Initialize animation
#macro ANIDRAGNODE 0
#macro ANIMOVENODE 1
#macro ANIROTATELOCAL 2
#macro ANIROTATEGLOBAL 3

#macro KEYFRAMEADDBLANK 0
#macro KEYFRAMEINSERT 1
#macro KEYFRAMEPASTE 2

	globalvar edtAnimKeyframeTool;
	edtAnimKeyframeTool = KEYFRAMEINSERT;

	globalvar edtAnimSelTool;
	edtAnimSelTool = ANIROTATELOCAL;

	globalvar edtAnimPlay, edtAnimPlayTime;
	edtAnimPlay = false;
	edtAnimPlayTime = 0;

	globalvar edtAnimFPSmode;
	edtAnimFPSmode = false;

	globalvar edtAnimIndexScroll;
	edtAnimIndexScroll = 0;

	globalvar edtAnimSelectedHandle, edtAnimMouseoverHandle, edtAnimHandleSurfSize, edtAnimHandleBuffer, edtAnimHandleMatrix, edtAnimRotCurrVec, edtAnimRotPrevVec, edtAnimRotStartVec;
	edtAnimHandleSurfSize = 128;
	edtAnimHandleBuffer = -1;
	edtAnimHandleMatrix = matrix_build_identity();
	edtAnimSelectedHandle = -1;
	edtAnimMouseoverHandle = -1;
	edtAnimRotCurrVec = -1;
	edtAnimRotStartVec = -1;

	globalvar edtAnimTempSample;
	edtAnimTempSample = [];

	animeditor_create_loop();

	//Initialize handles
	globalvar edtAnimHandlePos, edtAnimHandleNormal, edtAnimIKNormal, edtAnimIKPos;
	edtAnimHandlePos = [0, 0, 0];
	edtAnimHandleNormal = [0, 0, 1];
	edtAnimIKNormal = [0, 0, 1];
	edtAnimIKPos = [0, 0, 0];

	globalvar edtTmlPos, edtTmlMove, edtTmlDoubleclickTimer;
	edtTmlPos = [borderX + 128, borderY - 32, borderX + editWidth * 2 - 16, borderY];
	edtTmlMove = false;
	edtTmlDoubleclickTimer = -1;

	globalvar edtSelNodePos;
	edtSelNodePos = [0, 0, 0];

	globalvar edtLockedNodePosList;
	edtLockedNodePosList = ds_list_create();

	globalvar edtAnimCopiedNode, edtAnimCopiedKeyframe;
	edtAnimCopiedKeyframe = "";
	edtAnimCopiedNode = "";


}
