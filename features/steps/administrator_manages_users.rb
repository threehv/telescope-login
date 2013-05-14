class Spinach::Features::AdministratorManagesUsers < Spinach::FeatureSteps
  include AdminHelpers

  step 'I choose to add a user' do
    click_link 'Add user'
  end

  step 'I enter their username, password and email' do
    fill_in 'Login', with: 'example'
    fill_in 'Password', with: 'secret123'
    fill_in 'Password confirmation', with: 'secret123'
    fill_in 'Email', with: 'example@example.com'
    click_button 'Save'
  end

  step 'I enter incorrect details' do
    fill_in 'Login', with: 'a'
    fill_in 'Password', with: 'secret123'
    fill_in 'Password confirmation', with: 'something else'
    fill_in 'Email', with: 'notanemail'
    click_button 'Save'
  end

  step 'the user should be added' do
    user = Masq::Account.where(email: 'example@example.com').first
    expect(user).to_not be_nil
    expect(user.login).to be == 'example'
    expect(Masq::Account.authenticate('example', 'secret123')).to be == user
  end

  step 'I should see an error message' do
    expect(page).to have_content('Unable to add user')
  end

  step 'the user should not be added' do
    user = Masq::Account.where(email: 'notanemail').first
    expect(user).to be_nil
  end

  step 'I choose to edit a user' do
    within "#account_#{@users.first.id}" do
      click_link 'Edit'
    end
  end

  step 'I update their username and email' do
    fill_in 'Login', with: 'newname'
    fill_in 'Email', with: 'newname@example.com'
    click_button 'Save'
  end

  step 'the user should be updated' do
    @users.first.reload
    expect(@users.first.login).to be == 'newname'
    expect(@users.first.email).to be == 'newname@example.com'
  end

  step 'I choose to delete a user' do
    within "#user_#{@users.first.id}" do
      click_link 'Delete'
    end
  end

  step 'I confirm the deletion' do
    click_button 'Delete'
  end

  step 'the user should be deleted' do
    expect(Masq::Account.find_by_id(@users.first.id)).to be_nil
  end

end
