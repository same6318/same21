require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        task = FactoryBot.create(:task, title: "会議資料作成") #factoryボットの情報を上書きして作成
        if task.save
          visit task_path(task)
          expect(page).to have_text("会議")
        else
          visit new_task_path
        end
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        #テストで使用するタスクを登録
        task = FactoryBot.create(:task)
        #タスク一覧画面に遷移
        visit tasks_path
        #binding.irb
        #遷移したpageに作成したタスクの文字列がhave_contentしているかをexpectで確認する。
        expect(page).to have_content("Content")
      end
    end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:second_task)
        visit task_path(task)
        expect(page).to have_text("メール")
       end
     end
  end

end
  # before do
  #   driven_by(:rack_test)
  # end

  # pending "add some scenarios (or delete) #{__FILE__}"
