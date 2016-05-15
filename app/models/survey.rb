class Survey < ActiveRecord::Base
  def status_enum
    (0..SurveyStatus.max_type).inject({}) do |acc, i|
      acc[SurveyStatus.name(i)] = i
      acc
    end
  end
  
  def viewbox_list
    unless Struct.const_defined? 'VbStruct'
      Struct.new('VbStruct', :partial_name, :title, :box_key, :shown, :expected_length) do
        def initialize(*args)
          super
          self.shown = true
          @expected_length = args[3] if args.size > 3
        end
      end
    end
    
    l = [Struct::VbStruct.new('title', 'Survey Title', 'survey-create-title', true, 10),
         Struct::VbStruct.new('intro_field', 'Edit Introduction', 'survey-create-intro', true, 15),
         Struct::VbStruct.new('add_questions', 'Add Questions', 'survey-add-questions'),
         Struct::VbStruct.new('thankyou_field', 'Thank You Note', 'survey-thank-you-note') ]

    l
  end
  class SurveyStatus
    DRAFT=0
    PUBLISHED=1
    CLOSED=2

    def self.max_type
      2
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

  def has_state?(sym)
    Survey::SurveyStatus.const_defined?(sym.to_s.upcase) && status == "Survey::SurveyStatus::#{sym.upcase}".constantize
  end

  def publish
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
