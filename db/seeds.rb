# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
Enrollment.destroy_all

# Create sample enrollments
enrollments = [
  { username: 'john_doe', year: 2024, semester: 'Spring', course: 'Mathematics 101', status: 'Active' },
  { username: 'john_doe', year: 2024, semester: 'Spring', course: 'Physics 101', status: 'Active' },
  { username: 'jane_smith', year: 2024, semester: 'Spring', course: 'Mathematics 101', status: 'Active' },
  { username: 'jane_smith', year: 2024, semester: 'Spring', course: 'Chemistry 101', status: 'Pending' },
  { username: 'bob_wilson', year: 2023, semester: 'Fall', course: 'Mathematics 101', status: 'Completed' }
]

enrollments.each do |enrollment|
  Enrollment.create!(enrollment)
end
