local SpriteDrawSystem = class("SpriteDrawSystem", System)

function SpriteDrawSystem:draw()
    for index, entity in pairs(self.targets) do
        local sprite = entity:get("DrawableAnimation")
        local spriteNum = math.floor(sprite.currentTime / sprite.duration * sprite.quads) + 1
        local x, y = entity:get("Body").body:getPosition()
        love.graphics.draw(sprite.spriteSheet, animation.quads[spriteNum], x, y)

    end
end
