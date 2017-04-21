require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }
  it { should validate_length_of(:password).is_at_least(6) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:session_token) }

  describe 'class_methods' do
    describe '::find_by_credentials' do
      it 'finds a User given a correct email and password' do
        new_user = create(:user)
        expect(User.find_by_credentials(new_user.email, new_user.password)).to eq(new_user)
      end
      it 'returns nil if a matching User cannot be found' do
        expect(User.find_by_credentials('dfsafa', 'fdsafds')).to eq(nil)
      end
    end
    describe '::generate_session_token' do
      it 'returns a random string of length 16' do
        token1 = User.generate_session_token
        token2 = User.generate_session_token
        expect(token1).to_not eq(token2)
        expect(token1.length).to eq(22)
        expect(token2.length).to eq(22)
      end
    end
  end

  describe '#reset_session_token' do
    it 'changes the user\'s session_token in the database' do
      old_token = user.session_token
      user.reset_session_token
      expect(user.session_token).to_not eq(old_token)
      expect(user.session_token.length).to eq(22)
    end
    it 'returns the new session_token' do
      expect(user.reset_session_token).to eq(user.session_token)
    end
  end

  describe '#ensure_session_token' do
    it 'always returns a valid session_token' do
      expect(user.ensure_session_token).to eq(user.session_token)
      expect(user.ensure_session_token.length).to eq(22)
    end
    it 'does not change an existing session_token' do
      user.ensure_session_token
      token = user.session_token
      user.ensure_session_token
      expect(user.session_token).to eq(token)
    end
  end

  describe '#password=' do
    before(:each) { user.password = 'password' }

    it 'sets the password_digest equal to an encrypted password' do
      expect(user.password_digest).to_not be_nil
      expect(user.password_digest).to_not eq('password')
    end
    it 'sets the password instance variable' do
      expect(user.password).to eq('password')
    end
  end

  describe '#is_password?' do
    it 'validates a given password against the password_digest' do
      user.password = 'password'
      expect(user.is_password?('password')).to be true
      expect(user.is_password?('banana')).to be false
    end
  end

end
