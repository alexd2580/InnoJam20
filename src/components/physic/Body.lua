local Body = Component.create("Body")

-- Any entity with this component will continuously accelerate by the given Vector
function Body:initialize(body)
    self.body = body
end

return Body
