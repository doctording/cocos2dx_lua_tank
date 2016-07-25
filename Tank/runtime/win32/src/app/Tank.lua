local Object = require("app.Object")
local SpriteAnim = require("app.SpriteAnim")

local Bullet = require("app.Bullet")

local Tank = class("Tank",Object)

function Tank:ctor(node,name,map,camp)
	
	Tank.super.ctor(self,node,camp) --���ø���Ĺ��캯��
	self.node = node
	self.map = map
	
	-- x y �����ϵ��ƶ�
	self.dx = 0
	self.dy = 0
	self.speed = 100
	
	self.OnCollide = nil -- �ص�����
	
	self.dir = "up"
	self.spAnim = SpriteAnim.new(self.sp)
	
	-- ���嶯��
	self.spAnim:Define("run", name, 8, 0.1)
	
	self.spAnim:SetFrame("run", 0)

--[[	
	local size = cc.Director:getInstance():getWinSize()
	self.sp:setPosition(size.width/2,size.height/2)
	
	local spriteFrameCache = cc.SpriteFrameCache:getInstance()
	local frame = spriteFrameCache:getSpriteFrame("tank_green_run0.png")
	self.sp:setSpriteFrame(frame)
	]]
	
end

-- ���� �����ײ
function Tank:Update()
	self:UpdatePosition(function(nextPosX,nextPosY)
		
			local hit
			hit = self.map:Collide(nextPosX,nextPosY,-5)
			
			-- ������ײ
			if hit == nil then
				hit = self:CheckCollide(nextPosX,nextPosY)
			end
			
			if hit and self.OnCollide then
				self.OnCollide(hit)
			end
			return hit
		
	end)
end


function Tank:SetDir(dir)
	if dir == nil then
		self.dx = 0
		self.dy = 0
		self.spAnim:Stop("run")
		return
	elseif dir == "left" then
		self.sp:setRotation(-90)
		self.spAnim:Play("run")
		self.dx = -self.speed
		self.dy = 0		
	
	elseif dir == "right" then
		self.dx = self.speed
		self.dy = 0
		
		self.sp:setRotation(90)
		self.spAnim:Play("run")
		
	elseif dir == "up" then
		self.dx = 0
		self.dy = self.speed
		
		self.sp:setRotation(0)
		self.spAnim:Play("run")
		
	elseif dir == "down" then
			self.dx = 0
		  self.dy = -self.speed
	
		self.sp:setRotation(180)
		self.spAnim:Play("run")
		
	end
	
	self.dir = dir
	
end


function Tank:Destroy()
	
	self.spAnim:Destroy()
	Tank.super.Destroy(self)
	
end

function Tank:Fire()
	
	if self.bullet ~= nil and self.bullet:Alive() then
		return
	end
	
	self.bullet = Bullet.new(self.node, self.map, 0 , self, self.dir)
	
end


return Tank