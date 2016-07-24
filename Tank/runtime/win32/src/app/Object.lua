require "app.Common"

local Object = class("Object")

function Object:ctor(node)
	
	self.sp = cc.Sprite:create()
	self.node = node
	self.node:addChild(self.sp)
	
	-- 更新函数
	if self.Update ~= nil then
		self.updateFuncID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(
			function() self:Update() end, 0 ,false)
	end
	
end


function Object:Alive()

	return self.sp ~= nil
	
end

function Object:UpdatePosition(callback)
	
	local delta = cc.Director:getInstance():getDeltaTime() -- 征的间隔时间
	
	-- 下一个移动位置
	local nextPosX = self.sp:getPositionX() + self.dx * delta
	local nextPosY = self.sp:getPositionY() + self.dy * delta
	
	if callback(nextPosX,nextPosY) then
		return
	end
	
	-- 碰撞检测
	if self.dx ~= 0 then
		self.sp:setPositionX(nextPosX)
	end
	if self.dy ~= 0 then
		self.sp:setPositionY(nextPosY)
	end
		
end


function Object:Destroy()
	
	if self.updateFuncID then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.updateFuncID)
	end
	
	self.node:removeChild(self.sp)
	self.sp = nil
	
end

-- 取得位置
function Object:GetPos()
	return Pos2Grid(self.sp:getPositionX(), self.sp:getPositionY())
end

-- 设置位置
function Object:SetPos(x,y)
	local posx,posy = Grid2Pos(x,y)
	self.sp:setPosition(posx, posy)
end

return Object