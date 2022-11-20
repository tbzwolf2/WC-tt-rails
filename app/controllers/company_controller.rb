class CompanyController < ApplicationController
    require 'net/http'

    # Over all page to see all companies
    def company_list
        #No method for this since it has no auth, wrapped in a retry incase of random network failure
        begin
            retries ||= 0
        uri = URI('https://whisper-tech-tests.s3.eu-west-1.amazonaws.com/companies.json')
        res = Net::HTTP.get_response(uri)
        rescue
            retry if (retries += 1) < 2
        end

        @company_json = JSON.parse(res.body)

        @company_json.each do |company|
            db_company = Company.find_or_create_by(api_id: company["number"])
            db_company.update(name: company["name"])
            company["likes"] = db_company.likes

        end
    end

    def company_details
        #Initialise the liked companies hash if it doesn't exist
        if session[:liked_companies] == nil
            session[:liked_companies] = {}
        end

        @company = Company.find_by(api_id: params[:api_id])

        #If we get a like disable the button to like on reload and save the time of the like
        if params[:liked] == "true"
            session[:liked_companies][params[:api_id]] = DateTime.now
            @company.update(likes: (@company.likes += 1))
        end

        #Parse here to avoid long single line
        session_time = DateTime.parse(session[:liked_companies][params[:api_id]].to_s) if session[:liked_companies][params[:api_id]]

        #If it's been like in the last 30 seconds don't show a like button, preventing spam likes
        if session[:liked_companies][params[:api_id]] and (session_time + 30.seconds) > DateTime.now
            @like_button_bool = false
        else
            @like_button_bool = true
        end

        #Method for getting this api since it has an auth, too much code for just here, wrapped in a retry incase of random network failure
        begin
            retries ||= 0
            @company_json = JSON.parse(Company.get_gov_api("https://api.company-information.service.gov.uk/company/#{params[:api_id]}"))
        rescue
            retry if (retries += 1) < 2
        end



        @address = ""
        @company_json["registered_office_address"].each do |key, value|
            @address += value + ", "
        end

    end

end
