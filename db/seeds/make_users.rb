admin_u = Admin.find_or_create_by(email: 'admin@ideamapr.com')
if Rails.env.production?
  admin_u.password = ENV['ADMIN_PASSWORD']
else
  admin_u.password='admin123'
end
admin_u.save

unless Rails.env.production?
  u = User.find_or_create_by(email: 'just_u@ideamapr.com')
  u.password='userme123'
  u.save
end

