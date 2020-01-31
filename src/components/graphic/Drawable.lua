Drawable = Component.create("Drawable")

-- A component for drawing images on top of an entity
-- Parameters are
-- The Image
-- Scale on x-axis
-- Scale on y-axis
-- Offset on x-axis
-- Offset on y-axis
function Drawable:initialize(image, index, sx, sy, ox, oy)
    self.image = image
    self.index = index or 0
    self.sx = sx
    self.sy = sy
    self.ox = ox
    self.oy = oy
end

return Drawable
