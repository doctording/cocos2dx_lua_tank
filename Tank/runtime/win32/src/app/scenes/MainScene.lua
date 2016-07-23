local Tank = require("app.Tank")
local PlayerTank = require("app.PlayerTank")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
   --[[
    cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)
        ]]
end

function MainScene:onEnter()
		local spriteFrameCache = cc.SpriteFrameCache:getInstance()
		spriteFrameCache:addSpriteFrames("res/tanks/tex.plist")
		
		--self.tank = Tank.new(self, "tank_green")
		self.tank = PlayerTank.new(self, "tank_green")
		
		local size = cc.Director:getInstance():getWinSize()
		self.tank.sp:setPosition(size.width/2,size.height/2)
		
		self:ProcessKeyInput()
end


-- 按键事件处理
function MainScene:ProcessKeyInput()

    local function keyboardPressed(keyCode,event)

        -- up
        if keyCode == 28 then -- 146
                print("up")
                --self.tank:SetDir("up")
                self.tank:MoveBegin("up")
        -- down
        elseif keyCode == 29 then -- 142
                print("down")
                -- self.tank:SetDir("down")
                self.tank:MoveBegin("down")
        --left
        elseif keyCode == 26 then -- 124
                print("left")
                -- self.tank:SetDir("left")
                self.tank:MoveBegin("left")
        --right
        elseif keyCode == 27 then -- 127
                print("right")
                -- self.tank:SetDir("right")
                self.tank:MoveBegin("right")
        end

    end

	local function keyboardReleased(keyCode,event)

        -- up
        if keyCode == 28 then -- 146
                print("up")
                --self.tank:SetDir("up")
                self.tank:MoveEnd("up")
        -- down
        elseif keyCode == 29 then -- 142
                print("down")
                -- self.tank:SetDir("down")
                self.tank:MoveEnd("down")
        --left
        elseif keyCode == 26 then -- 124
                print("left")
                -- self.tank:SetDir("left")
                self.tank:MoveEnd("left")
        --right
        elseif keyCode == 27 then -- 127
                print("right")
                -- self.tank:SetDir("right")
                self.tank:MoveEnd("right")
        end

    end
    
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(keyboardPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(keyboardReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)

end


function MainScene:onExit()
end

return MainScene
