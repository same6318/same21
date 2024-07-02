require 'rails_helper'

RSpec.describe 'ラベル管理機能', type: :system do
    
  let!(:user) { FactoryBot.create(:user) }
  let!(:label) { FactoryBot.create(:label, user_id:user.id) }
  let!(:second_label) { FactoryBot.create(:second_label, user_id:user.id) }
  let!(:third_label) { FactoryBot.create(:third_label, user_id:user.id) }
  before do
    visit new_session_path
    fill_in "session[email]", with: "User@test.com"
    fill_in "session[password]", with: "123456"
    click_button "ログイン"
  end

  describe '登録機能' do
    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        visit labels_path
        expect(page).to have_text("TEST")
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        visit labels_path
        # binding.irb
        expect(page).to have_text("タイトル")
        expect(page).to have_text("ラベル")
        expect(page).not_to have_text("ラベル2")
      end
    end
  end
end