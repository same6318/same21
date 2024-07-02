require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  # before do
  #   driven_by(:selenium_chrome_headless)
  # end
  let!(:user) { FactoryBot.create(:user) }
  before do
    visit new_session_path
    fill_in "session[email]", with: "User@test.com"
    fill_in "session[password]", with: "123456"
    click_button "ログイン"
  end

  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        task = FactoryBot.create(:task, title: "会議資料作成", user_id:user.id) #factoryボットの情報を上書きして作成
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
    let!(:task) { FactoryBot.create(:task, created_at:"2022-02-18", user_id:user.id) }
    let!(:second_task) { FactoryBot.create(:second_task, created_at:"2022-02-17", user_id:user.id) }
    let!(:third_task) { FactoryBot.create(:third_task, created_at:"2022-02-16", user_id:user.id) }

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
      let!(:task) { FactoryBot.create(:task,title: "桃", user_id:user.id) }
      let!(:second_task) { FactoryBot.create(:second_task, user_id:user.id) }
      let!(:third_task) { FactoryBot.create(:third_task, user_id:user.id) }
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
        expect(task_titles).to eq ["TEST3","TEST2","桃"]
        expect(task_titles).not_to eq ["桃","TEST2","TEST3"]
      end
    end

    describe 'ソート機能' do
      let!(:task) { FactoryBot.create(:task, user_id:user.id) }
      let!(:second_task) { FactoryBot.create(:second_task, user_id:user.id) }
      let!(:third_task) { FactoryBot.create(:third_task, deadline_on:"2024-01-10", user_id:user.id) }
      before do
        visit tasks_path
      end
      context '「終了期限」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          click_on "終了期限"
          deadline_dates = all("tbody tr").map do |date|
            date.text.match(/\d{4}-\d{2}-\d{2}/)[0] #[0]を記載しないとMatchDateオブジェクトが返るだけ。
          end
          # save_and_open_page
          # binding.irb
          expect(deadline_dates).to eq ["2024-01-10", "2024-02-17", "2024-02-18"]
          # allメソッドを使って複数のテストデータの並び順を確認する
        end
      end
      context '「優先度」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          click_link('優先度')
          # sleep 1
          # save_and_open_page
          priority_dates = all("tbody tr").map do |date|
            date.find_all("td")[4].text
          end
          # binding.irb
          expect(priority_dates).to eq ["高","中","低"]
          # allメソッドを使って複数のテストデータの並び順を確認する
        end
      end
    end

    describe '検索機能' do
      let!(:task) { FactoryBot.create(:task, title:"タスク作成", user_id:user.id) }
      let!(:second_task) { FactoryBot.create(:second_task, title:"桃を作成", user_id:user.id) }
      let!(:third_task) { FactoryBot.create(:third_task, deadline_on:"2024-01-10", user_id:user.id) }
      before do
        visit tasks_path
      end

      context 'タイトルであいまい検索をした場合' do
        it "検索ワードを含むタスクのみ表示される" do
          fill_in "search[title]", with: "作"
          # binding.irb
          click_on "検索"
          expect(page).to have_content("タスク")
          expect(page).to have_content("桃")
          expect(page).not_to have_content("TEST")
          # binding.irb
          input = "桃"
          result = Task.title_like(input)
          expect(result.count).to eq 1
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        end
      end
      context 'ステータスで検索した場合' do
        it "検索したステータスに一致するタスクのみ表示される" do
          select "完了", from: "search[status]"
          # save_and_open_page
          click_on "検索"
          # binding.irb
          expect(page).not_to have_content("桃")
          expect(page).not_to have_content("タスク作成")
          expect(page).to have_content("TEST3")
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        end
      end
      context 'タイトルとステータスで検索した場合' do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          fill_in "search[title]", with: "桃"
          select "着手中", from: "search[status]"
          click_on "検索"
          expect(page).not_to have_content("タスク作成")
          expect(page).to have_content("桃")
          input = "桃"
          result = Task.title_like(input)
          expect(result.count).to eq 1
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        end
      end
    end

  end



  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:second_task, user_id:user.id)
        visit task_path(task)
        expect(page).to have_text("TEST2")
       end
     end
  end

  describe '検索機能' do
    let!(:user) { FactoryBot.create(:user, email:"aaa@sample.com") }
    let!(:label) { FactoryBot.create(:label, name: "食べ物", user_id:user.id) }
    let!(:second_label) { FactoryBot.create(:second_label, user_id:user.id) }
    let!(:third_label) { FactoryBot.create(:third_label, name: "旅行先", user_id:user.id) }
    before do
      visit new_session_path
      fill_in "session[email]", with: "aaa@sample.com"
      fill_in "session[password]", with: "123456"
      click_button "ログイン"
    end

    context 'ラベルで検索をした場合' do
      it "そのラベルの付いたタスクがすべて表示される" do
        task = FactoryBot.create(:second_task ,title: "出現するタイトル", user_id: user.id)
        task2 = FactoryBot.create(:third_task, title: "コンテスト", user_id: user.id)
        visit edit_task_path(task)
        binding.irb
        select "高", from: "task[priority]"
        select "着手中", from: "task[status]"
        # label_id = user.labels.first.id
        # checkbox = find("input[type='checkbox'][value='#{label_id}']", visible: false)
        # checkbox.check
        check "食べ物"
        click_on "更新する"
        visit tasks_path
        select "食べ物", from: "search[label]"
        click_on "検索"
        binding.irb
        # save_and_open_page
        expect(page).to have_text("出現するタイトル")
        expect(page).not_to have_text("コンテスト")
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      end
    end
  end


end
  # before do
  #   driven_by(:rack_test)
  # end

  # pending "add some scenarios (or delete) #{__FILE__}"
