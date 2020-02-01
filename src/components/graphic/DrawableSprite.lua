local DrawableSprite = Component.create("DrawableSprite")

-- Sprite containing spritesheet already with quads
function DrawableSprite:initialize(sprite, duration)
    self.quads = sprite.quads
    self.spriteSheet = sprite.spriteSheet
    self.width = sprite.width
    self.height = sprite.height
    self.duration = duration or 1
    self.currentTime = 0

end

return DrawableSprite
