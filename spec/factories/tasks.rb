FactoryBot.define do
  factory :task do
    title { "TEST" }
    content { "Content" }
  end

  #存在しないクラス名をテストデータに作る場合は、class: Taskとクラスの定義が必要。
  factory :second_task, class: Task do
    title { "メール送信" }
    content { "顧客へ営業のメールを送る。" }
  end

end
