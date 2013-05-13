class Spinach::Features::UserLogsInAndLogsOut < Spinach::FeatureSteps
  step 'that I have a user account' do
    @me = Masq::Account.create! login: 'myname', email: 'me@mysite.com', admin: false, password: 'secret', password_confirmation: 'secret', enabled: true, activated_at: Time.now
  end

  step 'I visit the login page' do
    visit '/login'
  end

  step 'I log in' do
    fill_in 'User name', with: 'myname'
    fill_in 'Password', with: 'secret'
    click_button 'Continue'
  end

  step 'I should be logged in as expected' do
    expect(page).to have_content('Log out')
    expect(page).to_not have_content('View users')
  end

  step 'I log in with incorrect details' do
    fill_in 'User name', with: 'me'
    fill_in 'Password', with: 'notthepassword'
    click_button 'Continue'
  end

  step 'I should not be logged in' do
    expect(page).to_not have_content('Log out')
  end

  step 'I should be offered the chance of logging in again' do
    expect(page).to have_css('.login')
  end

  step 'I have already logged in' do
    visit '/login'
    fill_in 'User name', with: 'myname'
    fill_in 'Password', with: 'secret'
    click_button 'Continue'
  end

  step 'I choose to log out' do
    click_link 'Log out'
  end

  step 'I should be logged out' do
    visit '/login'
    expect(page).to have_css('.login')
  end
end
