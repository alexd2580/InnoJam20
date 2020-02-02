local Vector = require("src/helper/Vector")
local Body, SpawneMe = Component.load({"Body", "SpawnMe"})

local SpawnSystem = class("SpawnSystem", System)

function SpawnSystem:update(dt)
    local world = stack:current().world
    local engine = stack:current().engine

    for index, entity in pairs(self.targets) do
        local spawnMe = entity:get("SpawnMe")

        local x, y =  spawnMe.position.x, spawnMe.position.y
        if x and y then
            local body = love.physics.newBody(world, x, y, "dynamic")

            local shape = love.physics.newCircleShape(spawnMe.size)
            local fixture = love.physics.newFixture(body, shape)
            fixture:setUserData(entity)
            entity:add(Body(body))

            -- Apply linear dampening to slow down the entity.
            if spawnMe.damping ~= nil then
                body:setLinearDamping(spawnMe.damping)
            end

            -- Apply velocity in case when given.
            if spawnMe.motion then
                local mx, my = spawnMe.motion.x, spawnMe.motion.y
                body:setLinearVelocity(mx, my)
            end

            if spawnMe.impulse then
                local ix, iy = spawnMe.impulse.x, spawnMe.impulse.y
                body:applyLinearImpulse(ix, iy)
            end
        end

        entity:remove("SpawnMe")
    end
end


function SpawnSystem:requires()
    return {"SpawnMe"}
end


return SpawnSystem
