local DevilControlSystem = class("DevilControlSystem", System)

function DevilControlSystem:update(dt)
    for index, entity in pairs(self.targets) do
        if love.keyboard.isDown('w') then
            entity:get("Body").body:applyLinearImpulse(0, -10)
        end
        if love.keyboard.isDown('s') then
            entity:get("Body").body:applyLinearImpulse(0, 10)
        end
        if love.keyboard.isDown('a') then
            entity:get("Body").body:applyLinearImpulse(-10, 0)
        end
        if love.keyboard.isDown('d') then
            entity:get("Body").body:applyLinearImpulse(10, 0)
        end

        --
        -- , 'a', 's', 'd') then
        --
        --
        --
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

function DevilControlSystem:requires()
    return {"Devil"}
end

return DevilControlSystem
