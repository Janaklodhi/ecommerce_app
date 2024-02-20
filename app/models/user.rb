class User < ApplicationRecord
  before_create :generate_confirmation_token
  has_one :cart
  has_many :articles, dependent: :destroy
  has_many :comments
  has_many :orders
  has_secure_password
  validates_associated :articles, on: :create
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  validate :check_email_format
  validate :password_digest

  enum role: { admin: 0, client: 1 }

  private

  def generate_confirmation_token
    byebug
    self.confirmation_token = SecureRandom.urlsafe_base64
  end

  def check_email_format
    regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    unless email =~ regex
      errors.add(:email, "is not in a valid format")
    end
  end

  def password_format
    unless password =~ /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}\z/
      errors.add(:password, "must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, and one digit")
    end
  end

end
