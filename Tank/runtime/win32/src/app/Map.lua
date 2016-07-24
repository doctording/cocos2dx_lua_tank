require "app.Common"

local Map = class("Map")

local Block = require("app.Block")

function Map:ctor(node)
	
	self.map = {}
	self.node = node
	
	for x = 0 , MapWidth - 1 do
		for y = 0 , MapHeight - 1 do
			
			if x == 0 or x == MapWidth - 1 or y == 0 or y == MapHeight - 1 then
				self:Set(x,y,"steel")
			else
				self:Set(x,y,"mud")
			end 
			
		end
	end
	
end


function Map:Get(x,y)
	if x < 0 or y < 0 or x >= MapWidth or y >= MapHeight then
		return nil
	end
	
	return self.map[x*MapHeight + y] -- Ò»Ôª±àÂë·µ»Ø
	
end

function Map:Set(x, y, type)
	local block = self.map[x * MapHeight + y]
	if block == nil then
		block = Block.new(self.node)
	end
	
	block:SetPos(x,y)
	self.map[x*MapHeight + y] = block
	block:Reset(type)
	block.x = x
	block.y = y 
	
end

return Map