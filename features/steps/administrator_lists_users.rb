class Spinach::Features::AdministratorListsUsers < Spinach::FeatureSteps
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

  step 'I visit the home page' do
    visit '/'
  end

  step 'I should be able to visit the users page' do
    expect(page).to have_content('View users')
  end

  step 'I visit the users page' do
    visit '/admin/users'
  end

  step 'I should see all users within the system' do
    expect(page).to have_css('.users')
    within '.users' do
      @users.each do | user |
        expect(page).to have_css("#account_#{user.id}")
      end
    end
  end

  step 'I am not logged in' do
    # do nothing
  end

  step 'I should see a message stating that I do not have permission to view that page' do
    expect(page).to have_content('You do not have permission to view that page')
  end

  step 'I am logged in as a non-administrator' do
    @non_admin = Masq::Account.create login: 'nonadmin', email: 'someone@example.com', admin: false, password: 'secret', password_confirmation: 'secret', enabled: true, activated_at: Time.now
    visit '/login'
    fill_in 'User name', with: 'nonadmin'
    fill_in 'Password', with: 'secret'
    click_button 'Continue'
  end
end
