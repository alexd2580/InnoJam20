local DrawableText = class("DrawableText")

function DrawableText:initialize(font, color,string, values)
    self.font = font
    self.string = string
    self.color = color or {255, 255, 255}
    self.values = values or {}
    self.visible = true
end

return DrawableText
