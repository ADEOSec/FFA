module ApplicationHelper
  def devise_mapping
    Devise.mappings[:user]
  end
end
