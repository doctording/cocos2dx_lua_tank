local Object = require("app.Object")
local SpriteAnim = require("app.SpriteAnim")

local Tank = class("Tank",Object)

function Tank:ctor(node,name)
	
	Tank.super.ctor(self,node) --调用父类的构造函数
	self.node = node
	
	-- x y 方向上的移动
	self.dx = 0
	self.dy = 0
	self.speed = 100
	
	self.dir = "up"
	self.spAnim = SpriteAnim.new(self.sp)
	
	-- 定义动画
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

function Tank:Update()
	self:UpdatePosition(function(nextPosX,nextPosY)
		
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
	
	sel.spAnim:Destroy()
	Tank.super.Destroy(self)
	
end

return Tank