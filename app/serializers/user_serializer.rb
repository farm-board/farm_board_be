class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :created_at, :role_type

  attribute :created_at do |user|
    user.created_at && user.created_at.strftime('%m/%d/%Y')
  end
end
