local Attracting = Component.load({"Attracting"})
local playerControls = {}

local IMPULSE = 100

function playerControls.applyImpulseFromInput(body, u, d, l, r)
    local x, y = 0, 0

    if love.keyboard.isDown(u) then
        y = y - 1
    end
    if love.keyboard.isDown(d) then
        y = y + 1
    end
    if love.keyboard.isDown(l) then
        x = x - 1
    end
    if love.keyboard.isDown(r) then
        x = x + 1
    end

    len = y * y + x * x
    if len > 0 then
        x = x / len
        y = y / len

        body:applyLinearImpulse(x * IMPULSE, y * IMPULSE)
    end
end

function playerControls.addGravityComponents(entity, a, r)
    -- Make the player attracting, if the respective button is pressed
    if love.keyboard.isDown(a) then
        if entity:get("Attracting") == nil then
            entity:add(Attracting(2000, 500))
        elseif entity:get("Attracting").reverse then
            entity:get("Attracting").reverse = false
        end
    elseif love.keyboard.isDown(r) then
        if entity:get("Attracting") == nil then
            entity:add(Attracting(1000, 500, true))
        elseif not entity:get("Attracting").reverse then
            entity:get("Attracting").reverse = true
        end
    elseif not love.keyboard.isDown(a) and not love.keyboard.isDown(a) then
        if entity:get("Attracting") ~= nil then
            entity:remove("Attracting")
        end
    end
end

return playerControls
