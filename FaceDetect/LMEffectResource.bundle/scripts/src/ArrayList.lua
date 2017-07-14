require "cocos.cocos2d.functions"
local ArrayList = class("ArrayList")

function ArrayList:ctor()
    self.mList = {first = 0, last = -1}
end

function ArrayList:get(index)
    if (index < self.mList.first or index > self.mList.last)
    then
        return nil
    end

    return self.mList[index]
end

function ArrayList:remove(index)
    if (index < self.mList.first or index > self.mList.last)
    then
        return nil
    end

    local removed = self.mList[index]
    self.mList[index] = nil
    local disFirst = index - self.mList.first
    local disLast = self.mList.last - index
    if (disFirst > disLast)
    then
            --ToDO
    else

    end

    return removed
end

function ArrayList:getSize()
    if self.mList.first > self.mList.last
    then
        return 0
    else
        return math.abs(self.mList.last - self.mList.first) + 1 
    end
end

function ArrayList:clear()
    local size = self:getSize()
    for i = 1, size, 1
    do
        self:popFront()
    end
end

return ArrayList