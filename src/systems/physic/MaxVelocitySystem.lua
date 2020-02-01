local MaxVelocitySystem = class("MaxVelocitySystem", System)
local Vector = require("helper/Vector")

function MaxVelocitySystem:update(dt)
    for index, entity in pairs(self.targets) do
        local body = entity:get("Body").body
        local maxVelocity = entity:get("MaxVelocity").velocity
        vx, vy = body:getLinearVelocity()
        v = math.sqrt(vx * vx + vy * vy)
        if v > maxVelocity then
            body:setLinearVelocity(vx / v * maxVelocity, vy / v * maxVelocity)
        end
    end
end

function MaxVelocitySystem:requires()
    return {"MaxVelocity"}
end

return MaxVelocitySystem
