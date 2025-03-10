class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  
# 検索機能のスコープ
  scope :search_by_name, ->(query, match_type) {
    case match_type
    when 'perfect' then where(name: query)
    when 'forward' then where('name LIKE ?', "#{query}%")
    when 'backward' then where('name LIKE ?', "%#{query}")
    when 'partial' then where('name LIKE ?', "%#{query}%")
    else all
    end
  }

 #フォロー機能のアソシエーション
  #follower_id=自分
  #follow_id=相手

  #自分がフォローしたり、アンフォローしたりするための記述
  # has_many :フォロー関係（自分が誰かをフォローしている）,class_name: "本当のテーブル名", foreign_key: "フォローする側（自分）のidのカラム", dependent: :destroy
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  #sourceは本当はfollowed_idとなっていてカラム名を示している。
  #フォロー一覧を表示するための記述
  # has_many :自分がフォローしている人たち, active_relationshipsテーブルを通して, source: :フォローされている側のカラムを参照
    has_many :followings, through: :active_relationships, source: :followed


    has_many :reverse_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    #フォロワー一覧を表示するための記述
    has_many :followers, through: :reverse_relationships, source: :follower


    # フォロー機能のメソッド
    def follow(user_id)
      active_relationships.create(followed_id: user_id)
    end
  
    def unfollow(user_id)
      active_relationships.find_by(followed_id: user_id).destroy
    end

    def following?(user)
      followings.include?(user)
    end

  # プロフィール画像表示
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
