class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label_relations, dependent: :destroy
  has_many :labels, through: :task_label_relations

  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  enum priority: { low:0, middle:1, high:2 }
  enum status: { started_yet:0, get_started:1, complete:2 }

  #終了期限の昇順ソート(終了期限が近いもの)
  scope :deadline_asc_sort, -> {order(deadline_on: :asc)}
  #優先度の高い順にソート(=2を上にする＝降順)
  scope :priority_high_sort, -> {order(priority: :desc)}
  #作成日時の新しい順にソート
  scope :created_at_sort, -> {order(created_at: :desc)}

  #タイトルとステータスでの絞り込み検索
  scope :search, -> (search_params) do
    #<ActionController::Parameters {} permitted: true> これが検索欄空白
    #<ActionController::Parameters {"title"=>"", "status"=>"started_yet"} permitted: true> ステータスを入れた場合のsearch_params
    #search_paramsが空白でなければ、以下の処理。
    return if search_params.blank?
    # title_like(search_params[:title])
    #   .status_is(search_params[:status])
    title_and_status_is(search_params[:title], search_params[:status])
        .label_is(search_params[:label])
    #メソッドチェーンで繋げている。
  end
  
  #タイトルが存在する場合、タイトルをlike検索する
  scope :title_like, -> (title) { where('title LIKE ?', "%#{title}%") if title.present? }
  #ステータスが存在する場合、status_isで検索する
  scope :status_is, -> (status) { where(status: status) if status.present? }
  #タイトルもステータスも存在する場合、title_and_statusで検索する
  scope :title_and_status_is, -> (title, status) { title_like(title).status_is(status) }
  #ラベルが存在する場合、label_isで検索する
  scope :label_is, -> (label) { joins(:task_label_relations).where(task_label_relations: { label_id: label }) if label.present? }
  #joinsでテーブルを追加して、where(:探し先のテーブル {探すカラム:渡す引数})
  #whereの書き方注意。
end
