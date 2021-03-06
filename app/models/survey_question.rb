class SurveyQuestion < ActiveRecord::Base
  def question_type_enum
    (0..QuestionType.max_type).inject({}) do |acc, i|
      acc[QuestionType.name(i)] = i
      acc
    end
  end

  def self.viewbox_list
    unless Struct.const_defined? 'SurveyQuestionVbStruct'
      Struct.new('SurveyQuestionVbStruct', :partial_name, :title, :box_key, :expected_length, :help_text, :shown) do
        def initialize(*args)
          super
          self.shown = true
        end
      end
    end    
    l = [Struct::SurveyQuestionVbStruct.new('add_title', 'Question Title', 'sq-title', 1, 'Add a title for your survey'),
         Struct::SurveyQuestionVbStruct.new('add_question_type', 'Question Type', 'sq-question-type', -1, 'Types are either those that contain lists of ideas, or those that collect information from the participant'),
         Struct::SurveyQuestionVbStruct.new('question_prompt', 'Write An Explanation Prompt', 'sq-question-prompt', 1, 'The prompt is shown at the top of the survey question screen'),
         Struct::SurveyQuestionVbStruct.new('set_budget', 'Set Budget', 'sq-set-budget', -1, 'This is used in budget questions, as the maximum available spend'),
         Struct::SurveyQuestionVbStruct.new('add_ideas', 'Add Ideas', 'sq-add-ideas', -1, 'Select ideas and set ranked order'),
         Struct::SurveyQuestionVbStruct.new('new_idea_template', 'Question Preview', 'sq-new-idea', -1, ''),
         Struct::SurveyQuestionVbStruct.new('add_fields', 'Add Fields', 'sq-add-fields', -1, 'Select fields and set ranked order')]
    
    l
  end
  
  def self.valid_type?(id)
    id.to_i >= 0 and id.to_i <= QuestionType.max_type
  end
  class QuestionType
    PROCON=0
    RANKING=1
    NEW_IDEA=2
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
      {0 => 'survey_question.helper_defaults.procon',
       1 => 'survey_question.helper_defaults.ranking',
       2 => 'survey_question.helper_defaults.new_idea',
       3 => 'survey_question.helper_defaults.budgeting',
       4 => 'survey_question.helper_defaults.pickone',
       5 => 'survey_question.helper_defaults.nonidea_radio',
       6 => 'survey_question.helper_defaults.nonidea_fields'
      }
    end
    
    def self.default_titles_array
      ['Pro/con question', 'Ranking question', 'Suggest an Idea', 'Budgeting question', 'Top priority question',
       'Single-choice radio buttons', 'Free-form text fields']
    end
    
    def self.option_array
      [['Pro/Con', PROCON], ['Ranking', RANKING], ['Suggest Idea', NEW_IDEA], ['Budgeting', BUDGETING], ['Top Priority', TOPPRI],
       ['Non-idea: Radio', RADIO_CHOICES], ['Non-idea: Fields', TEXT_FIELDS]]
    end
    def self.filename_array
      [['procon', PROCON], ['ranking', RANKING], ['newidea', NEW_IDEA], ['budgeting', BUDGETING], ['toppri', TOPPRI],
       ['radio', RADIO_CHOICES], ['fields', TEXT_FIELDS]]
    end

    def self.name(id)
      option_array.select { |i| i[1] == id }.first&.first
    end
    def self.name_as_filename(id)
      filename_array.select { |i| i[1] == id }.first&.first
    end
  end
  
  has_many :question_assignments, dependent: :destroy
  has_many :surveys, through: :question_assignments
  
  has_many :ideas, through: :idea_assignments
  has_many :idea_assignments, as: :groupable, inverse_of: :groupable, dependent: :destroy

  has_many :individual_answers
  has_one :question_detail
  
  validates :title, length: {minimum: 1}
  def question_type_name
    QuestionType.name(question_type)    
  end

  def response_length
    # Number of idea assignments or details
    if question_type == QuestionType::NEW_IDEA
      -1
    else
      idea_ct = idea_assignments.count
      details_length = question_detail&.details_list&.size || 0
      [idea_ct, details_length].max
    end
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
