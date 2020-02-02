local Vector = require("helper/Vector")
local Asteroid, Body, Color, DrawableCircle, Drawable, JustSpawned, SpawnMe = Component.load(
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
    asteroid:add(DrawableCircle(size, true))
    asteroid:add(Color(255, 255, 0))

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

        local asteroid = AsteroidSpawnSystem.spawnAsteroid(position, 20, motionVector)
    end
end

function AsteroidSpawnSystem:requires()
    return {}
end

return AsteroidSpawnSystem
