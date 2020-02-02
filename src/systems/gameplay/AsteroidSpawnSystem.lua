local Vector = require("helper/Vector")
local
    Asteroid, Body, Color, DrawableCircle, Drawable, JustSpawned, SpawnMe = Component.load(
    {"Asteroid", "Body", "Color", "DrawableCircle", "Drawable", "JustSpawned", "SpawnMe"}
)

local AsteroidSpawnSystem = class("AsteroidSpawnSystem", System)

function AsteroidSpawnSystem:initialize()
    System.initialize(self)
    self.timer = 0
    self.spawntime = 1
end

function AsteroidSpawnSystem.spawnAsteroid(position, size, motionVector, impulse, image)
    local world = stack:current().world
    local engine = stack:current().engine

    -- Create a new entity with a (future) physics body.
    local asteroid = Entity()
    asteroid:add(SpawnMe(size, position, motionVector, nil, impulse))

    -- Add drawing stuff
    asteroid:add(DrawableCircle(size, false))
    asteroid:add(Color(255, 255, 0))

    -- Add image
    local imageW, imageH = image:getWidth(), image:getHeight()
    local drawable = Drawable(image, 3, nil, nil, imageW / 2, imageH / 2)
    asteroid:add(drawable)

    asteroid:add(Asteroid(size))
    asteroid:add(JustSpawned())

    engine:addEntity(asteroid)
    return asteroid
end

function AsteroidSpawnSystem:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.spawntime then
        self.timer = self.timer - self.spawntime

        local x, y = math.random(-200, 200), math.random(-200, 200)
        -- Spawn the asteroids at least -+50 left/right outside the viewport.
        if x < 0 then
            x = -50 + x
        else
            x = 1970 + x
        end

        -- Spawn the asteroids at least -+50 top/down outside the viewport.
        if y < 0 then
            y = -50 + x
        else
            y = 1130 + x
        end

        local position = Vector(x, y)
        -- Target any random place within the viewport (excluding the outer 100 coordinate square).
        local target = Vector(math.random(100, 1820), math.random(100, 980))
        local motionVector = target:subtract(position)
        local velocity = math.random(100, 200)
        motionVector = motionVector:getUnit()
        motionVector = motionVector:multiply(velocity)

        local randomType = math.random(1, 3)
        local image, type
        if randomType == 1 then
            image = resources.images.explodyboi
            type = "explodiboy"
        elseif randomType == 2 then
            image = resources.images.stoneboi
            type = "stoneboi"
        elseif randomType == 3 then
            image = resources.images.waterboi
            type = "waterboi"
        end

        local size = math.random(15, 25)
        local asteroid = AsteroidSpawnSystem.spawnAsteroid(position, size, motionVector, nil, image)
        asteroid:get("Asteroid").type = type
    end
end

function AsteroidSpawnSystem:requires()
    return {}
end

return AsteroidSpawnSystem
