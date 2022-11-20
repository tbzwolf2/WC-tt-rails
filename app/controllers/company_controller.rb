class CompanyController < ApplicationController
    require 'net/http'
    def company_list
        uri = URI('https://whisper-tech-tests.s3.eu-west-1.amazonaws.com/companies.json')
        res = Net::HTTP.get_response(uri)
        @company_json = JSON.parse(res.body)

        @company_json.each do |company|
            db_company = Company.find_or_create_by(api_id: company["number"])
            db_company.update(name: company["name"])
            company["likes"] = db_company.likes

        end
    end

    def company_details
        if session[:liked_companies] == nil
            session[:liked_companies] = {}
        end
        @company = Company.find_by(api_id: params[:api_id])

        if params[:liked] == "true"
            session[:liked_companies][params[:api_id]] = DateTime.now
            @company.update(likes: (@company.likes += 1))
        end
        session_time = DateTime.parse(session[:liked_companies][params[:api_id]].to_s) if session[:liked_companies][params[:api_id]]

        if session[:liked_companies][params[:api_id]] and (session_time + 30.seconds) > DateTime.now
            @like_button_bool = false
        else
            @like_button_bool = true
        end

        @company_json = JSON.parse(Company.get_gov_api("https://api.company-information.service.gov.uk/company/#{params[:api_id]}"))

        @address = ""
        @company_json["registered_office_address"].each do |key, value|
            @address += value + ", "
        end

    end

end
