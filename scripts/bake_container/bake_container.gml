globalvar baseContainer, baseContainerNames, baseContainerNum;

#macro fixed 0
#macro flex 1

#macro row 0
#macro column 1

#macro relative 0
#macro absolute 1

baseContainer = {
	"width": 0,
	"height": 0,
	"background": c_white,
	"parent": self,

	//text stuff
	"text": "",
	"fontSize": 20,
	"font": - 1,
	"color": c_black,
	"halign": fa_left,
	"valign": fa_top,
	"alpha": 1,
	"position": relative,
	"textOffsetX": 0,
	"textOffsetY": 0,
	"fontEffects": {},
	
	
	//margin
	"marginTop": 0,
	"marginBottom": 0,
	"marginLeft": 0,
	"marginRight": 0,
	
	//render type variables
	"draw": true,
	"drawContent": true,
	"overflow": fa_none,
	"display": fixed,
	"direction": row,
	"offsetx": 0,
	"offsety": 0,
	"contentOffsetX": 0,
	"contentOffsetY": 0,

	//do not set these variables
	"content": [],	//this is just an array of other elements/container you can use this one
	"hovering": false,
	"tx": 0,
	"ty": 0,
	"twidth": 0,
	"theight": 0,
	"wrapped": false,
	"boundaries": {
		"x": 0,
		"y": 0,
		"width": 0,
		"height": 0,
	},
	"baked": true,
}

baseContainerNames = variable_struct_get_names(baseContainer);
baseContainerNum = array_length(baseContainerNames);

function bake_container(container){
	for(var i = 0; i < baseContainerNum; i++){
		var name = baseContainerNames[i];
		
		switch (name){
		case "margin":
			container.marginTop = container.margin;
			container.marginBottom = container.margin;
			container.marginLeft = container.margin;
			container.marginRight = container.margin;
			break;
		case "marginH":
			container.marginLeft = container.marginH;
			container.marginRight = container.marginH;
		case "marginV":
			container.marginTop = container.marginV;
			container.marginBottom = container.marginV;
			break;
		default:
			if (container[$ name] == undefined) container[$ name] = baseContainer[$ name];
			break;
		}
	}
	
	return container;
}