class Micropost < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  scope :newest, ->{order(created_at: :desc)}
  scope :by_user_ids, ->(user_ids){where user_id: user_ids}
  delegate :name, to: :user, prefix: true
  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.micropost.content_max}
  validates :images, content_type: {in: Settings.micropost.image_type,
                                    message: :wrong_format},
                     size: {less_than: Settings.micropost.image_size.megabytes,
                            message: :too_big}

  def display_image photo
    photo.variant resize_to_limit: Settings.micropost.resize_to_limit
  end
end
