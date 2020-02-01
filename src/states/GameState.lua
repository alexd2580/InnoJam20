local Vector = require("helper/Vector")
local Angel, Asteroid, Body, Color,
      Devil, Earth, DrawableCircle, DrawableSprite,
      Caged, MaxVelocity, SpawnMe, Circle,
      Attracting = Component.load({
        "Angel", "Asteroid", "Body", "Color",
        "Devil", "Earth", "DrawableCircle", "DrawableSprite",
        "Caged", "MaxVelocity", "SpawnMe", "Circle",
        "Attracting"
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

    earth:add(Color(0.2, 0.5, 0.2))
    earth:add(DrawableCircle(earthSize, true))
    earth:add(Asteroid(earthSize))
    earth:add(Earth())
    earth:add(Caged(100, 100))
    earth:add(MaxVelocity(300))
    earth:add(Attracting(20, 500))

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


function radiusToSize(radius)
    return math.pi * radius * radius
end


function sizeToRadius(radius)
    return math.sqrt(radius / math.pi)
end


function updateSize(entity, newSize)
    if newSize < 1 then
        entity:get("Body").body:destroy()
        stack:current().engine:removeEntity(entity)
        return
    end

    radius = sizeToRadius(newSize)
    entity:get("Asteroid").size = radius
    entity:get("DrawableCircle").radius = radius
    entity:get("Body").body:getFixtures()[1]:getShape():setRadius(radius)
end


function breakApart(entity, percent, collisionNormal)


    AsteroidSpawnSystem.spawnAsteroid(spawnPos, shardRadius, motionVector)

end


function GameState.handleAsteroidCollision(a, b, normal, normalImpulse, tangentImpulse)
    local aAsteroid, bAsteroid = a:get("Asteroid"), b:get("Asteroid")
    local aRadius, bRadius = aAsteroid.size, bAsteroid.size
    local aSize, bSize = radiusToSize(aRadius), radiusToSize(bRadius)
    local aBody, bBody = a:get("Body").body, b:get("Body").body
    local aPos, bPos = Vector(aBody:getX(), aBody:getY()), Vector(bBody:getX(), bBody:getY())

    if normalImpulse > 60 then
        -- Break.
        local breakFactor = normalImpulse / (normalImpulse + math.abs(tangentImpulse))

        if aSize > bSize then
            bBody:applyLinearImpulse(normal.x * normalImpulse, normal.y * normalImpulse)
            aBody:applyLinearImpulse(normal.x * normalImpulse / 2, normal.y * normalImpulse / 2)
        else
            aBody:applyLinearImpulse(-normal.x * normalImpulse, -normal.y * normalImpulse)
            bBody:applyLinearImpulse(-normal.x * normalImpulse / 2, -normal.y * normalImpulse / 2)
        end
    elseif normalImpulse > 30 then
        -- Bonk.
        if aSize > bSize then
            bBody:applyLinearImpulse(normal.x * normalImpulse, normal.y * normalImpulse)
            aBody:applyLinearImpulse(normal.x * normalImpulse / 2, normal.y * normalImpulse / 2)
        else
            aBody:applyLinearImpulse(-normal.x * normalImpulse, -normal.y * normalImpulse)
            bBody:applyLinearImpulse(-normal.x * normalImpulse / 2, -normal.y * normalImpulse / 2)
        end
    elseif normalImpulse > 0 then
        -- Absorb.
        local safetyMargin = normal:multiply(0.1)
        local absorbtionRate = 1000
        if aSize > bSize then
            local moveOver = math.min(absorbtionRate, bSize)
            aSize = aSize + moveOver
            bSize = bSize - moveOver
        else
            local moveOver = math.min(absorbtionRate, aSize)
            bSize = bSize + moveOver
            aSize = aSize - moveOver
        end

        updateSize(a, aSize)
        updateSize(b, bSize)
    end
    return

    -- local numShards = math.random(1, 5)
    -- local asteroidArea = math.pi * asteroidRadius * asteroidRadius
    -- local shardArea = asteroidArea / numShards
    -- local shardRadius = math.floor(math.sqrt(shardArea / math.pi))
    --
    -- if shardRadius > 0 then
    --     -- Convert Box2D Vectors.
    --     local tangentV = tangent:multiply(tangentImpulse)
    --     local normalV = normal:multiply(normalImpulse)
    --     local motionVector = normalV:add(tangentV)
    --
    --     for i = 1, numShards do
    --         local collisionOffset = normalV:multiply(0.1)
    --         local randOffset = Vector(math.random(-5, 5), math.random(-5, 5))
    --         local spawnPos = asteroidPosition:add(collisionOffset):add(randOffset)
    --         AsteroidSpawnSystem.spawnAsteroid(spawnPos, shardRadius, motionVector)
    --     end
    -- end
end


function GameState.onCollide(a, b, contact, normalImpulse, tangentImpulse)
    -- local tangent = Vector(ny, -nx) -- Rotate 90 deg.

    local aEntity, bEntity = a:getUserData(), b:getUserData()
    if not aEntity or not bEntity then
        return
    end
    local nx, ny = contact:getNormal()
    local normal = Vector(nx, ny)
    if aEntity:has("Asteroid") and bEntity:has("Asteroid") then
        GameState.handleAsteroidCollision(aEntity, bEntity, normal, normalImpulse, tangentImpulse)
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
