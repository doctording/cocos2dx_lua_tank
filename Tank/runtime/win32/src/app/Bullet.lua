require("app.Map")
local SpriteAnim = require("app.SpriteAnim")
local Object = require("app.Object")

local Bullet = class("Bullet", Object)

-- �ӵ��ƶ�λ�õķ��� �� ����tank�ķ�����ٶ�
local function getDeltaByDir(dir,speed)
	
	if dir == "left" then
		return -speed, 0
	elseif dir == "right" then
		return speed,0
	elseif dir == "up" then
		return 0,speed
	elseif dir == "down" then
		return 0,-speed
	end
	
	return 0, 0
end	

function Bullet:ctor(node, map, type, obj, dir)
	
	Bullet.super.ctor(self,node, obj.camp .. ".bullet")
	
	self.dx,self.dy = getDeltaByDir(dir,200)
	self.map = map;
	
	-- �ӷ���λ�ó��� 
	self.sp:setPositionX( obj.sp:getPositionX() )
	self.sp:setPositionY( obj.sp:getPositionY() )
	
	self.spAnim = SpriteAnim.new(self.sp)
	
	self.spAnim:Define(nil,"bullet", 2, 0.1)
	self.spAnim:Define(nil,"explode", 3, 0.1, true) --��ըһ��
	
	self.spAnim:SetFrame("bullet", type)
	
end

-- �ӵ����º���
function Bullet:Update()
	
	self:UpdatePosition(function(nextPosX,nextPosY)
		
			local hit
			-- �ж������߳���
			local block, out = self.map:Hit(nextPosX, nextPosY)
			-- �������� ���� ����
			if block or out then
				hit = "explode"
				
				if block and block.breakable then
						
						-- ��Ҫ���׵��������ӵ��Ǵ��׵� or ����Ҫ���׵�  ��Ҫ�ƻ�
						if (block.needAp and self.type == 1) or not block.needAp then
							
							block:Break()
							
						end					
				end
				
			else
					
					local target = self:CheckHit(nextPosX,nextPosY)
					
					if target then
						target:Destroy()
						
						-- �ж϶�������
						if iskindof(target, "Bullet") then
							hit = "disappear"
							target.spAnim:Destroy()
						else
							hit = "explode"
						end
					end
			end
				
				if hit then
				
					self:Stop()
					
					if hit == "explode" then
						self:Explode()
					elseif hit == "disappear" then
						self.spAnim:Destroy()
						self:Destroy()
					end
					
				end
			
			return false
		
	end)
	
end


function Bullet:Explode()
	self.spAnim:Play("explode",function()
		self:Destroy()
	end)
end

return Bullet