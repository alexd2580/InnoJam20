local Vector = require("helper/Vector")

local Rotating = class("Rotating")

-- Entities with this will rotate at the given speed
function Rotating:initialize(defaultRotationSpeed)
    self.defRotationSpeed = defaultRotationSpeed
    self.rotationSpeed = 0
end

return Rotating
