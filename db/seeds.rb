# Adminleri oluşturuyoruz.
AdminUser.create!(email: 'ffa@adeosecurity.com', password: 'asdqwe123', password_confirmation: 'asdqwe123',
                  confirmed_at: Time.now, is_super: true, user_name: 'Free For All')