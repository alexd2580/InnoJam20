local AngelControlSystem = class("AngelControlSystem", System)

function AngelControlSystem:update(dt)
    for index, entity in pairs(self.targets) do
        if love.keyboard.isDown('up') then
            entity:get("Body").body:applyLinearImpulse(0, -10)
        end
        if love.keyboard.isDown('down') then
            entity:get("Body").body:applyLinearImpulse(0, 10)
        end
        if love.keyboard.isDown('left') then
            entity:get("Body").body:applyLinearImpulse(-10, 0)
        end
        if love.keyboard.isDown('right') then
            entity:get("Body").body:applyLinearImpulse(10, 0)
        end

        -- love.graphics.setColor(255, 255, 255)
        -- -- Set the color, if the entity has a color component
        -- if entity:get("Color") then
        --     local color = entity:get("Color")
        --     love.graphics.setColor(color.red, color.green, color.blue)
        -- end
        -- local circle = entity:get("DrawableCircle")
        -- local x, y = entity:get("Body").body:getPosition()
        -- local mode = "line"
        -- if circle.fill then
        --     mode = "fill"
        -- end
        -- love.graphics.circle(mode, x, y, circle.radius)
    end
end

function AngelControlSystem:requires()
    return {"Angel"}
end

return AngelControlSystem
