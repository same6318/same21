FactoryBot.define do
  factory :task_label_relation do
    name { "食べ物" }
    task { association :task }
    label { association :label }
  end
end
