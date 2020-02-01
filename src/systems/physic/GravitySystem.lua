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
            local asteroidBody = asteroid:get("Body")
            if asteroidBody ~= nil then
                local asteroidPosition = asteroidBody:getPositionVector()
                local direction = entityPosition:subtract(asteroidPosition)
                local distance = direction:length(entityPosition)
                -- Check if the body is in range
                local attractorRadius = body:getFixtures()[1]:getShape():getRadius()
                local attractionRadius = attractorRadius + attracting.radius
                if distance < attractionRadius then
                    -- Apply force linear to the distance to the center of the attracting entity
                    local remainingForce = attractionRadius - distance
                    local forceVector = direction:getUnit():multiply(remainingForce)
                    if attracting.reverse then
                        forceVector = forceVector:multiply(-1)
                    end
                    asteroidBody.body:applyForce(forceVector.x, forceVector.y)
                end
            end
        end
    end
end

function GravitySystem:requires()
    return {"Attracting", "Body"}
end

return GravitySystem
