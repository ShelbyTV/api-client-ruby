require 'open-uri'
require 'net/http'
require 'uri'
require 'json'
class SayController < ApplicationController


  ClientId = "4fd7b186503dd47e740000da"
  Secret = "1bbfe81ce9ebee1978d86116eb259d1b291f6619d65df90e5bc68eaefcded28f"
  
  def hello
    uri = "http://localhost:3000/oauth/authorize?client_id=#{ClientId}&redirect_uri=http://localhost:3002/say/bye&response_type=code&scope="
    redirect_to uri
  end

  def bye
    get_token(params["code"])
    render :bye
  end

  def hitapi
    url = params["urls"]
    api_uri = URI("http://localhost:3000/#{url}")
    request = Net::HTTP::Get.new(api_uri.request_uri)
    token = session[:oauth_token]
    request["Authorization"] = "OAuth #{token}"
    http = Net::HTTP.new(api_uri.host, api_uri.port)
    response = http.request(request)
    render :text=>response.body
  end

  def show
    unless session[:oauth_token]
      redirect_to :hello
    end
    render "show"
  end

  private
    def get_token(code)
      uri = URI("http://localhost:3000/oauth/access_token")
      post_params =  {"code"=>code, "client_id"=>ClientId, "client_secret"=>Secret, "grant_type"=>"authorization_code", "redirect_uri" => "http://localhost:3002/say/bye" }
      http_response = Net::HTTP.post_form(uri, post_params)
      token =  JSON.parse(http_response.body)["access_token"]
      session[:oauth_token] = token
    end
end
