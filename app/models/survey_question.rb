class SurveyQuestion < ActiveRecord::Base
  class QuestionType
    PROCON=0
    RANKING=1
    YEANAY=2
    BUDGETING=3
    TOPPRI=4

    def self.default_title(id)
      prompts_array[id]
    end

    def self.prompts_array
      ['Pro/con question', 'Ranking question', 'Yea/Nay question', 'Budgeting question', 'Top priority question']
    end
    
    def self.option_array
      [['Pro/Con', 0], ['Ranking', 1], ['Yea/Nay', 2], ['Budgeting', 3], ['Top Priority', 4]]
    end

    def self.multi_idea_commands
      [['Ranking', 1], ['Yea/Nay', 2], ['Budgeting', 3], ['Top Priority', 4]]
    end
    
    def self.name(id)
      if id.nil?
        nil
      else
        option_array.select { |i| i[1] == id }.first&.first
      end
    end
  end
  
  has_many :question_assignments
  has_many :surveys, through: :question_assignments
  
  has_many :ideas, through: :idea_assignments
  has_many :idea_assignments, as: :groupable

  validates :title, length: {minimum: 10}
end
