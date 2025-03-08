class Relationship < ApplicationRecord

  # userへのアソシエーション
  # class_nameがuserモデルとリンクしている(class_nameは大文字でなければNG）
  # follower_id は users テーブルの id に紐づく
  # followed_id も users テーブルの id に紐づく
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

end
