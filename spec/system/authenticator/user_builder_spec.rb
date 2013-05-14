require_relative '../../../app/system/authenticator/user_builder'

describe Authenticator::UserBuilder do
  subject { Authenticator::UserBuilder.new account: account, user_storage: user_storage }
  let(:account) { mock 'Account' }
  let(:user_storage) { mock 'UserStorage' }
  let(:user) { mock 'User' }

  context "starting to build a new user" do
    context "without permission" do
      it "is not allowed" do
        account.stub(:admin?).and_return(false)
        expect { subject.start }.to raise_error(Authenticator::SecurityBreach)
      end
    end
    context "with permission" do
      it "builds a new user and passes it to the caller" do
        account.stub(:admin?).and_return(true)
        user_storage.should_receive(:new).and_return(user)

        expect { | b | subject.start(&b) }.to yield_with_args(user)
      end
    end
  end

  context "creating a new user record" do
    let(:params) { mock 'Params' }

    context "without permission" do
      it "is not allowed" do
        account.stub(:admin?).and_return(false)
        expect { subject.create_using(params) }.to raise_error(Authenticator::SecurityBreach)
      end
    end

    context "with permission" do
      before :each do
        account.stub(:admin?).and_return(true)
      end

      context "when given valid details" do
        it "creates a user" do
          user_storage.should_receive(:create!).with(params).and_return(user)
          expect { | b | subject.create_using(params, &b) }.to yield_with_args(user)
        end
      end

      context "when given invalid details" do
        let(:error) { Exception }

        it "raises an error" do
          user_storage.should_receive(:create!).with(params).and_raise(error)
          expect { subject.create_using(params) }.to raise_error(error)
        end
      end
    end
  end
end
