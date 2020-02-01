local DrawSystem = class("DrawSystem", System)

function DrawSystem:initialize()
    System.initialize(self)
    self.sortedTargets = {}
end

function DrawSystem:draw()
    love.graphics.setColor(255, 255, 255)
    for index, entity in ipairs(self.sortedTargets) do
        local drawable = entity:get("Drawable")

        local x, y = 0, 0
        local angle = 0
        if entity:get("Body") then
            local body = entity:get("Body")
            x, y = body.body:getPosition()
            angle = body:getAngle()
        elseif entity:get("Position") then
            local position = entity:get("Position")
            x = position.x
            y = position.y
        end
        local sx, sy = drawable.sx, drawable.sy
        if entity:get("Circle") then
            local radius = entity:get("Circle").radius*2
            sx = radius/drawable.image:getWidth()
            sy = radius/drawable.image:getHeight()
        end
        love.graphics.draw(drawable.image, x, y, angle, sx, sy, drawable.ox, drawable.oy)
    end
end

function DrawSystem:requires()
    return {"Drawable"}
end

function DrawSystem:addEntity(entity)
    -- Entitys are sorted by Index, therefore we had to overwrite System:addEntity
    self.targets[entity.id] = entity
    self.sortedTargets = table.resetIndice(self.targets)
    table.sort(self.sortedTargets, function(a, b) return a:get("Drawable").index < b:get("Drawable").index end)
end

function DrawSystem:removeEntity(entity)
    -- Entitys are sorted by Index, therefore we had to overwrite System:addEntity
    self.targets[entity.id] = nil
    self.sortedTargets = table.resetIndice(self.targets)
    table.sort(self.sortedTargets, function(a, b) return a:get("Drawable").index < b:get("Drawable").index end)
end

return DrawSystem
