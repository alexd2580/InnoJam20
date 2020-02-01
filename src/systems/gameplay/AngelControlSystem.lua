local playerControls = require("helper/playerControls")

local AngelControlSystem = class("AngelControlSystem", System)

function AngelControlSystem:update(dt)
    for index, entity in pairs(self.targets) do
        local body = entity:get("Body").body
        playerControls.applyImpulseFromInput(body, "up", "down", "left", "right")
        playerControls.addGravityComponents(entity, "m", "n")
    end
end

function AngelControlSystem:requires()
    return {"Angel", "Body"}
end

return AngelControlSystem
