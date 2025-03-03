
//display
#macro fixed 0
#macro flex 1

//overflow
#macro fa_allow 0

//direction
#macro column 0
#macro row 1

globalvar baseContainer, baseContainerNames, baseContainerNamesN, resetFontEffects;

baseContainer = {
	//container properties
	"width": 0,
	"height": 0,
	"background": c_black,
	"transparency": 1,
	"direction": column,
	"overflow": fa_allow,
	"offsetX": 0,
	"offsetY": 0,
	"display": fixed,
	"draw": true,
	
	//flex
	"theight": 0,
	"twidth": 0,
	
	//text properties
	"alpha": 1,
	"textOffsetX": 0,
	"textOffsetY": 0,
	"halign": fa_left,
	"valign": fa_top,
	"text": "",
	"color": c_white,
	"font": -1,
	"fontSize": 20,
	"fontEffects": {},
	
	///////effects properties
	
	//overflow
	"boundary": {
		"x": 0,
		"y": 0,
		"width": 0,
		"height": 0,
	},
	"hidden": false,
	"cookie": noone,
	
	//functionality properties
	"hover": false,
	"step": function(){
		
	},
	"content": [],
}

baseContainerNames = variable_struct_get_names(baseContainer);
baseContainerNamesN = array_length(baseContainerNames);

resetFontEffects = {
	dropShadowEnable: false,
	dropShadowSoftness: 0,
	dropShadowOffsetX: 0,
	dropShadowOffsetY: 0,
	dropShadowAlpha: 0,
	outlineEnable: 0,
	outlineDistance: 0,
	outlineColour: c_black,
	glowEnable: 0,
	glowEnd: 0,
	glowColour: 0,
	glowAlpha: 0
}

function bake_container(container){
	
	for(var i = 0; i < baseContainerNamesN; i++){
		var name = baseContainerNames[i];
		
		if (container[$ name] == undefined) container[$ name] = baseContainer[$ name];
	}
}