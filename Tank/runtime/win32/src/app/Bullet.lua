require("app.Map")
local SpriteAnim = require("app.SpriteAnim")
local Object = require("app.Object")

local Bullet = class("Bullet", Object)

-- 子弹移动位置的分量 ， 根据tank的方向和速度
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
	
	-- 从发射位置出现 
	self.sp:setPositionX( obj.sp:getPositionX() )
	self.sp:setPositionY( obj.sp:getPositionY() )
	
	self.spAnim = SpriteAnim.new(self.sp)
	
	self.spAnim:Define(nil,"bullet", 2, 0.1)
	self.spAnim:Define(nil,"explode", 3, 0.1, true) --爆炸一次
	
	self.spAnim:SetFrame("bullet", type)
	
end

-- 子弹更新函数
function Bullet:Update()
	
	self:UpdatePosition(function(nextPosX,nextPosY)
		
			local hit
			-- 有东西或者出界
			local block, out = self.map:Hit(nextPosX, nextPosY)
			-- 碰到方块 或者 出界
			if block or out then
				hit = "explode"
				
				if block and block.breakable then
						
						-- 需要穿甲弹，并且子弹是穿甲弹 or 不需要穿甲弹  需要破坏
						if (block.needAp and self.type == 1) or not block.needAp then
							
							block:Break()
							
						end					
				end
				
			else
					
					local target = self:CheckHit(nextPosX,nextPosY)
					
					if target then
						target:Destroy()
						
						-- 判断对象类型
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