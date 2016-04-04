class IdeaAssignment < ActiveRecord::Base
  belongs_to :groupable, polymorphic: true
  belongs_to :idea
end
