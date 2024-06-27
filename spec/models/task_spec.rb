require 'rails_helper'

# RSpec.describe Task, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end


RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title:"", content:"Content")
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title:"TEST", content:"")
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        user = FactoryBot.create(:user)
        task = FactoryBot.create(:task, user_id:user.id)
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, title:"タイトルを作成", user_id: user.id) }
    let!(:second_task) { FactoryBot.create(:second_task, title:"桃は美味しい", user_id: user.id) }
    let!(:third_task) { FactoryBot.create(:third_task, title:"TESTは作成", user_id: user.id) }

    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        input_data = "桃"
        result = Task.title_like(input_data)
        expect(result.first.title).to eq "桃は美味しい"
        expect(Task.title_like("は").count).to eq 2
        expect(Task.title_like("作成")).not_to include(second_task)
        expect(Task.title_like("作成")).to include(task)
        expect(Task.title_like("作成")).to include(third_task)
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
      end
    end

    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.status_is("0")).to include(task)
        expect(Task.status_is("0")).not_to include(second_task)
        expect(Task.status_is("1")).to include(second_task)
        expect(Task.status_is("1")).not_to include(third_task)
        expect(Task.status_is("2").count).to eq 1
        #binding.irb
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.title_and_status_is("作成","0")).to include(task)
        expect(Task.title_and_status_is("作成","0").count).to eq 1
        expect(Task.title_and_status_is("は","2")).to include(third_task)
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
      end
    end
  end

end