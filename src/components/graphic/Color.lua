Color = Component.create("Color")

-- Specify a color for drawing
-- RGB up to 255
function Color:initialize(red, green, blue)
    self.red = red
    self.green = green
    self.blue = blue
end

return Color
