local Vector = require("helper/Vector")

local Transformable = class("Transformable")

-- This component gives an entity a position, a direction and an offset
-- If an `offset` is provided, the entity will at a fixed position in relation to it's parent
-- When `rotating` is true, it will rotate at `offset` with `direction` around it's parent
function Transformable:initialize(offset, dir, rotating)
    self.offset = offset or Vector()

    self.position = Vector()
    self.direction = dir or Vector()
    if rotating == nil then
    	self.rotationEnabled = true
    else
    	self.rotationEnabled = rotating
    end
end


return Transformable
