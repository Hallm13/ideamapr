module ApplicationHelper
  def is_selected(selection_type)
    (@selected_section && @selected_section.to_sym == selection_type) ? 'menu-selected' : ''
  end
end
