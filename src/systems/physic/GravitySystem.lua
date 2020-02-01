local GravitySystem = class("GravitySystem", System)
local Vector = require("helper/Vector")

function GravitySystem:update(dt)
    local asteroids = stack:current().engine:getEntitiesWithComponent("Asteroid")
    for index, entity in pairs(self.targets) do
        local body = entity:get("Body").body
        local entityPosition = entity:get("Body"):getPositionVector()
        local attracting = entity:get("Attracting")

        -- Check for all asteroids, if they are in range
        for _, asteroid in pairs(asteroids) do
            -- Check if the body exists (important because of SpawnSystem)
            if asteroid:get("Body") ~= nil then
                local asteroidPosition = asteroid:get("Body"):getPositionVector()
                local direction = entityPosition:subtract(asteroidPosition)
                local distance = direction:length(entityPosition)
                -- Check if the body is in range
                if distance < attracting.radius then
                    -- Apply force linear to the distance to the center of the attracting entity
                    local remainingForce = attracting.radius - distance
                    local forceVector = direction:getUnit():multiply(remainingForce)
                    asteroid:get("Body").body:applyForce(forceVector.x, forceVector.y)
                end
            end
        end
    end
end

function GravitySystem:requires()
    return {"Attracting", "Body"}
end

return GravitySystem
