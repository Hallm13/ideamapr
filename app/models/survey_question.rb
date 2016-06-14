class SurveyQuestion < ActiveRecord::Base
  def question_type_enum
    (0..QuestionType.max_type).inject({}) do |acc, i|
      acc[QuestionType.name(i)] = i
      acc
    end
  end

  def self.viewbox_list
    unless Struct.const_defined? 'SurveyQuestionVbStruct'
      Struct.new('SurveyQuestionVbStruct', :partial_name, :title, :box_key, :shown, :expected_length, :help_text) do
        def initialize(*args)
          super
          @expected_length = args[3] if args.size > 3
          self.shown = true
        end

        def expected_length
          @expected_length || -1
        end
      end
    end    
    l = [Struct::SurveyQuestionVbStruct.new('add_title', 'Question Title', 'sq-title', 10, 'Add a title for your survey'),
         Struct::SurveyQuestionVbStruct.new('add_question_type', 'Set Question Type', 'sq-question-type'),
         Struct::SurveyQuestionVbStruct.new('question_prompt', 'Write An Explanation Prompt', 'sq-question-prompt', 15)]

    v = Struct::SurveyQuestionVbStruct.new('set_budget', 'Set Budget', 'sq-set-budget')
    l.push v

    l += [Struct::SurveyQuestionVbStruct.new('add_ideas', 'Add Ideas', 'sq-add-ideas'),
          Struct::SurveyQuestionVbStruct.new('add_fields', 'Add Fields', 'sq-add-fields')]
    
    
    l
  end
  
  def self.valid_type?(id)
    id.to_i >= 0 and id.to_i <= QuestionType.max_type
  end
  class QuestionType
    PROCON=0
    RANKING=1
    BUDGETING=3
    TOPPRI=4
    RADIO_CHOICES=5
    TEXT_FIELDS=6
    
    def self.default_title(id)
      default_titles_array[id.to_i]
    end

    def self.max_type
      option_array.map { |i| i[1]}.sort.last
    end
    
    def self.prompts
      {0 => 'Supply pros and cons for these ideas',
       1 => 'Rank these ideas in order of importance',
       3 => 'Perform a budgeting exercise with these ideas',
       4 => 'Tell us which idea you pick as the top priority',
       5 => 'Select one of the following.',
       6 => 'Fill in the following fields.'
      }
    end
    
    def self.default_titles_array
      ['Pro/con question', 'Ranking question', 'Yea/Nay question', 'Budgeting question', 'Top priority question',
       'Single-choice radio buttons', 'Free-form text fields']
    end
    
    def self.option_array
      [['Pro/Con', PROCON], ['Ranking', RANKING], ['Budgeting', BUDGETING], ['Top Priority', TOPPRI],
       ['Non-idea: Radio', RADIO_CHOICES], ['Non-idea: Fields', TEXT_FIELDS]]
    end

    def self.default_prompt(id)
      prompts[id]
    end
    
    def self.name(id)
      option_array.select { |i| i[1] == id }.first&.first
    end
  end
  
  has_many :question_assignments, dependent: :destroy
  has_many :surveys, through: :question_assignments
  
  has_many :ideas, through: :idea_assignments
  has_many :idea_assignments, as: :groupable, inverse_of: :groupable, dependent: :destroy
  has_one :question_detail
  
  validates :title, length: {minimum: 10}
  def question_type_name
    QuestionType.name(question_type)    
  end

  def set_default_prompt
    self.question_prompt = QuestionType.default_prompt(question_type)
  end

  def response_length
    # Number of idea assignments or details
    idea_ct = idea_assignments.count
    details_length = question_detail&.details_list&.size || 0
    [idea_ct, details_length].max
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
