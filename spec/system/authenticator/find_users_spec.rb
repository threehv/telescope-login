require_relative '../../../app/system/authenticator/find_users'

describe Authenticator::FindUsers do
  subject { Authenticator::FindUsers.new account: account, user_storage: user_storage }
  let(:account) { mock('Account').as_null_object }
  let(:user_storage) { mock('ActiveRecord Users', in_order: users).as_null_object }
  let(:users) { [] }

  context "listing users" do
    context "when not an administrator" do
      it "is not allowed" do
        account.stub(:admin?).and_return(false)
        expect { subject.all }.to raise_error(Authenticator::SecurityBreach)
      end
    end
    context "when an administrator" do
      it "retrieves all users from the storage provided and yields the results" do
        account.stub(:admin?).and_return(true)
        expect { | b | subject.all(&b) }.to yield_with_args(users)
      end
    end
  end
end
