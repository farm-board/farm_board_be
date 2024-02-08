class ExperienceSerializer
    include JSONAPI::Serializer
    attributes :company_name, :started_at, :ended_at, :description
end
