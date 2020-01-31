local Vector = require("helper/Vector")

local Accelerating = class("Accelerating")

function Accelerating:initialize(defaultAcceleration, acceleration)
    self.defaultAcceleration = defaultAcceleration
    self.acceleration = acceleration or Vector()
end

return Accelerating