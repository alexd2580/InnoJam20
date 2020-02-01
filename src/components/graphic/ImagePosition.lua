-- Specify the position of an image that doesn't have a body
local ImagePosition = Component.create("ImagePosition")

function ImagePosition:initialize(x, y)
    self.x = x
    self.y = y
    self.originalX = x
    self.originalY = y
end

return ImagePosition
