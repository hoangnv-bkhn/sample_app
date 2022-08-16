class User < ApplicationRecord
  before_save :downcase_email
  validates :name, presence: true,
                   length: {maximum: Settings.valid.name_max_len}
  validates :email, presence: true,
                    length: {maximum: Settings.valid.email_max_len},
                    format: {with: Settings.regex.email_regex},
                    uniqueness: true
  validates :password, presence: true,
                       length: {minimum: Settings.valid.password_min_len}
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
