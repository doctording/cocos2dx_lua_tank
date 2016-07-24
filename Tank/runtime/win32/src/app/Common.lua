
cGridSize = 32 --格子大小
cHalfGrid = cGridSize / 2 

MapWidth = 12
MapHeight = 12

-- 取数值的整数部分
function GetIntPart(x)

	if x <= 0 then
		return math.ceil(x)
	end
	
	if math.ceil(x) == x then
		x = math.ceil(x)
	else
		x = math.ceil(x) - 1
	end

	return x
end

local PosOffsetX = cGridSize * MapWidth * 0.5 - cHalfGrid
local PosOffsetY = cGridSize * MapHeight * 0.5 - cHalfGrid

-- 格子 转 cocos2dx坐标
function Grid2Pos(x,y)
 		local visibleSize = cc.Director:getInstance():getVisibleSize() -- 获取整个手机可视屏幕尺寸

    local origin = cc.Director:getInstance():getVisibleOrigin() -- 获取手机可视屏原点的坐标,屏幕的左上角

    local finalX = origin.x + visibleSize.width / 2 + x * cGridSize - PosOffsetX
    local finalY = origin.y + visibleSize.height / 2 + y * cGridSize - PosOffsetY

    return finalX,finalY
end


-- cocos2dx坐标 转 格子坐标
function Pos2Grid(posx, posy)
 		local visibleSize = cc.Director:getInstance():getVisibleSize() -- 获取整个手机可视屏幕尺寸

    local origin = cc.Director:getInstance():getVisibleOrigin() -- 获取手机可视屏原点的坐标,屏幕的左上角

    local x = (posx - origin.x - visibleSize.width / 2 + PosOffsetX) / cGridSize
    local y = (posy - origin.y - visibleSize.height / 2 + PosOffsetY) / cGridSize

    return GetIntPart(x + 0.5) , GetIntPart(y + 0.5) 
end
