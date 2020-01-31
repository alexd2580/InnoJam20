local CountingDown = class("TimerSystem")

-- A simple component for creating countdowns
function CountingDown:initialize(event, time)
    self.time = time
    self.event = event
end

return CountingDown
