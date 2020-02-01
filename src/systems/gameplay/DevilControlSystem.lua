local playerControls = require("helper/playerControls")

local DevilControlSystem = class("DevilControlSystem", System)

function DevilControlSystem:update(dt)
    for index, entity in pairs(self.targets) do
        local body = entity:get("Body").body
        playerControls.applyImpulseFromInput(body, "w", "s", "a", "d")
        playerControls.addGravityComponents(entity, "v", "b")
    end
end

function DevilControlSystem:requires()
    return {"Devil", "Body"}
end

return DevilControlSystem
