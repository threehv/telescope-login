require_relative '../../../app/system/authenticator/find_users'

describe Authenticator::FindUsers do
  subject { Authenticator::FindUsers.new account: account, user_storage: user_storage }
  let(:account) { mock('Account').as_null_object }
  let(:user_storage) { mock('ActiveRecord Users', all: users).as_null_object }
  let(:users) { [] }

  context "listing users" do
    context "when not an administrator" do
      it "is not allowed" do
        account.stub(:admin?).and_return(false)
        expect { subject.all }.to raise_error(Authenticator::SecurityBreach)
      end
    end
    context "when an administrator" do
      let(:query) { 'some-name' }

      before :each do
        account.stub(:admin?).and_return(true)
      end

      it "retrieves all users from the storage provided and yields the results" do
        expect { | b | subject.all(&b) }.to yield_with_args(users)
      end

      it "retrieves users matching the given name" do
        user_storage.should_receive(:where).with('login like ?', "%#{query}%").and_return(users)
        expect { | b | subject.all(query, &b) }.to yield_with_args(users)
      end
    end
  end

  context "finding an individual user" do
    context "when not an administrator" do
      it "is not allowed" do
        account.stub(:admin?).and_return(false)
        expect { subject.find('username') }.to raise_error(Authenticator::SecurityBreach)
      end
    end

    context "when an administrator" do
      let(:user) { mock 'User' }

      it "asks the user storage for the given user" do
        account.stub(:admin?).and_return(true)
        user_storage.should_receive(:find_by_login).with('username').and_return(user)

        expect { | b | subject.find('username', &b) }.to yield_with_args(user)
      end
    end
  end
end
