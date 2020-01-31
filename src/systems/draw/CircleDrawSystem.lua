local CircleDrawSystem = class("CircleDrawSystem", System)

function CircleDrawSystem:draw()
    for index, entity in pairs(self.targets) do
        love.graphics.setColor(255, 255, 255)
        -- Set the color, if the entity has a color component
        if entity:get("Color") then
            local color = entity:get("Color")
            love.graphics.setColor(color.red, color.green, color.blue)
        end
        local circle = entity:get("DrawableCircle")
        local x, y = entity:get("Body").body:getPosition()
        local mode = "line"
        if circle.fill then
            mode = "fill"
        end
        love.graphics.circle(mode, x, y, circle.radius)
    end
end

function CircleDrawSystem:requires()
    return {"DrawableCircle", "Body"}
end

return CircleDrawSystem
