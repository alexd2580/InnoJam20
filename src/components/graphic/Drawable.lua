-- A component for drawing images on top of an entity
-- Parameters are
-- The Image
-- Scale on x-axis
-- Scale on y-axis
-- Offset on x-axis
-- Offset on y-axis
return Component.create("Drawable", {"image", "index", "sx", "sy", "ox", "oy"}, {nil, 0, 0, 0, 0, 0})
