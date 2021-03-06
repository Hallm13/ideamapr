class Admin < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable
  def has_password?(p)
    self.valid_password? p
  end

  has_secure_token :auth_token
  has_many :surveys, inverse_of: :owner, as: :owner
  
  rails_admin do
    object_label_method do
      :email
    end
  end
end
