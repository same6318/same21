FactoryBot.define do
  factory :label do
    name { "TEST" }
    user { nil } #labelのユーザーは無しにしないと、withで作る時に弾かれる。
  end

  factory :second_label, class: Label do
    name { "タイトル" }
  end


  factory :third_label, class: Label do
    name { "ラベル" }
  end

  factory :forth_label, class: Label do
    name { "ラベル2" }
  end


end
