class Idea < ActiveRecord::Base
  include IdeasHelper
  
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
    
    [Struct::IdeaVbStruct.new('title', 'Idea Title', 'idea-title', true, 1, 'Add a short title'),
     Struct::IdeaVbStruct.new('source', 'Source', 'idea-source', true, 10, ''),     
     Struct::IdeaVbStruct.new('location', 'Location', 'idea-location', true, -1, 'Enter an optional location'),
     Struct::IdeaVbStruct.new('description', 'Idea Intro', 'idea-description', true, 1, 'Describe your idea'),
     Struct::IdeaVbStruct.new('attachments', 'Attachments', 'idea-attachments', true, 1, 'Upload attachments')
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
  
  def attachments_oldest_first
    download_files.order('download_files.created_at asc')
  end

  def card_image    
    attachments_oldest_first.all.select do |attach|
      is_image? attach.downloadable_content_type      
    end.first
  end

  def download_files_hash
    # Construct a hash suitable for participant app
    card_image_url = ''
    url_list = attachments_oldest_first.all.map do |attach|
      if is_image? attach.downloadable_content_type
        card_image_url = attach.downloadable.url
      end
      {url: attach.downloadable.url, filename: attach.downloadable_file_name}
    end

    {card_image_url: card_image_url, attachment_urls: url_list}
  end
  
  validates :title, length: {minimum: 1}
  validates :description, length: {minimum: 1}
  has_many :idea_assignments, dependent: :destroy
  has_many :download_files

  before_save :set_default_source

  private
  def set_default_source
    source.present? or (self.source = 'admin')
  end
end
