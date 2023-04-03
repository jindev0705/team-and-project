Rails.application.routes.draw do
  root to: 'members#index'

  resources :members

  resources :teams do
    get   :view_members,  to: 'teams#view_members'
  end

  resources :projects do
    get   :new_members,       to: 'projects#new_members'
    get   :view_members,  to: 'projects#view_members'
    post  :add_members,   to: 'projects#add_member'
  end


  namespace :api do
    resources :members do
      post    :alter_team,          to: 'members#alter_team'
    end

    resources :teams do
      get     :team_members,        to: 'teams#team_members'
    end

    resources :projects do
      post    :add_member,          to: 'projects#add_member'
      get     :project_members,     to: 'projects#project_members'
    end
  end


end
