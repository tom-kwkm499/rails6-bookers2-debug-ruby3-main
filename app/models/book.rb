class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}


  # 検索機能のスコープ
  scope :search_by_title, ->(query, match_type) {
    case match_type
    when 'perfect' then where(title: query)
    when 'forward' then where('title LIKE ?', "#{query}%")
    when 'backward' then where('title LIKE ?', "%#{query}")
    when 'partial' then where('title LIKE ?', "%#{query}%")
    else all
    end
  }


  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
