class SurveyQuestion < ActiveRecord::Base
  def question_type_enum
    (0..QuestionType.max_type).inject({}) do |acc, i|
      acc[QuestionType.name(i)] = i
      acc
    end
  end
  
  def self.valid_type?(id)
    id.to_i >= 0 and id.to_i <= QuestionType.max_type
  end
  class QuestionType
    PROCON=0
    RANKING=1
    YEANAY=2
    BUDGETING=3
    TOPPRI=4

    def self.default_title(id)
      default_titles_array[id.to_i]
    end

    def self.max_type
      option_array.map { |i| i[1]}.sort.last
    end
    
    def self.prompts
      {'Pro/Con' => 'Supply pros and cons for these ideas',
       'Ranking' => 'Rank these ideas in order of importance',
       'Yea/Nay' => 'Mark the ideas in this list that you consider important',
       'Budgeting' => 'Perform a budgeting exercise with these ideas',
       'Top Priority' => 'Tell us which idea you pick as the top priority'
      }
    end
    
    def self.default_titles_array
      ['Pro/con question', 'Ranking question', 'Yea/Nay question', 'Budgeting question', 'Top priority question']
    end
    
    def self.option_array
      [['Pro/Con', PROCON], ['Ranking', RANKING], ['Yea/Nay', YEANAY], ['Budgeting', BUDGETING], ['Top Priority', TOPPRI]]
    end

    def self.name(id)
      if id.nil?
        nil
      else
        option_array.select { |i| i[1] == id }.first&.first
      end
    end
  end
  
  has_many :question_assignments, dependent: :destroy
  has_many :surveys, through: :question_assignments
  
  has_many :ideas, through: :idea_assignments
  has_many :idea_assignments, as: :groupable, inverse_of: :groupable, dependent: :destroy

  validates :title, length: {minimum: 10}
  def question_type_name
    QuestionType.name(question_type)
  end

  rails_admin do
    compact_show_view=false
    object_label_method do
      :title
    end
    list do
      field :title
      field :question_type do
        formatted_value do
          SurveyQuestion::QuestionType.name(value)
        end
      end
    end

    show do
      field :title
      field :question_type do
        formatted_value do
          SurveyQuestion::QuestionType.name(value)
        end
      end
    end
  end
end
