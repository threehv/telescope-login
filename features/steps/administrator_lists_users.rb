class Spinach::Features::AdministratorListsUsers < Spinach::FeatureSteps
  include AdminHelpers

  step 'I visit the home page' do
    visit '/'
  end

  step 'I should be able to visit the users page' do
    expect(page).to have_content('View users')
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
