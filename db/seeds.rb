puts 'SETTING UP DEFAULT USER LOGIN'

user = User.create(
  email: 'malachai@thiesa.com',
  password: 'Ethan2012',
  password_confirmation: 'Ethan2012',
  confirmed_at: Time.now,
)
# user.save!(validate: false)

puts '------------'
puts '------------'
puts '------------'
puts '------------'

puts 'New user created: ' << user.email

puts '------------'
puts '------------'
puts '------------'
puts '------------'

puts 'ADDING ADMIN ROLE!'

puts '------------'
puts '------------'
puts '------------'
puts '------------'

user.add_role :admin

puts '------------'
puts '------------'
puts '------------'
puts '------------'

puts 'User now has Role: ' << user.roles.first.name

puts '------------'
puts '------------'
puts '------------'
puts '------------'

puts 'This is your email: ' << user.email
# puts 'This is your Profile Name: ' << user.profile_name
# puts 'This is your Twitter Profile Name: ' << user.twitter
puts 'Login & change this password: ' << user.password
