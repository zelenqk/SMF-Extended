// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
global.buttonWidth = 127;
global.buttonHeight = 16;
global.modulePos = {x:0,y:0};
function modulesStep()
{
	global.modulePos = {x:0, y:0};
	global.rootModule.step();
}
function modulesDraw()
{
	global.modulePos = {x:0, y:0};
	draw_set_font(font_0);
	global.rootModule.draw();
}
function moduleParent(name, pin, offsetX, offsetY) constructor
{
	self.name = name;
	self.contents = [];
	self.children = [];
	self.hidden = false;
	self.xOffset = offsetX;
	self.yOffset = offsetY;
	self.height = 0;
	self.width = global.buttonWidth;
	if (is_struct(pin))
	{
		pin.attach(self);
	}
	
	static attach = function(module)
	{
		//Attaches a module to this module so that it draws directly below
		array_push(children, module);
	}
	
	static addContent = function(index)
	{
		//Add content (for example buttons) to this module
		array_push(contents, index);
	}
	
	static step = function()
	{
		//Check for interactions with the buttons in this module
		if (name != "Root")
		{
			var mx = window_mouse_get_x();
			var my = window_mouse_get_y();
			global.modulePos.x += xOffset;
			global.modulePos.y += yOffset;
			var x1 = global.modulePos.x;
			var y1 = global.modulePos.y;
			if (!hidden)
			{
				var num = array_length(contents);
				for (var i = 0; i < num; i ++)
				{
					var content = contents[i];
					global.modulePos.x += content.xOffset;
					global.modulePos.y += content.yOffset;
					content.check(mx, my);
					global.modulePos.x -= content.xOffset;
				}
			}
			global.modulePos.y += global.buttonHeight + 2;
		}
		//Pass the check along to the module's children
		var num = array_length(children);
		for (var i = 0; i < num; i ++)
		{
			children[i].step();
		}
	}
	
	static draw = function()
	{
		if (name != "Root")
		{
			global.modulePos.x += xOffset;
			global.modulePos.y += yOffset;
			var x1 = global.modulePos.x;
			var y1 = global.modulePos.y;
			
			//Draw this module
			global.modulePos.x = x1;
			global.modulePos.y = y1;
			if (!hidden)
			{
				var num = array_length(contents);
				for (var i = 0; i < num; i ++)
				{
					var content = contents[i];
					global.modulePos.x += content.xOffset;
					global.modulePos.y += content.yOffset;
					content.draw();
					global.modulePos.x -= content.xOffset;
				}
			}
			draw_roundrect_ext(x1, y1 + 1, x1 + global.buttonWidth, global.modulePos.y + global.buttonHeight, 5, 5, true);
			global.modulePos.y += global.buttonHeight + 2;
		}
		//Pass the check along to the module's children
		var num = array_length(children);
		for (var i = 0; i < num; i ++)
		{
			children[i].draw();
		}
	}
	
	
	if (name != "Root")
	{
		addContent(new category(name));
	}
}
function buttonParent(width = global.buttonWidth, height = global.buttonHeight, xOffset = 0, yOffset = global.buttonHeight) constructor
{
	self.xOffset = xOffset;
	self.yOffset = yOffset;
	self.width = width;
	self.height = height;
	self.sprite = sButton;
	self.index = 0;
	
	static check = function(x, y)
	{
		if (x > global.modulePos.x && y > global.modulePos.y && x < global.modulePos.x + self.width && y < global.modulePos.y + self.height)
		{
			if mouse_check_button(mb_left)
			{
				index = 1;
			}
		}
	}
	
	static draw = function()
	{
		draw_sprite(sprite, index, 1 + global.modulePos.x, global.modulePos.y);
	}
}

function category(text, width = global.buttonWidth, height = global.buttonHeight, xOffset = 0, yOffset = global.buttonHeight) : buttonParent(width, height, xOffset, yOffset) constructor
{
	self.text = text;
	
	static draw = function()
	{
		draw_set_halign(fa_middle);
		draw_set_valign(fa_top);
		draw_text(global.modulePos.x + global.buttonWidth / 2, global.modulePos.y + 3, text);
		draw_set_halign(fa_left);
	}
}


global.rootModule = new moduleParent("Root", -1, 0, 0);