local Vector = require("helper/Vector")
local ParallaxSystem = class("ParallaxSystem", System)

function ParallaxSystem:update(dt)
    local engine = stack:current().engine

    -- Calculate the edact middle position between the players
    local playerMid = table.firstElement(engine:getEntitiesWithComponent("Angel")):get("Body"):getPositionVector()
    -- blocal posBad = table.firstElement(engine:getEntitiesWithComponent("Devil")):get("Body"):getPositionVector()
    -- blocal distance = posGood:subtract(posBad)
    -- blocal playerMid = posBad:add(distance:multiply(0.5))

    local screenMid = Vector(1920/2, 1080/2)
    local parallaxVector = playerMid:subtract(screenMid):getUnit()
    for index, entity in pairs(self.targets) do
        local imagePosition = entity:get("ImagePosition")
        local parallaxDistance = entity:get("Parallax").distance

        local shift = parallaxVector:multiply(parallaxDistance)
        imagePosition.x = imagePosition.originalX + shift.x
        imagePosition.y = imagePosition.originalY + shift.y
    end
end

function ParallaxSystem:requires()
    return {"ImagePosition", "Parallax"}
end

return ParallaxSystem
