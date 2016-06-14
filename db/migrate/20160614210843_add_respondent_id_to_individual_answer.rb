class AddRespondentIdToIndividualAnswer < ActiveRecord::Migration
  def change
    add_column :individual_answers, :respondent_id, :integer
  end
end
