require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  # before do
  #   driven_by(:selenium_chrome_headless)
  # end

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
    let!(:task) { FactoryBot.create(:task, created_at:"2022-02-18") }
    let!(:second_task) { FactoryBot.create(:second_task, created_at:"2022-02-17") }
    let!(:third_task) { FactoryBot.create(:third_task, created_at:"2022-02-16") }

    context '一覧画面に遷移した場合' do

      # it '登録済みのタスク一覧が表示される' do
      #   #テストで使用するタスクを登録
      #   task = FactoryBot.create(:task)
      #   #タスク一覧画面に遷移
      #   visit tasks_path
      #   #binding.irb
      #   #遷移したpageに作成したタスクの文字列がhave_contentしているかをexpectで確認する。
      #   expect(page).to have_content("Content")
      # end
      before do
        visit tasks_path
        # save_and_open_page
      end


      it "作成済みのタスク一覧が作成日時の降順で表示される" do
        task_dates = all("tbody tr").map do |task| 
          task.text.match(/\d{4}\/\d{2}\/\d{2}/)[0] #[0]を記載しないとMatchDateオブジェクトが返るだけ。
          #(/\d{4}\/\d{2}\/\d{2}/に一致したものだけをMatchDataオブジェクトとして返す＝要素は1個だけだが、[0]で指定してないと取り出しは不可)
        end
        #binding.irb
        expect(task_dates).to eq ["2022/02/18", "2022/02/17", "2022/02/16"]
      end
    end

    context "新たにタスクを作成した場合" do
      let!(:task) { FactoryBot.create(:task) }
      let!(:second_task) { FactoryBot.create(:second_task) }
      let!(:third_task) { FactoryBot.create(:third_task) }
      before do
        visit tasks_path
        # save_and_open_page
      end
      it "新しいタスクが一番上に表示される" do
        tasks = all("tbody tr")
        # task_titles = tasks.map { |task| task.find("td", match: :first).text }
        task_titles = tasks.map do |task|
          task.find("td", match: :first).text
        end
        #binding.irb
        expect(task_titles).to eq ["TEST3","TEST2","TEST"]
        expect(task_titles).not_to eq ["TEST","TEST2","TEST3"]
      end
    end

    describe 'ソート機能' do
      let!(:task) { FactoryBot.create(:task) }
      let!(:second_task) { FactoryBot.create(:second_task) }
      let!(:third_task) { FactoryBot.create(:third_task) }
      before do
        visit tasks_path
      end
      context '「終了期限」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          deadline_dates = all("tbody tr").map do |date|
            date.text.match(/\d{4}\/\d{2}\/\d{2}/)[0] #[0]を記載しないとMatchDateオブジェクトが返るだけ。
            #(/\d{4}\/\d{2}\/\d{2}/に一致したものだけをMatchDataオブジェクトとして返す＝要素は1個だけだが、[0]で指定してないと取り出しは不可)
          end
          binding.irb
          expect(deadline_dates).to eq ["2024/06/24", "2024/02/17", "2024/02/16"]  

          # allメソッドを使って複数のテストデータの並び順を確認する
        end
      end
      context '「優先度」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
        end
      end
    end
    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it "検索ワードを含むタスクのみ表示される" do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        end
      end
      context 'ステータスで検索した場合' do
        it "検索したステータスに一致するタスクのみ表示される" do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        end
      end
      context 'タイトルとステータスで検索した場合' do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        end
      end
    end

  end



  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:second_task)
        visit task_path(task)
        expect(page).to have_text("TEST2")
       end
     end
  end



end
  # before do
  #   driven_by(:rack_test)
  # end

  # pending "add some scenarios (or delete) #{__FILE__}"
