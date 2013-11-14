require 'spec_helper'

feature "signed in user and resource creation" do
  background do
    @user = FactoryGirl.create(:user)
    @task = FactoryGirl.create(:task)
    sign_in_manually @user
  end
end
