Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "company#company_list"
  get "/companies", to: "company#company_list"
  get "/company_details/:api_id", to: "company#company_details"
end
