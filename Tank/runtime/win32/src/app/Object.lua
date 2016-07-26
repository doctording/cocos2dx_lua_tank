require "app.Common"
require "app.Camp"

local Object = class("Object")

function Object:ctor(node,camp)
	
	Camp_Add(camp,self)
	
	self.sp = cc.Sprite:create()
	self.node = node
	self.node:addChild(self.sp)
	
	-- ���º���
	if self.Update ~= nil then
		self.updateFuncID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(
			function() 
				self:Update() 
			end, 0, false)
	end
	
end


function Object:Alive()

	return self.sp ~= nil
	
end

function Object:UpdatePosition(callback)
	
	local delta = cc.Director:getInstance():getDeltaTime() -- ���ļ��ʱ��
	
	-- ��һ���ƶ�λ��
	local nextPosX = self.sp:getPositionX() + self.dx * delta
	local nextPosY = self.sp:getPositionY() + self.dy * delta
	
	if callback(nextPosX,nextPosY) then
		return
	end
	
	-- ��ײ���
	if self.dx ~= 0 then
		self.sp:setPositionX(nextPosX)
	end
	if self.dy ~= 0 then
		self.sp:setPositionY(nextPosY)
	end
		
end


function Object:Destroy()
	
	Camp_Remove(self)
	
	if self.updateFuncID then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.updateFuncID)
	end
	
	self.node:removeChild(self.sp)
	self.sp = nil
	
end

-- ȡ��λ��
function Object:GetPos()
	return Pos2Grid(self.sp:getPositionX(), self.sp:getPositionY())
end

-- ����λ��
function Object:SetPos(x,y)
	local posx,posy = Grid2Pos(x,y)
	self.sp:setPosition(posx, posy)
end


function Object:GetRect()
	return NewRect(self.sp:getPositionX(), self.sp:getPositionY())
end

--�ӵ�Ҫͣ����
function Object:Stop()
	self.dx = 0
	self.dy = 0
end

-- ������ײ
function Object:CheckCollide(posx, posy, ex)
	local selfrect = NewRect(posx,posy,ex)
	
	return Camp_IterateAll(function(obj)
			
			-- �ų��Լ�
			if obj == self then
				return false
			end
			
			local tgtrect = obj:GetRect()
			
			if RectIntersect(selfrect, tgtrect) ~= nil then
				return obj
			end
			
	end)
end

-- �ӵ���ײ
function Object:CheckHit(posx, posy)
	
	return Camp_IterateHostile(self.camp,function(obj)
			
			local tgtrect = obj:GetRect()
			
			if RectHit(tgtrect, posx, posy) then
				return obj
			end
	end)
	
end

return Object