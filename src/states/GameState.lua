local Vector = require("helper/Vector")
local Angel, Asteroid, Body, Color,
      Devil, Earth, DrawableCircle, DrawableSprite,
      Caged, MaxVelocity, SpawnMe, Circle,
      Attracting, Position, Drawable = Component.load({
        "Angel", "Asteroid", "Body", "Color",
        "Devil", "Earth", "DrawableCircle", "DrawableSprite",
        "Caged", "MaxVelocity", "SpawnMe", "Circle",
        "Attracting", "ImagePosition", "Drawable"
})

-- Draw Systems
local DrawSystem = require("systems/draw/DrawSystem")
local CircleDrawSystem = require("systems/draw/CircleDrawSystem")
local SpriteSystem = require("systems/draw/SpriteSystem")

-- Particle Systems
local ParticleDrawSystem = require("systems/particle/ParticleDrawSystem")
local ParticleUpdateSystem = require("systems/particle/ParticleUpdateSystem")
local ParticlePositionSyncSystem = require("systems/particle/ParticlePositionSyncSystem")

-- Game Systems
local AngelControlSystem = require("systems/gameplay/AngelControlSystem")
local DevilControlSystem = require("systems/gameplay/DevilControlSystem")
local AsteroidSpawnSystem = require("systems/gameplay/AsteroidSpawnSystem")
local CleanupSystem = require("systems/gameplay/CleanupSystem")
local SpawnSystem = require("systems/physic/SpawnSystem")

-- Physics Systems
local GravitySystem = require("systems/physic/GravitySystem")
local CageSystem = require("systems/physic/CageSystem")
local MaxVelocitySystem = require("systems/physic/MaxVelocitySystem")

-- Events
local KeyPressed = require("events/KeyPressed")

-- State superclass
local State = require("core/State")
local GameState = class("GameState", State)


function GameState:spawnEarth()
    local earth = Entity()

    local earthSize = 150
    local startX, startY = 1920 / 2, 1080 / 2
    local position = Vector(startX, startY)
    earth:add(SpawnMe(earthSize, position, nil, 0.2))


    earth:add(DrawableSprite(resources.sprites.planet, 3))
    earth:add(Earth())
    earth:add(Caged(100, 100))
    earth:add(MaxVelocity(300))
    earth:add(Attracting(0.01, 400))

    self.engine:addEntity(earth)
end


function GameState:buildBasePlayer(startX, startY, r, g, b)
    local player = Entity()

    local playerSize = 40
    local position = Vector(startX, startY)
    player:add(SpawnMe(playerSize, position, nil, 0.4))
    player:add(Caged(100, 100))
    player:add(MaxVelocity(500))
    player:add(Circle(playerSize))

    player:add(Color(r, g, b))

    return player
end


function GameState:spawnAngel()
    local startX, startY = 200, 200
    local angel = self:buildBasePlayer(startX, startY, 0.8, 0.8, 0.8)
    angel:add(Angel())
    angel:add(DrawableSprite(resources.sprites.good, 1))
    self.engine:addEntity(angel)
end


function GameState:spawnDevil()
    local startX, startY = 300, 300
    local devil = self:buildBasePlayer(startX, startY, 0.8, 0.2, 0.2)
    devil:add(Devil())
    devil:add(DrawableSprite(resources.sprites.bad, 1))
    self.engine:addEntity(devil)
end


function GameState:spawnBackground()
    local background = Entity()
    local drawable = Drawable(resources.images.background)
    background:add(Position(-500, -500))
    background:add(drawable)

    self.engine:addEntity(background)
end

function GameState.handleAsteroidEarthCollision(
    asteroid, earth, normal, normalImpulse, tangent, tangentImpulse
)
    local asteroidRadius = asteroid:get("Asteroid").size
    local body = asteroid:get("Body").body
    local asteroidX, asteroidY = body:getPosition()
    local asteroidPosition = Vector(asteroidX, asteroidY)
    local oldX, oldY = body:getPosition()
    body:destroy()
    stack:current().engine:removeEntity(asteroid)

    local numShards = math.random(1, 5)
    local asteroidArea = math.pi * asteroidRadius * asteroidRadius
    local shardArea = asteroidArea / numShards
    local shardRadius = math.floor(math.sqrt(shardArea / math.pi))

    if shardRadius > 0 then
        -- Convert Box2D Vectors.
        local tangentV = tangent:multiply(tangentImpulse)
        local normalV = normal:multiply(-normalImpulse)
        local motionVector = normalV:add(tangentV)

        for i = 1, numShards do
            local randOffset = Vector(math.random(-5, 5), math.random(-5, 5))
            AsteroidSpawnSystem.spawnAsteroid(asteroidPosition:add(randOffset), shardRadius, motionVector)
        end
    end
end


function GameState.onCollide(a, b, contact, normalImpulse, tangentImpulse)
    local aEntity, bEntity = a:getUserData(), b:getUserData()
    if not aEntity or not bEntity then
        return
    end
    local nx, ny = contact:getNormal()
    local normal = Vector(nx, ny)
    local tangent = Vector(ny, -nx) -- Rotate 90 deg.
    if aEntity:has("Earth") and bEntity:has("Asteroid") then
        GameState.handleAsteroidEarthCollision(bEntity, aEntity, normal, normalImpulse, tangent, tangentImpulse)
    elseif bEntity:has("Earth") and aEntity:has("Asteroid") then
        GameState.handleAsteroidEarthCollision(aEntity, bEntity, -normal, normalImpulse, -tangent, tangentImpulse)
    end
end


function GameState:load()
    self.world = love.physics.newWorld(0, 0, true)
    self.world:setCallbacks(nil, nil, nil, self.onCollide)

    self.engine = Engine()
    self.eventmanager = EventManager()

    -- Physic systems.

    local spriteSystem = SpriteSystem()

    -- Draw systems
    self.engine:addSystem(ParticleDrawSystem())
    self.engine:addSystem(DrawSystem())
    self.engine:addSystem(CircleDrawSystem())
    self.engine:addSystem(spriteSystem, "draw")

    -- Update
        -- Particle
    self.engine:addSystem(ParticleUpdateSystem())
    self.engine:addSystem(ParticlePositionSyncSystem())
        -- Gameplay
    self.engine:addSystem(AngelControlSystem())
    self.engine:addSystem(DevilControlSystem())
    self.engine:addSystem(AsteroidSpawnSystem())
    self.engine:addSystem(CleanupSystem())
    self.engine:addSystem(spriteSystem, "update")
        -- Physics
    self.engine:addSystem(GravitySystem())
    self.engine:addSystem(SpawnSystem())
    self.engine:addSystem(CageSystem())
    self.engine:addSystem(MaxVelocitySystem())

    self:spawnBackground()
    self:spawnEarth()
    self:spawnAngel()
    self:spawnDevil()
end

function GameState:update(dt)
    self.world:update(dt)
    self.engine:update(dt)
end

function GameState:draw()
    self.engine:draw()
end

function GameState:keypressed(key, isrepeat)
    if key == 'escape' then
        stack:pop()
    end

    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end

return GameState
