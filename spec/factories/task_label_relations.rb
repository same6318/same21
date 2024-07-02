FactoryBot.define do
  factory :task_label_relation do
    association :task
    association :label
  end
end
