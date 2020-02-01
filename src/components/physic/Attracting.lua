-- Entities with this component attract surrounding entities with
-- a given force in the specified radius
return Component.create("Attracting", {"force", "radius", "reverse"}, {nil, nil, false})
