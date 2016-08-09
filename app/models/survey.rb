class Survey < ActiveRecord::Base
  include SurveyReporting
  
  def status_enum
    (0..SurveyStatus.max_type).inject({}) do |acc, i|
      acc[SurveyStatus.name(i)] = i
      acc
    end
  end
  
  def self.viewbox_list
    unless Struct.const_defined? 'VbStruct'
      Struct.new('VbStruct', :partial_name, :title, :box_key, :expected_length, :help_text, :shown) do
        def initialize(*args)
          super
          self.shown = true
        end
      end
    end
    
    [Struct::VbStruct.new('title', 'Survey Title', 'survey-create-title', 10, 'Add a survey title'),
     Struct::VbStruct.new('survey_status', 'Survey Status', 'survey-status', 10, 'Survey status'),     
     Struct::VbStruct.new('intro_field', 'Intro Message', 'survey-create-intro', 15, 'Add an introduction'),
     Struct::VbStruct.new('add_questions', 'Questions', 'survey-add-questions', -1, 'Add Questions in Ranked Order'),
     Struct::VbStruct.new('thankyou_field', 'Thank You Message', 'survey-thank-you-note', 15, 'Add a Thank You Note') ]
  end
  
  class SurveyStatus
    DRAFT=0
    PUBLISHED=1
    CLOSED=2

    def self.max_type
      2
    end

    def self.valid?(id)
      id = id.to_i
      [0, 1, 2].include? id
    end
    
    def self.option_array
      [['Draft', 0], ['Published', 1], ['Closed', 2]]
    end

    def self.id(name)
      if (s = option_array.select { |i| i[0] == name }).length == 1
        s.first[1]
      else
        nil
      end
    end
        
    def self.name(id)
      if id.nil?
        nil
      else
        option_array.select { |i| i[1] == id }.first&.first
      end
    end
  end
  
  validates :title, length: {minimum: 10}
  validates :introduction, length: {minimum: 15}

  has_many :survey_questions, through: :question_assignments
  has_many :question_assignments, dependent: :destroy
  
  has_many :ideas, through: :idea_assignments
  has_many :idea_assignments, as: :groupable, inverse_of: :groupable, dependent: :destroy

  belongs_to :owner, polymorphic: true, inverse_of: :surveys
  
  has_secure_token :public_link
  has_many :responses, dependent: :destroy
  has_many :respondents, through: :responses
  
  has_many :individual_answers, foreign_key: :survey_public_link, primary_key: :public_link, dependent: :destroy

  def self.valid_public_survey?(public_link)
    public_link.present? && (s = Survey.find_by_public_link public_link) ? s : nil
  end
      
  def has_state?(sym)
    Survey::SurveyStatus.const_defined?(sym.to_s.upcase) &&
      status == "Survey::SurveyStatus::#{sym.upcase}".constantize
  end
  def published?
    has_state?(:published)
  end

  def participation_rate
    report_hash[:total_screen_count].to_f/report_hash[:respondent_count]
  end
  
  def publish!
    self.status = SurveyStatus::PUBLISHED
    self.regenerate_public_link
    self.save
  end

  rails_admin do
    compact_show_view=false
    object_label_method do
      :title
    end
    list do
      field :title
      field :owner
      field :public_link
    end

    show do
      field :title
      field :owner
      field :public_link do
        formatted_value do
          bindings[:view].tag(:a, {href: "/survey/public_show/#{value}"}) << value
        end
      end
    end
  end  
end
