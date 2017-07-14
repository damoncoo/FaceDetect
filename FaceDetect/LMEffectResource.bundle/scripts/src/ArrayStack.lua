require "cocos.cocos2d.functions"

local ArrayStack = class("ArrayStack")

function ArrayStack:ctor()
    self.mStack = {first = 0, last = -1}
end

function ArrayStack:push(value)
    local last = self.mStack.last + 1
    self.mStack.last = last
    self.mStack[last] = value
end

function ArrayStack:pop()
    local last = self.mStack.last
    if (self.mStack.first > last)
    then
        return nil
    end

    local value = self.mStack[last]
    self.mStack[last] = nil
    self.mStack.last = last - 1

    return value
end

function ArrayStack:getSize()
    if self.mStack.first > self.mStack.last
    then
        return 0
    else
        return math.abs(self.mStack.last - self.mStack.first) + 1 
    end
end

function ArrayStack:clear()
    local size = self:getSize()
    for i = 1, size, 1
    do
        self:pop()
    end
end

return ArrayStack