require 'test_helper'

class CmsContentTest < ActiveSupport::TestCase
  test "validation" do
    refute CmsContent.new.valid?
  end
end
