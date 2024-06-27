require 'rails_helper'

 RSpec.describe 'ユーザ管理機能', type: :system do

  # before do
  #   driven_by(:selenium_chrome_headless)
  # end

   describe '登録機能' do
     context 'ユーザを登録した場合' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        visit new_session_path
        fill_in "session[email]", with: "User@test.com"
        fill_in "session[password]", with: "123456"
        click_button "ログイン"
      end  
       it 'タスク一覧画面に遷移する' do
        expect(page).to have_text("タスク一覧")
       end
     end
     context 'ログインせずにタスク一覧画面に遷移した場合' do
       it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_text("ログインしてください")
      end
     end
   end

   describe 'ログイン機能' do
    let!(:user) { FactoryBot.create(:user) }
    before do
      visit new_session_path
      fill_in "session[email]", with: "User@test.com"
      fill_in "session[password]", with: "123456"
      click_button "ログイン"
    end
  
     context '登録済みのユーザでログインした場合' do
       it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_text("ログインしました")
       end
       it '自分の詳細画面にアクセスできる' do
        visit user_path(user.id)
        expect(page).to have_text("User")
       end
       it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        user5 = FactoryBot.create(:user5)
        task = FactoryBot.create(:task, title:"桃",user_id:user.id)
        visit user_path(user5.id)
        # binding.irb
        expect(page).to have_text("桃")
       end
       it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link "ログアウト"
        expect(page).to have_text("ログアウトしました")
       end
     end
   end

   describe '管理者機能' do
    let!(:user5) { FactoryBot.create(:user5) }
    before do
      visit new_session_path
      fill_in "session[email]", with: "User5@test.com"
      fill_in "session[password]", with: "123456"
      click_button "ログイン"
    end

     context '管理者がログインした場合' do
       it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_text("ユーザ一覧ページ")
       end
       it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in "user[name]", with: "スペックテスト"
        fill_in "user[email]", with: "spec@test.com"
        fill_in "user[password]", with: "123456"
        fill_in "user[password_confirmation]", with: "123456"
        check "user[admin]"
        click_button "登録する"
       end
       it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(user5.id)
        expect(page).to have_text("ユーザ詳細ページ")
       end
       it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        user = FactoryBot.create(:user)
        visit edit_admin_user_path(user.id)
        fill_in "user[name]", with: "スペックテスト"
        fill_in "user[email]", with: "spec@test.com"
        fill_in "user[password]", with: "123456"
        fill_in "user[password_confirmation]", with: "123456"
        uncheck "user[admin]"
        click_button "更新する"
        expect(page).to have_text("スペック")
       end
       it 'ユーザを削除できる' do
        user = FactoryBot.create(:user,name:"スペック")
        visit admin_users_path
        # binding.irb
        delete_linkposition = 1 #削除する行を変更可能にする。
        all("tbody tr")[delete_linkposition].click_link "削除"
        expect(page).not_to have_text("スペック")
       end
     end
     context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        click_link "ログアウト"
        visit new_session_path
        fill_in "session[email]", with: "User@test.com"
        fill_in "session[password]", with: "123456"
        click_button "ログイン"
        # binding.irb
      end
       it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        visit admin_users_path
        # binding.irb
        expect(page).to have_text("管理者以外アクセスできません")
       end
     end
   end
 end