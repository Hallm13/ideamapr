class Survey < ActiveRecord::Base
  def status_enum
    (0..SurveyStatus.max_type).inject({}) do |acc, i|
      acc[SurveyStatus.name(i)] = i
      acc
    end
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
    def self.name(id)
      if id.nil?
        nil
      else
        option_array.select { |i| i[1] == id }.first&.first
      end
    end
  end
  
  validates :title, length: {minimum: 12}

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
