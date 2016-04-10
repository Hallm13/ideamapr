class CmsContent < ActiveRecord::Base
  validates :key, presence: true
end
