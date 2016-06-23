class IdeaAssignment < ActiveRecord::Base
  belongs_to :groupable, polymorphic: true
  belongs_to :idea

  after_initialize :rank_to_end

  private
  def rank_to_end
    if ordering.nil? and groupable_id.present? and groupable_type.present?
      self.ordering = IdeaAssignment.where(groupable_id: self.groupable_id, groupable_type: self.groupable_type).count
    end
  end
end
