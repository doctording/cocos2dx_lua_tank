require "app.Common"
require "app.Camp"

local TankCursor = require("app.TankCursor")
local Map = require("app.Map")

local EditorScene = class("EditorScene", function()
    return display.newScene("EditorScene")
end)


function EditorScene:onEnter()
		local spriteFrameCache = cc.SpriteFrameCache:getInstance()
		spriteFrameCache:addSpriteFrames("res/tanks/tex.plist")
		
		--地图
		self.map = Map.new(self)
		
		self.tank = TankCursor.new(self, "tank_green", self.map)
		
		self.tank:PlaceCursor(MapWidth/2, MapHeight/2)
		
		self:ProcessKeyInput()
end


local editorFileName = "editor.lua"

-- 按键事件处理
function EditorScene:ProcessKeyInput()


		local function keyboardReleased(keyCode,event)

        -- up
        if keyCode == 28 or keyCode == 146 then  -- 146
                self.tank:MoveCursor(0, 1)
        -- down
        elseif keyCode == 29 or keyCode == 142 then -- 142
                self.tank:MoveCursor(0, -1)
        --left
        elseif keyCode == 26 or keyCode == 124 then -- 124
    						self.tank:MoveCursor(-1, 0)
        --right
        elseif keyCode == 27 or keyCode == 127 then -- 127
            		self.tank:MoveCursor(1, 0)
        
        -- j
        elseif keyCode == 133 then 
                self.tank:SwitchBlock(1)
        
        -- k
        elseif keyCode == 134 then
                self.tank:SwitchBlock(-1)
        
        -- F3
        elseif keyCode == 49 then
                self.map:Load(editorFileName)
       --F4
       	elseif keyCode == 50 then
                self.map:Save(editorFileName)
                
        
        end

    end
    
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(keyboardReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)

end


function EditorScene:onExit()
end

return EditorScene
