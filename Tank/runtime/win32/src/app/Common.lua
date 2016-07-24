
cGridSize = 32 --���Ӵ�С
cHalfGrid = cGridSize / 2 

MapWidth = 12
MapHeight = 12

-- ȡ��ֵ����������
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

-- ���� ת cocos2dx����
function Grid2Pos(x,y)
 		local visibleSize = cc.Director:getInstance():getVisibleSize() -- ��ȡ�����ֻ�������Ļ�ߴ�

    local origin = cc.Director:getInstance():getVisibleOrigin() -- ��ȡ�ֻ�������ԭ�������,��Ļ�����Ͻ�

    local finalX = origin.x + visibleSize.width / 2 + x * cGridSize - PosOffsetX
    local finalY = origin.y + visibleSize.height / 2 + y * cGridSize - PosOffsetY

    return finalX,finalY
end


-- cocos2dx���� ת ��������
function Pos2Grid(posx, posy)
 		local visibleSize = cc.Director:getInstance():getVisibleSize() -- ��ȡ�����ֻ�������Ļ�ߴ�

    local origin = cc.Director:getInstance():getVisibleOrigin() -- ��ȡ�ֻ�������ԭ�������,��Ļ�����Ͻ�

    local x = (posx - origin.x - visibleSize.width / 2 + PosOffsetX) / cGridSize
    local y = (posy - origin.y - visibleSize.height / 2 + PosOffsetY) / cGridSize

    return GetIntPart(x + 0.5) , GetIntPart(y + 0.5) 
end
