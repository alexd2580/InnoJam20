local CageSystem = class("CageSystem", System)
local Vector = require("src/helper/Vector")

function CageSystem:update(dt)
    for index, entity in pairs(self.targets) do
        local body = entity:get("Body").body
        local posX, posY = body:getPosition()
        local cage = entity:get("Caged")

        local velX, velY = body:getLinearVelocity()
        if posX > 1920 - cage.offset_x then
            body:applyLinearImpulse(-200, 0)
        elseif posX < 0 + cage.offset_x then
            body:applyLinearImpulse(200, 0)
        end

        if posY > 1080 - cage.offset_y then
            body:applyLinearImpulse(0, -200)
        elseif posY < 0 + cage.offset_y then
            body:applyLinearImpulse(0, 200)
        end
    end
end

function CageSystem:requires()
    return {"Caged"}
end

return CageSystem
