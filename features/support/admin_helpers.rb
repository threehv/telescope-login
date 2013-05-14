module AdminHelpers
  include Spinach::DSL

  step 'I am logged in as an administrator' do
    @administrator = Masq::Account.create! login: 'Admin', email: 'admin@mysite.com', admin: true, password: 'secret', password_confirmation: 'secret', enabled: true, activated_at: Time.now
    visit '/login'
    fill_in 'User name', with: 'Admin'
    fill_in 'Password', with: 'secret'
    click_button 'Continue'
  end

  step 'there are several users configured' do
    @users = []
    3.times do | i | 
      @users << Masq::Account.create!(login: "User#{i}", email: "user#{i}@example.com", password: 'whatever', password_confirmation: 'whatever')
    end
  end

  step 'I visit the users page' do
    visit '/admin/users'
  end

end
