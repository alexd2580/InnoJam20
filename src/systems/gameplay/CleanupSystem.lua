local ReadyForCleanup = Component.load({"ReadyForCleanup"})

local CleanupSystem = class("CleanupSystem", System)

function CleanupSystem:update(dt)
    local engine = stack:current().engine
    -- Check if the entity entered the screen
    -- As soon as that happens, stop watching it and add ReadyForCleanup
    for index, entity in pairs(self.targets.watching) do
        local body = entity:get("Body").body
        local x, y = body:getPosition()
        if x > 0 and x < 1920 and y > 0 and y < 1080 then
            entity:remove("JustSpawned")
            entity:add(ReadyForCleanup())
        end
    end

    -- Check if the entity exits the screen. Destroy as soon as it does
    for index, entity in pairs(self.targets.ready) do
        local body = entity:get("Body").body
        local x, y = body:getPosition()
        if (x < -40 or x > 1960) and (y < -40 or y > 1120) then
            body:destroy()
            engine:removeEntity(entity)
        end
    end
end

function CleanupSystem:requires()
    return {watching = {"JustSpawned", "Body"}, ready = {"ReadyForCleanup", "Body"}}
end

return CleanupSystem
