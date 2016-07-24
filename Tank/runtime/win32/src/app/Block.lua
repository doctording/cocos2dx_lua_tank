local Object = require("app.Object")

local Block = class("Block", Object)

local MaxBreakableStep = 3

-- 方块的属性表
local blockPropertyTable = {
	
	-- 泥土
	["mud"] = {
		["hp"] = 0, --血量
		["needAp"] = false, --是否穿甲弹
 		["damping"] = 0.2 , --阻尼
 		["breakable"] = false, -- 是否可破坏
	},
	
		--路面
	["road"] = {
		["hp"] = 0, --血量
		["needAp"] = false, --是否穿甲弹
 		["damping"] = 0 ,--阻尼
 		["breakable"] = false, -- 是否可破坏
	},
	
	--草
	["grass"] = {
		["hp"] = 0, --血量
		["needAp"] = false, --是否穿甲弹
 		["damping"] = 0 ,--阻尼
 		["breakable"] = false ,-- 是否可破坏
	},
	
	--水
	["water"] = {
		["hp"] = 0, --血量
		["needAp"] = false, --是否穿甲弹
 		["damping"] = 1, --阻尼
 		["breakable"] = false, -- 是否可破坏
	},
	
	--砖块
	["brick"] = {
		["hp"] = MaxBreakableStep, --血量
		["needAp"] = false, --是否穿甲弹
 		["damping"] = 1, --阻尼
 		["breakable"] = true, -- 是否可破坏
	},
	
		-- 钢铁
	["steel"] = {
		["hp"] = MaxBreakableStep, --血量
		["needAp"] = false, --是否穿甲弹
 		["damping"] = 1, --阻尼
		["hp"] = MaxBreakableStep, --血量
		["needAp"] = true, --是否穿甲弹
 		["damping"] = 1, --阻尼
 		["breakable"] = true, -- 是否可破坏
	},
	
}

function Block:ctor(node)

	Block.super.ctor(self,node)
	
end

function Block:Break()
	
	if not self.breakable then
		return
	end
	
	self.hp = self.hp - 1
	
	if self.hp < 0 then
		self:Reset("mud")
	else
		self:updateImage()
	end
	
end
	
function Block:updateImage()
	
	local spriteFrameCache = cc.SpriteFrameCache:getInstance()
	
	local spriteName
	
	if self.breakable then
		spriteName = string.format("%s%d.png",self.type, MaxBreakableStep - self.hp)
	else		
		spriteName = string.format("%s.png",self.type)
	end
	
	local frame = spriteFrameCache:getSpriteFrame(spriteName)
	
	if frame == nil then
		print("sprite frame not found",self.type)
	else
		self.sp:setSpriteFrame(frame)
		
		if self.type == "grass" then
			self.sp:setLocalZOrder(10) -- 草在坦克的上面
			setl.sp:setOpacity(200) -- 透明度
		else
			self.sp:setLocalZOrder(0)
			self.sp:setOpacity(255)
		end
		
	end
		
end

function Block:Reset(type)
	local t = blockPropertyTable[type]
	
	assert(t)
	
	for k,d in pairs(t) do
		self[k] = d 
	end
	
	self.type = type
	
	self:updateImage()
end

return Block