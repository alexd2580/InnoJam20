local SpriteSystem = class("SpriteSystem", System)

function SpriteSystem:update(dt)
    for index, entity in pairs(self.targets) do
        local sprite = entity:get("DrawableSprite")
        sprite.currentTime = sprite.currentTime + dt
        if sprite.currentTime >= sprite.duration then
            sprite.currentTime = sprite.currentTime - sprite.duration
        end
    end

end

function SpriteSystem:draw()
    love.graphics.setColor(1, 1, 1)
    for index, entity in pairs(self.targets) do
        local sprite = entity:get("DrawableSprite")
        local spriteNum = math.floor(sprite.currentTime / sprite.duration * #sprite.quads) + 1
-- Maybe for later
--        if entity:get("SpriteColor") then
--            local color = entity:get("SpriteColor")
--            love.graphics.setColor(color.red, color.green, color.blue)
--        end
        local x, y = entity:get("Body").body:getPosition()
        local ox, oy = 0, 0
        if entity:get("Circle") then
            local diameter = entity:get("Circle").radius*2
            sx = diameter/sprite.width
            sy = diameter/sprite.height
            ox = diameter/2
            oy = diameter/2
        end
        love.graphics.draw(
            sprite.spriteSheet, sprite.quads[spriteNum],
            x, y, 0,
            sx, sy,
            ox, oy
        )
    end
end

function SpriteSystem:requires()
    return {"DrawableSprite"}
end

return SpriteSystem
