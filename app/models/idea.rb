class Idea < ActiveRecord::Base
  # We feed this attribute in when sending data to the survey
  attr_accessor :budget
  def self.viewbox_list
    unless Struct.const_defined? 'IdeaVbStruct'
      Struct.new('IdeaVbStruct', :partial_name, :title, :box_key, :shown, :expected_length, :help_text) do
        def initialize(*args)
          super
          self.shown = true
          self.expected_length ||= -1 
        end
      end
    end
    
    [Struct::IdeaVbStruct.new('title', 'Idea Title', 'idea-title', true, 10, 'Add a short title'),
     Struct::IdeaVbStruct.new('description', 'Idea Intro', 'idea-description', true, 15, 'Describe your idea'),
     Struct::IdeaVbStruct.new('attachments', 'Attachments', 'idea-attachments', true, 15, 'Upload attachments')
    ]
  end
  
  def surveys
    Survey.where('id in (?)',
                 IdeaAssignment.where('idea_id = ? and groupable_type = ?', self.id, 'Survey').pluck(:groupable_id))
  end
  def survey_questions
    SurveyQuestion.where('id in (?)',
                 IdeaAssignment.where('idea_id = ? and groupable_type = ?', self.id, 'SurveyQuestion').pluck(:groupable_id))
  end
  
  validates :title, length: {minimum: 10}
  has_many :idea_assignments, dependent: :destroy
  has_many :download_files
end
