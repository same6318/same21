class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: { message: 'を入力してください'}, length: { maximum: 30 }
  validates :email, presence: { message: 'を入力してください'}, length: { maximum: 255 }
  validates :email, confirmation: true #重複チェック
  validates :email, uniqueness: { message: 'はすでに使用されています'} #値の重複チェック
  before_validation { email.downcase! }

  has_secure_password #passwordとpassword_confirmationの仮想カラムが使える。
  validates :password, presence: true, length: { minimum: 6, message: 'は6文字以上で入力してください'}
  #日本語化の部分でblankのところが定義されている場合、オプションで追加でメッセージを付与する必要はない。

  before_destroy :ensure_admin_presence, prepend: true
  #削除する前に確認する
  before_update :admin_count

  private

    def ensure_admin_presence
      #binding.irb
      if self.admin? && User.where(admin: true).count == 1
        throw :abort
        # return false
      end
      # before_destroy自体がfalseを返すので、コールバック自体を止めないと、dependの方が働くのかな？
      # server errorにする＝raiseは使えない。
      # self.admin?のselfは削除該当のユーザー。
    end

    def admin_count
      # binding.irb
      if self.will_save_change_to_admin? && User.where(admin: true).count == 1
        throw :abort
        # return false
      end
    end

end
