local Vector = require("helper/Vector")

local Accelerating = Component.create("Accelerating")

-- Any entity with this component will continuously accelerate by the given Vector
function Accelerating:initialize(defaultAcceleration, acceleration)
    self.defaultAcceleration = defaultAcceleration
    self.acceleration = acceleration or Vector()
end

return Accelerating
