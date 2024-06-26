class AddUserToTasks < ActiveRecord::Migration[6.1]
  def change
    add_reference :tasks, :user, null: false, foreign_key: true
  end
  #先にnotnull制約を追加してマイグレーションさせると、
  #column "user_id" of relation "tasks" contains null valuesで弾かれるので、
  #最初はnull:trueでマイグレーションファイルを作成する。

  #→結局、後からnull:falseでnotnull制約を追加しようとしても既存のデータにuser_id:nullのものがあるから、エラーになる。
  #マイグレーションファイルでユーザーを作っておく方法もあるようだが、本番環境でのマイグレーション時にエラーが起きないようにするには？
end
