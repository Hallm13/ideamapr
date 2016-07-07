class DownloadFile < ActiveRecord::Base
  belongs_to :idea

  has_attached_file :downloadable, storage: :s3, url: ":s3_domain_url",
                    path: ':filename',
                    s3_credentials: {:bucket => Rails.application.secrets.s3_bucket,
                                     :access_key_id => Rails.application.secrets.aws_aki,
                                     :secret_access_key => Rails.application.secrets.aws_sak},
                    s3_region: Rails.application.secrets.s3_region

  validates_attachment :downloadable,
                       content_type: {content_type: ['application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                                                     'application/pdf', 'image/jpeg', 'image/gif', 'image/png']}  
end

