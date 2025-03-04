//align/justify
#macro fa_spacebetween 12
#macro fa_spacearound 14


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
	
	"justifyContent": fa_none,
	"alignItems": fa_none,
	
	//margin
	"marginTop": 0,
	"marginBottom": 0,
	"marginLeft": 0,
	"marginRight": 0,
	
	
	//max/min size
	"maxWidth": infinity,
	"maxHeight": infinity,
	
	"minHeight": -1,
	"minWidth": -1,
	
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
	"parent": self,
	"child": false,
	"hover": false,
	"mouse": noone,
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
	
	var containerNames = variable_struct_get_names(container);
	
	for(var i = 0; i < array_length(containerNames); i++){
		var name = containerNames[i];
		
		switch (name){
		case "marginH":
			container.marginLeft = container.marginH;
			container.marginRight = container.marginH;
			break;
		case "marginV":
			container.marginTop = container.marginV;
			container.marginBottom = container.marginV;
			break;
		case "margin":
			container.marginTop = container.margin;
			container.marginBottom = container.margin;
			container.marginLeft = container.margin;
			container.marginRight = container.margin;
			break;
		}	
	}
	
	for(var i = 0; i < baseContainerNamesN; i++){
		var name = baseContainerNames[i];
		if (container[$ name] == undefined) container[$ name] = baseContainer[$ name];
	}
}