local Vector = require("helper/Vector")
-- Any entity with this component will continuously accelerate by the given Vector
local Body = Component.create("Body", {"body"})

function Body:getPositionVector()
    local x, y = self.getPosition()
    return Vector(x, y)
end

return Body
