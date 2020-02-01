-- Prevent an entity to leave this area
-- offset_x and offset_y specify the distance to the
-- screen border at which the entity is forced back
return Component.create("Caged", {"offset_x", "offset_y"})
