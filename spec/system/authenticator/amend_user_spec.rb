require_relative '../../../app/system/authenticator/amend_user'

describe Authenticator::AmendUser do
  subject { Authenticator::AmendUser.new account: account, user_storage: user_storage }
  let(:account) { mock 'Account' }
  let(:user_storage) { mock 'User Storage' }
  let(:user_name) { 'someone' }
  let(:user) { mock 'User' }

  context "updating a user" do
    let(:params) { mock 'Params' }
    context "when not an administrator" do
      it "is not allowed" do
        account.stub(:admin?).and_return(false)
        expect { subject.update(user_name, with: params) }.to raise_error(Authenticator::SecurityBreach)
      end
    end

    context "when an administrator" do
      before :each do
        account.stub(:admin?).and_return(true)
        user_storage.should_receive(:find_by_login).with(user_name).and_return(user)
      end

      context "and given valid parameters" do
        it "updates the user" do
          user.should_receive(:update_attributes!).with(params).and_return(true)
          expect { | b | subject.update(user_name, { with: params}, &b) }.to yield_with_args(user)
        end
      end

      context "and given invalid parameters" do
        let(:error) { Exception }
        it "raises an error" do
          user.should_receive(:update_attributes!).with(params).and_raise(error)
          expect { subject.update(user_name, with: params) }.to raise_error(error)
        end
      end
    end
  end

  context "deleting a user" do
    context "when not an administrator" do
      it "is not allowed" do
        account.stub(:admin?).and_return(false)
        expect { subject.delete(user_name) }.to raise_error(Authenticator::SecurityBreach)
      end
    end

    context "when you are an administrator" do
      it "asks the user storage to delete the account" do
        account.stub(:admin?).and_return(true)
        user_storage.should_receive(:find_by_login).with(user_name).and_return(user)
        user.should_receive(:destroy)

        expect { | b | subject.delete(user_name, &b) }.to yield_control
      end
    end
  end
end
