require 'rails_helper'

RSpec.describe "ユーザモデル機能", type: :model do

  describe 'バリデーションのテスト' do
    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name:"", email:"user@test.com", admin:false, password: "123456", password_confirmation: "123456")
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name:"User", email:"", admin:false, password: "123456", password_confirmation: "123456")
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name:"User", email:"user@test.com", admin:false, password: "", password_confirmation: "123456")
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        user1 = User.create(name:"User1", email:"User@test.com", admin:false, password: "123456", password_confirmation: "123456")
        user2 = User.create(name:"User2", email:"User@test.com", admin:false, password: "123456", password_confirmation: "123456")
        expect(user1).to be_valid
        expect(user2).not_to be_valid
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name:"User", email:"user@test.com", admin:false, password: "12345", password_confirmation: "12345")
        expect(user).not_to be_valid
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user = User.create(name:"NewUser", email:"Newuser@test.com", admin:false, password: "123456", password_confirmation: "123456")
        expect(user).to be_valid
      end
    end
  end

end
