class User < ApplicationRecord
  before_create :ensure_authentication_token
  after_create :excute_after_create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include Avatarable

  has_one :line_account, class_name: 'LineAccount', foreign_key: 'owner_id'

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def excute_after_create
    create_line_account
  end

  private
    def generate_authentication_token
      loop do
        token = Devise.friendly_token(64)
        break token unless User.where(authentication_token: token).first
      end
    end

    def create_line_account
      line_account = LineAccount.new(owner: self)
      line_account.save!
    end
end
