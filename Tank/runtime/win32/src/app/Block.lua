local Object = require("app.Object")

local Block = class("Block", Object)

local MaxBreakableStep = 3

-- ��������Ա�
local blockPropertyTable = {
	
	-- ����
	["mud"] = {
		["hp"] = 0, --Ѫ��
		["needAp"] = false, --�Ƿ񴩼׵�
 		["damping"] = 0.2 , --����
 		["breakable"] = false, -- �Ƿ���ƻ�
	},
	
		--·��
	["road"] = {
		["hp"] = 0, --Ѫ��
		["needAp"] = false, --�Ƿ񴩼׵�
 		["damping"] = 0 ,--����
 		["breakable"] = false, -- �Ƿ���ƻ�
	},
	
	--��
	["grass"] = {
		["hp"] = 0, --Ѫ��
		["needAp"] = false, --�Ƿ񴩼׵�
 		["damping"] = 0 ,--����
 		["breakable"] = false ,-- �Ƿ���ƻ�
	},
	
	--ˮ
	["water"] = {
		["hp"] = 0, --Ѫ��
		["needAp"] = false, --�Ƿ񴩼׵�
 		["damping"] = 1, --����
 		["breakable"] = false, -- �Ƿ���ƻ�
	},
	
	--ש��
	["brick"] = {
		["hp"] = MaxBreakableStep, --Ѫ��
		["needAp"] = false, --�Ƿ񴩼׵�
 		["damping"] = 1, --����
 		["breakable"] = true, -- �Ƿ���ƻ�
	},
	
		-- ����
	["steel"] = {
		["hp"] = MaxBreakableStep, --Ѫ��
		["needAp"] = false, --�Ƿ񴩼׵�
 		["damping"] = 1, --����
		["hp"] = MaxBreakableStep, --Ѫ��
		["needAp"] = true, --�Ƿ񴩼׵�
 		["damping"] = 1, --����
 		["breakable"] = true, -- �Ƿ���ƻ�
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
			self.sp:setLocalZOrder(10) -- ����̹�˵�����
			self.sp:setOpacity(200) -- ͸����
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