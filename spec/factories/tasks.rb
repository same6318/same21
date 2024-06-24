FactoryBot.define do
  factory :task do
    title { "TEST" }
    content { "Content" }
    deadline_on { "2024-6-24" }
    priority { 1 }
    status { 1 }
  end

  #存在しないクラス名をテストデータに作る場合は、class: Taskとクラスの定義が必要。
  factory :second_task, class: Task do
    title { "TEST2" }
    content { "Content2" }
    deadline_on { "2024-6-24" }
    priority { 1 }
    status { 1 }
  end

  factory :third_task, class: Task do
    title { "TEST3"}
    content { "Content3" }
    deadline_on { "2024-6-24" }
    priority { 1 }
    status { 1 }
  end

end
