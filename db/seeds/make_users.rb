admin_u = Admin.find_or_create_by(email: 'admin@ideamapr.com')
admin_u.password='admin123'
admin_u.save

u = User.find_or_create_by(email: 'just_u@ideamapr.com')
u.password='userme123'
u.save

