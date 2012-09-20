SuocNext::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  mount CommunityEngine::Engine => "/"

  resources :payments

  resource  :reunion, :controller => "reunion"
  resources :acct_action_sets
  resources :acct_reports

  resources :club_memberships do
    collection do
      post :submit_list
    end
  end


  resources :cert_member_certs do
    member do
      get :my_index
    end
  end

  resources :cert_orgs do
    member do
      post :auto_complete_for_cert_org_name
    end
  end


  resources :cert_types

  resources :club_login_messages

  resources :club_trip_registrations do
    collection  do
      get :statistics
      get :list_submitted
      get :configure
      post :update_configuration
    end
  end


  resources :acct_ledgers

  resources :club_ledgers

  resources :club_announcements

  resources :club_documents
  resources :club_affiliations

  match '/admin/dashboard', :controller => 'comatose/admins#index'

  mount Comatose::Engine => "/home"

  resources :club_members
  resources :acct_account_types
  resources :acct_transactions
  resources :acct_accounts
  resources :acct_action_types
  resources :acct_categories
  resources :acct_actions
  resources :club_activities
  resources :club_offices
  resources :club_officers do
    member do
      get :my_index
    end
  end
  resources :club_chairs do
    member do
      get :my_index
    end
  end
  resources :club_leaderships do
    member do
      get :my_index
    end
  end
  resources :club_leaders do
    member do
      get :my_index
    end
  end
  resources :club_member_statuses
  resources :club_trips

  resource :club_dashboard
  resource :eroom_ledger do
    member do
      post :auto_complete_for_club_member_login
      post :update_transaction
      post :update_description_form
    end
  end


  resource :treasurer_ledger do
    member do
      post :auto_complete_for_club_member_login
      post :update_transaction
      post :update_description_form
    end
  end


  resources :cert_certifications

  resources :authorization_rules,
                :only => :index do
    collection do
      get :graph
    end
  end
  resources :authorization_usages,
                :only => :index

  resources :users do
    member do
      post :verify_cert
      post :verify_leader
      post :edit_club_member_info
      post :edit_club_member_info_user
      delete :delete_cert
      delete :delete_leader
    end
  end

  resources :page, :only => [:show]

end
