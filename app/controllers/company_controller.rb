class CompanyController < ApplicationController
    require 'net/http'
    def company_list
        uri = URI('https://whisper-tech-tests.s3.eu-west-1.amazonaws.com/companies.json')
        res = Net::HTTP.get_response(uri)
        @company_json = JSON.parse(res.body)

        @company_json.each do |company|
            puts company
            db_company = Company.find_or_create_by(api_id: company["number"])
            puts "asdfasdfasdf"
            puts db_company.inspect
            db_company.update(name: company["name"])
            puts db_company.inspect

        end
    end

    def company_details
        if session[:liked_companies] == nil
            session[:liked_companies] = {}
        end
        company = Company.find_by(api_id: params[:api_id])

        if params[:liked] == "true"
            session[:liked_companies][params[:api_id]] = DateTime.now
            company.update(likes: (company.likes += 1))
        end

        if session[:liked_companies][params[:api_id]] and session[:liked_companies][params[:api_id]] < (DateTime.now + 1.hour)
            @like_button_bool = false
        else
            @like_button_bool = true
        end



        uri = URI("https://api.company-information.service.gov.uk/company/#{params[:api_id]}")
        req = Net::HTTP::Get.new(uri)
        req.basic_auth '26f083e7-41fb-41b1-a20b-8b47555ad37f', ''

        req_options = {
          use_ssl: uri.scheme == "https"
        }
        res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(req)
        end

        @company_json = JSON.parse(res.body)
        @address = ""
        @company_json["registered_office_address"].each do |key, value|
            @address += value + ", "
        end

    end

end
