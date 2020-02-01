local DrawableAnimation = Component.create("DrawableAnimation")

-- Animation containing spritesheet already with quads
function DrawableAnimation:initialize(quads, spriteSheet, duration)
    self.quads = quads
    self.spriteSheet = spriteSheet
    self.duration = duration or 1
    self.currentTime = 0

end

return DrawableAnimation
