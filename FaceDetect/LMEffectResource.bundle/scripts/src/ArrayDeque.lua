require "cocos.cocos2d.functions"
local ArrayDeque = class("ArrayDeque")

function ArrayDeque:ctor()
    self.mDeque = {first = 0, last = -1}
end

function ArrayDeque:popFront()
    local first = self.mDeque.first
    if (first > self.mDeque.last) 
    then
        return nil
    end

    local value = self.mDeque[first]
    self.mDeque[first] = nil
    self.mDeque.first = first + 1
    
    return value
end

function ArrayDeque:popBack()
    local last = self.mDeque.last
    if (self.mDeque.first > last)
    then
        return nil
    end

    local value = self.mDeque[last]
    self.mDeque[last] = nil
    self.mDeque.last = last - 1

    return value
end

function ArrayDeque:pushFront(value)
    local first = self.mDeque.first - 1 
    self.mDeque.first = first 
    self.mDeque[first] = value 
end

function ArrayDeque:pushBack(value)
    local last = self.mDeque.last + 1
    self.mDeque.last = last
    self.mDeque[last] = value
end

function ArrayDeque:getSize()
    if self.mDeque.first > self.mDeque.last
    then
        return 0
    else
        return math.abs(self.mDeque.last - self.mDeque.first) + 1 
    end
end

function ArrayDeque:clear()
    local size = self:getSize()
    for i = 1, size, 1
    do
        self:popFront()
    end
end

return ArrayDeque