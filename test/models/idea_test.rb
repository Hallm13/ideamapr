require 'test_helper'

class IdeaTest < ActiveSupport::TestCase
  def setup
    set_net_stubs
  end
  
  test '#surveys' do
    assert_equal 1, ideas(:idea_1).surveys.count
  end

  test '#card_image' do
    i = ideas(:idea_1)
    i.download_files << DownloadFile.new(downloadable: fixture_file_as_io('image.png'))
    i.save
    
    refute_nil i.card_image
    assert_nil ideas(:idea_2).card_image
  end
end
