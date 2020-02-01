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

return playerControls
