local DrawableAnimation = Component.create("DrawableAnimation")

-- Animation containing spritesheet already with quads
function DrawableAnimation:initialize(quads, duration)
    self.quads = quads
    self.duration = duration or 1
    self.current_time = 0

end

return DrawableAnimation
