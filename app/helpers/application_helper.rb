module ApplicationHelper
  def is_active(selection_type)
    @navbar_active_section && @navbar_active_section == selection_type ? 'menu-selected' : ''
  end
end
