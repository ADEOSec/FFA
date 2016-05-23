ActiveAdmin.register Log do
  actions :index

  index do
    column :user do |log|
      link_to log.user.user_name, admin_user_path(log.user)
    end
    column :activity
    column :ip
    column :user_agent
    column :created_at
  end

  filter :user,       :collection => proc { User.all.pluck(:user_name, :id) }
  filter :activity
  filter :ip
  filter :user_agent
  filter :created_at
end
