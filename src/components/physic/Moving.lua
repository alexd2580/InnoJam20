local Vector = require("helper/Vector")

local Moving = class("Moving")

-- If you want a entity to move, use this component
function Moving:initialize(speed, maxSpeed)
    self.speed = speed or Vector()
    self.maxSpeed = maxSpeed
end

return Moving
