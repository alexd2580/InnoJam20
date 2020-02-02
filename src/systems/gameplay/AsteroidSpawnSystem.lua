local Vector = require("src/helper/Vector")
local
    Asteroid, Body, Color, DrawableCircle, Drawable, JustSpawned, Particle, SpawnMe = Component.load(
    {"Asteroid", "Body", "Color", "DrawableCircle", "Drawable", "JustSpawned", "Particle", "SpawnMe"}
)

local AsteroidSpawnSystem = class("AsteroidSpawnSystem", System)

function AsteroidSpawnSystem:initialize()
    System.initialize(self)
    self.timer = 0
    self.spawntime = 1
end

function AsteroidSpawnSystem.spawnAsteroid(position, size, motionVector, impulse, image, particleImage)
    local world = stack:current().world
    local engine = stack:current().engine

    -- Create a new entity with a (future) physics body.
    local asteroid = Entity()
    asteroid:add(SpawnMe(size, position, motionVector, nil, impulse))

    -- Add drawing stuff
    -- asteroid:add(DrawableCircle(size, false))
    -- asteroid:add(Color(255, 255, 0))

    -- Add image
    local imageW, imageH = image:getWidth(), image:getHeight()
    local drawable = Drawable(image, 3, nil, nil, imageW / 2, imageH / 2)
    asteroid:add(drawable)

    asteroid:add(Asteroid(size))
    asteroid:add(JustSpawned())

    if particleImage then
        asteroid:add(Particle(particleImage, 10000, Vector(0, 0), {0.05, 0.5}))
    end

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
            x = x - 50
        else
            x = x + 1970
        end

        -- Spawn the asteroids at least -+50 top/down outside the viewport.
        if y < 0 then
            y = y - 50
        else
            y = y + 1130
        end

        local position = Vector(x, y)
        -- Target any random place within the viewport (excluding the outer 100 coordinate square).
        local target = Vector(math.random(100, 1820), math.random(100, 980))
        local motionVector = target:subtract(position)
        local velocity = math.random(100, 200)
        motionVector = motionVector:getUnit()
        motionVector = motionVector:multiply(velocity)

        local randomType = math.random(1, 3)
        local image, type, particleImage
        if randomType == 1 then
            image = resources.images.explodyboi
            particleImage = resources.images.explodyparticle
            type = "explodiboy"
        elseif randomType == 2 then
            image = resources.images.stoneboi
            particleImage = resources.images.explodyparticle
            type = "stoneboi"
        elseif randomType == 3 then
            image = resources.images.waterboi
            particleImage = resources.images.explodyparticle
            type = "waterboi"
        end

        local size = math.random(15, 25)
        local asteroid = AsteroidSpawnSystem.spawnAsteroid(position, size, motionVector, nil, image, particleImage)
        asteroid:get("Asteroid").type = type
    end
end

function AsteroidSpawnSystem:requires()
    return {}
end

return AsteroidSpawnSystem
