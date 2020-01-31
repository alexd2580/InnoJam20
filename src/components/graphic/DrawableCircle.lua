DrawableCircle = Component.create("DrawableCircle")

-- A component for drawing a circle on top of the entity
-- The radius of the circle,
-- Whether the circle should be filled (true, false)
-- The x/y offset
function DrawableCircle:initialize(radius, fill, ox, oy)
    self.radius = radius
    self.fill = fill
    self.ox = ox
    self.oy = oy
end

return DrawableCircle
