# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a user
user = User.create!(
  email: 'userfarm@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  jti: SecureRandom.uuid,
  role_type: 1
)

# Create a farm associated with the user
farm = Farm.create!(
  name: 'My Farm',
  city: 'Wiggins',
  state: 'Colorado',
  zip_code: '12345',
  bio: 'This is a test farm',
  user: user
)

User.first.farm.profile_image.attach(io: File.open('app/assets/images/farm.jpeg'), filename: 'farm.jpeg')
User.first.farm.gallery_photos.attach(io: File.open('app/assets/images/cows.jpeg'), filename: 'cows.jpeg')
User.first.farm.gallery_photos.attach(io: File.open('app/assets/images/farm_shed.jpeg'), filename: 'farm_shed.jpeg')
User.first.farm.gallery_photos.attach(io: File.open('app/assets/images/lettuce.jpeg'), filename: 'lettuce.jpeg')

# Create a user
user = User.create!(
  email: 'useremployee@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  jti: SecureRandom.uuid,
  role_type: 2
)

# Create a farm associated with the user
employee = Employee.create!(
  first_name: 'Dylan',
  last_name: 'Timmons',
  city: 'Wiggins',
  state: 'CO',
  zip_code: '80020',
  skills: ['Farming', 'Cooking', 'Cleaning'],
  bio: 'This is a test employee',
  age: 31,
  user: user
)

employee.main_image.attach(io: File.open('app/assets/images/test.jpeg'), filename: 'test.jpeg')
