require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#from_omniauth' do
    let(:data) do
      {
        uid: '123', info: {
          name: 'Volmer',
          nickname: 'volmer',
          image: 'http://img.com/img.jpg',
          email: 'volmer@example.com'
        },
        credentials: { token: '123abc' }
      }
    end

    it 'fetches an existing user' do
      existing_user = User.create!(uid: '123', token: 'xyz')
      expect(User.from_omniauth(data)).to eq existing_user
    end

    it 'creates an user based on the given data' do
      user = User.from_omniauth(data)
      expect(user).to be_persisted
      expect(user.uid).to eq '123'
      expect(user.name).to eq 'Volmer'
      expect(user.nickname).to eq 'volmer'
      expect(user.email).to eq 'volmer@example.com'
      expect(user.image).to eq 'http://img.com/img.jpg'
      expect(user.token).to eq '123abc'
    end
  end
end
