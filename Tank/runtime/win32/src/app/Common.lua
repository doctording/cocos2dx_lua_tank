
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


-- ������ײ
function NewRect(x, y, ex)
	
	-- ex ? ex : 0
	ex = ex and ex or 0
	
	return {
		left = x - cHalfGrid - ex,
		top = y + cHalfGrid + ex,
		right = x + cHalfGrid + ex,
		bottom = y - cHalfGrid - ex,
		
		width = function(self)
			return math.abs(self.right - self.left)
		end,
		
		height = function(self)
			return math.abs(self.bottom - self.top)
		end,
		
		center = function(self)
			return x, y
		end,
		
		tostring = function(self)
			return string.format("%d %d %d %d", self.left, self.top, self.right, selfbottom)
		end,
	}
	
end

-- �жϾ���Ľ��� openGL���� �� cocos����
function RectIntersect(r1,r2)
	
	if r1:width() == 0 or r1:height() == 0 then
		return r2
	end
	
	if r2:width() == 0 or r2:height() == 0 then
		return r1
	end
	
	local left = math.max(r1.left, r2.left)
	if left >= r1.right or left >= r2.right then
		return nil
	end
	
	local right = math.min(r1.right, r2.right)
	if right <= r1.left or right <= r2.left then
		return nil
	end
	
	local top = math.min(r1.top, r2.top)
	if top <= r1.bottom or top <= r2.bottom then
		return nil
	end
	
	local bottom = math.max(r1.bottom, r2.bottom)
	if bottom >= r1.top or bottom >= r2.top then
		return nil
	end	
	
	return NewRect(left,top,right,bottom)
end

-- x y �Ƿ���rect ����
function RectHit(r,x,y)
	return x >= r.left and x <= r.right and y >= r.bottom and y <= r.top
end