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
	
	self:Set(5,8,"steel")
	self:Set(4,7,"grass")
	self:Set(8,8,"water")
	
end


function Map:Get(x,y)
	if x < 0 or y < 0 or x >= MapWidth or y >= MapHeight then
		return nil
	end
	
	return self.map[x*MapHeight + y] -- һԪ���뷵��
	
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

-- ����һ�������һ�����Σ����Ƿ����������µķ���
function Map:collideWithBlock(r,x,y)
	local block = self:Get(x,y)
	
	-- ������Χ
	if block == nil then
		return nil
	end
	
	-- ����С��1 ���ǿ��Թ�ȥ��
	if block.damping < 1 then
		return nil
	end
	
	
	if RectIntersect(r,block:GetRect() ) ~= nil then
		return block
	end
	
	return nil
end

function Map:Collide(posx, posy, ex)
	local object = NewRect(posx,posy,ex)

	
	for x = 0 , MapWidth - 1 do
		for y = 0 , MapHeight - 1 do
			
			local b = self:collideWithBlock(object, x, y)
			if b ~= nil then
				return b
			end

		end
	end
	
	return nil
	
end

return Map