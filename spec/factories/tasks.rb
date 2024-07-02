FactoryBot.define do
  factory :task do
    title { "TEST" }
    content { "Content" }
    deadline_on { "2024-02-18" }
    priority { 1 }
    status { 0 }
    association :user #ここでユーザーを作成

    trait :with_label do
      after(:create) do |task|
        label = create(:label)
        task.task_label_relations.create!(label: label)
      end
    end
  end

  #存在しないクラス名をテストデータに作る場合は、class: Taskとクラスの定義が必要。
  factory :second_task, class: Task do
    title { "TEST2" }
    content { "Content2" }
    deadline_on { "2024-02-17" }
    priority { 2 }
    status { 1 }
  end

  factory :third_task, class: Task do
    title { "TEST3"}
    content { "Content3" }
    deadline_on { "2024-02-16" }
    priority { 0 }
    status { 2 }
  end

  factory :label_task, class: Task do
    title { "TEST4"}
    content { "Content4" }
    deadline_on { "2024-07-01" }
    priority { 0 }
    status { 0 }

    trait :with_task_label_relations do
      after(:create) do |task|
        task_label_relation = FactoryBot.create(:task_label_relations, :sequence)
        create_list(:label, 1, )
      end
    end
  end

end
