local Body, Color, DrawableCircle = Component.load({"Body", "Color", "DrawableCircle"})
local AsteroidSpawnSystem = class("AsteroidSpawnSystem", System)

function AsteroidSpawnSystem:initialize()
    System.initialize(self)
    self.timer = 0
    self.spawntime = 1
end

function AsteroidSpawnSystem:update(dt)
    self.timer = self.timer + dt
    local world = stack:current().world
    local engine = stack:current().engine
    if self.timer > self.spawntime then
        self.timer = self.timer - self.spawntime
        -- Create a new entity with a physics body
        local asteroid = Entity()
        local body = love.physics.newBody(world, 400, 400, "dynamic")
        local shape = love.physics.newCircleShape(20)
        local fixture = love.physics.newFixture(body, shape)
        asteroid:add(Body(body))
        body:setLinearVelocity(math.random(-50, 50), math.random(-50, 50))

        -- Add drawing stuff
        asteroid:add(DrawableCircle(50, true))
        asteroid:add(Color(255, 255, 0))

        engine:addEntity(asteroid)
    end
end

function AsteroidSpawnSystem:requires()
    return {}
end

return AsteroidSpawnSystem
