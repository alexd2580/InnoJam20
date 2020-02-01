local DrawableSprite = Component.create("DrawableSprite")

-- Sprite containing spritesheet already with quads
function DrawableSprite:initialize(quads, spriteSheet, duration)
    self.quads = quads
    self.spriteSheet = spriteSheet
    self.duration = duration or 1
    self.currentTime = 0

end

return DrawableSprite
