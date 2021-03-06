local Vector = require("src/helper/Vector")
local Angel, Asteroid, Body, Color,
      Devil, Earth, DrawableCircle, DrawableSprite,
      Caged, MaxVelocity, SpawnMe, Circle,
      Attracting, ImagePosition, Drawable, Parallax,
      Particle = Component.load({
        "Angel", "Asteroid", "Body", "Color",
        "Devil", "Earth", "DrawableCircle", "DrawableSprite",
        "Caged", "MaxVelocity", "SpawnMe", "Circle",
        "Attracting", "ImagePosition", "Drawable", "Parallax",
        "Particle"
})

-- Draw Systems
local DrawSystem = require("src/systems/draw/DrawSystem")
local CircleDrawSystem = require("src/systems/draw/CircleDrawSystem")
local SpriteSystem = require("src/systems/draw/SpriteSystem")

-- Particle Systems
local ParticleDrawSystem = require("src/systems/particle/ParticleDrawSystem")
local ParticleUpdateSystem = require("src/systems/particle/ParticleUpdateSystem")
local ParticlePositionSyncSystem = require("src/systems/particle/ParticlePositionSyncSystem")

-- Game Systems
local AngelControlSystem = require("src/systems/gameplay/AngelControlSystem")
local DevilControlSystem = require("src/systems/gameplay/DevilControlSystem")
local AsteroidSpawnSystem = require("src/systems/gameplay/AsteroidSpawnSystem")
local CleanupSystem = require("src/systems/gameplay/CleanupSystem")
local ParallaxSystem = require("src/systems/gameplay/ParallaxSystem")
local SpawnSystem = require("src/systems/physic/SpawnSystem")

-- Physics Systems
local GravitySystem = require("src/systems/physic/GravitySystem")
local CageSystem = require("src/systems/physic/CageSystem")
local MaxVelocitySystem = require("src/systems/physic/MaxVelocitySystem")

-- Events
local KeyPressed = require("src/events/KeyPressed")

-- State superclass
local State = require("src/core/State")
local GameState = class("GameState", State)


function GameState:spawnEarth()
    local earth = Entity()

    local earthRadius = 150
    local sourceEarthImageSize = 400
    local offset = sourceEarthImageSize / 2

    local startX, startY = 1920 / 2, 1080 / 2
    local position = Vector(startX, startY)
    local drawable = Drawable(resources.images.planet, 5, nil, nil, offset, offset)
    earth:add(SpawnMe(earthRadius, position, nil, 0.2))
    earth:add(Earth())
    earth:add(Caged(100, 100))
    earth:add(MaxVelocity(300))
    earth:add(Attracting(0.01, 400))
    earth:add(drawable)
    earth:add(Color(0.2, 0.5, 0.2))
    earth:add(DrawableCircle(earthRadius, false))


    resources.sounds.boom:setVolume(1.0)
    resources.sounds.splash:setVolume(0.8)
    -- resize

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
    local startX, startY = 100, 100
    local angel = self:buildBasePlayer(startX, startY, 0.8, 0.8, 0.8)
    angel:add(Angel())
    angel:add(DrawableSprite(resources.sprites.good, 1))
    self.engine:addEntity(angel)
end


function GameState:spawnDevil()
    local startX, startY = 1700, 980
    local devil = self:buildBasePlayer(startX, startY, 0.8, 0.2, 0.2)
    devil:add(Devil())
    devil:add(DrawableSprite(resources.sprites.bad, 1))
    self.engine:addEntity(devil)
end


function setEarthRadius(earth, newRadius)
    local body = earth:get("Body").body
    if newRadius ~= newRadius or newRadius < 50 then
        newRadius = 50
    end
    -- if  or newRadius >  then
    --     stack:pop()
    --     return
    --     -- body:destroy()
    --     -- stack:current().engine:removeEntity(earth)
    --     -- -- print("Remove earth")
    --     -- return false
    -- end

    local earthShape = body:getFixtures()[1]:getShape():setRadius(newRadius)
    earth:get("DrawableCircle").radius = newRadius
    return true
end


function GameState:spawnBackground()
    local background = Entity()
    local drawable = Drawable(resources.images.background, 1)
    background:add(ImagePosition(-500, -500))
    background:add(Parallax(100))
    background:add(drawable)
    self.engine:addEntity(background)

    local deepfield = Entity()
    drawable = Drawable(resources.images.deepfield, 3)
    deepfield:add(ImagePosition(0, 0))
    deepfield:add(Parallax(50))
    deepfield:add(drawable)

    self.engine:addEntity(deepfield)
end


function GameState.handleAsteroidEarthCollision(
    asteroid, earth, earthToAsteroid, normalImpulse, tangentImpulse
)
    local asteroidComponent = asteroid:get("Asteroid")
    local asteroidRadius = asteroidComponent.size
    local asteroidType = asteroidComponent.type
    local asteroidImage = asteroid:get("Drawable").image

    local body = asteroid:get("Body").body
    local asteroidX, asteroidY = body:getPosition()
    local asteroidPosition = Vector(asteroidX, asteroidY)
    local oldX, oldY = body:getPosition()

    local numShards = math.random(3, 5)
    local asteroidArea = math.pi * asteroidRadius * asteroidRadius
    local shardArea = asteroidArea / numShards
    local shardRadius = math.floor(math.sqrt(shardArea / math.pi))
    local shardEnergyFraction = shardArea / asteroidArea

    local earthAntiCollision = earthToAsteroid:multiply(-0.5 * normalImpulse)
    earth:get("Body").body:applyLinearImpulse(earthAntiCollision.x, earthAntiCollision.y)

    local earthShape = earth:get("Body").body:getFixtures()[1]:getShape()
    local radius = earthShape:getRadius()

    if asteroidType == "explodiboy" then
        -- Explode!
        local newRadius = math.sqrt((radius * radius * math.pi - 10 * asteroidArea) / math.pi)
        setEarthRadius(earth, newRadius)
        resources.sounds.boom:stop()
        resources.sounds.boom:play()
    end

    body:destroy()
    stack:current().engine:removeEntity(asteroid)

    if asteroidType == "stoneboi" or asteroidType == "waterboi" then
        if shardRadius > 0.5 then
            local explodeFactor = 1.0
            -- SHRINK
            local shrinkThreshold = 600
            if normalImpulse > shrinkThreshold then
                local newRadius = math.sqrt((radius * radius * math.pi - 8 * asteroidArea) / math.pi)
                if not setEarthRadius(earth, newRadius) then
                    return
                end
                explodeFactor = 0.5 + normalImpulse / shrinkThreshold
            end

            local tangent = Vector(earthToAsteroid.y, -earthToAsteroid.x)
            local tangentV = tangent:multiply(tangentImpulse)
            local normalV = earthToAsteroid:multiply(-1.5 * normalImpulse)
            local impulse = tangentV:multiply(5.0 * shardEnergyFraction)
            impulse = impulse:multiply(explodeFactor)

            for i = 1, numShards do
                local randOffset = Vector(math.random(-5, 5), math.random(-5, 5))
                -- print(asteroidPosition.x, asteroidPosition.y, randOffset.x, randOffset.y, shardRadius, impulse.x, impulse.y)
                local newAsteroid = AsteroidSpawnSystem.spawnAsteroid(
                    asteroidPosition:add(randOffset), shardRadius, nil, impulse, asteroidImage
                )
                newAsteroid:get("Asteroid").type = asteroidType
            end

            if asteroidType == "waterboi" then
                if asteroidRadius > 14 then
                    resources.sounds.splash:stop()
                    resources.sounds.splash:play()
                end
            end
        else
           -- GROW
            local newRadius = math.sqrt((radius * radius * math.pi + 10 * asteroidArea) / math.pi)
            setEarthRadius(earth, newRadius)
        end
    end
end


function GameState.onCollide(a, b, contact, normalImpulse, tangentImpulse)
    local aEntity, bEntity = a:getUserData(), b:getUserData()
    if not aEntity or not bEntity then
        return
    end
    if aEntity:get("Body").body:isDestroyed() or bEntity:get("Body").body:isDestroyed() then
        return
    end


    local nx, ny = contact:getNormal()
    -- print("normal", nx, ny)
    local bToA = Vector(nx, ny)
    if aEntity:has("Earth") and bEntity:has("Asteroid") then
        -- print(bEntity:get("Body").body:getPosition())
        GameState.handleAsteroidEarthCollision(bEntity, aEntity, bToA:multiply(-1), normalImpulse, tangentImpulse)
    elseif bEntity:has("Earth") and aEntity:has("Asteroid") then
        -- print(aEntity:get("Body").body:getPosition())
        GameState.handleAsteroidEarthCollision(aEntity, bEntity, bToA, normalImpulse, tangentImpulse)
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
    self.engine:addSystem(DrawSystem())
    self.engine:addSystem(CircleDrawSystem())
    self.engine:addSystem(spriteSystem, "draw")
    self.engine:addSystem(ParticleDrawSystem())

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
    self.engine:addSystem(SpawnSystem())
    self.engine:addSystem(ParallaxSystem())
        -- Physics
    self.engine:addSystem(GravitySystem())
    self.engine:addSystem(CageSystem())
    self.engine:addSystem(MaxVelocitySystem())

    self:spawnBackground()
    self:spawnEarth()
    self:spawnAngel()
    self:spawnDevil()

    resources.music.background:setVolume(0.5)
    resources.music.background:isLooping(true)
    resources.music.background:play()
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
