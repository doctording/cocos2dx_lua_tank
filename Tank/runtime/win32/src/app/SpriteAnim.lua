local SpriteAnim = class("SpriteAnim")

function SpriteAnim:ctor(sp)
	
	-- ������
	self.anim = {}
	self.sp = sp

end

-- ���þ����һ��֡
local function setFrame(sp,def,index)
		if sp == nil then
			return
		end
		
		local spriteFrameCache = cc.SpriteFrameCache:getInstance()
		
		local final
		
		if def.name ~= nil then --����֡
		
			final = string.format("%s_%s%d.png", def.spname, def.name, index)
		
		else -- ��������֡
		
			final = string.format("%s%d.png", def.spname, index)
			
		end
		
		local frame = spriteFrameCache:getSpriteFrame(final)
		
		if frame == nil then
			printf("frame not found", name)
			return 
		end
		
		sp:setSpriteFrame(frame)
		
end


function SpriteAnim:Define(name,spname,frameCount,interval,once)
	
	local spriteFrameCache = cc.SpriteFrameCache:getInstance()
	
	local def = {
		["currFrame"] = 0,
		["running"] = false,
		["frameCount"] = frameCount,
		["spname"] = spname,
		["name"] = name,
		["once"] = once,
		["interval"] = interval,
		["advanceFrame"] = function(defSelf)
						
						defSelf.currFrame = defSelf.currFrame + 1
						
						if defSelf.currFrame >= defSelf.frameCount then
								defSelf.currFrame = 0
								return false
						end
						return true
				end,
		
	}
	
	-- ��������
	if name == nil then
		self.anim[spname] = def
	else
		--������ ������֡
		self.anim[name] = def
	end
	
end



function SpriteAnim:SetFrame(name,index)
	local def = self.anim[name]
	
	if def == nil then
		return
	end
	
	setFrame(self.sp, def, index)
end


function SpriteAnim:Play(name,callback)
	
	local def = self.anim[name]
	if def == nil then
		return
	end
	
	if def.shid == nil then
		def.shid = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
			-- ���¶������߼�
			if def.running then
			
					if def:advanceFrame() then
					
						setFrame(self.sp, def, def.currFrame)
						
					elseif def.once then -- ����ֻ����һ��
					
							 def.running = false
							 cc.Director:getInstance():getScheduler():unscheduleScriptEntry(def.shid)
							 def.shid = nil
							 
							 if callback ~= nil then
							 	callback()
							 end
					
						
					end
			end
			
		end, def.interval, false)
	
	end
	
	def.running = true
end


function SpriteAnim:Stop()
	local def = self.anim[name]
	if def == nil then
		return
	end
	
	def.running = false
end

function SpriteAnim:Destroy()

	for name, def in pairs(self.anim) do
		if def.shid then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(def.shid)
		end
	end
	
	self.sp = nil
end

return SpriteAnim