# frozen_string_literal: true

module ApplicationHelper
  require 'uri'
  require 'net/http'

  def get_request(request_url)
    puts "******************* GET URL ***********************"
    puts ENV['API_HOST'] + request_url
    # url = URI.parse(ENV['API_HOST'] + request_url)
    # request = Net::HTTP::Get.new(url)
    # response = Net::HTTP.start(url.hostname, url.port) { |http|
    #   http.request(request)
    # }
    response = HTTParty.get(ENV['API_HOST'] + request_url)
    JSON.parse(response.body)
  end

  def post_request(request_url, data)
    puts "******************* POST URL ***********************"
    puts ENV['API_HOST'] + request_url
    # url = URI.parse(ENV['API_HOST'] + request_url)
    # request = Net::HTTP::Post.new(url)
    # request.set_form_data(data)
    # response = Net::HTTP.start(url.hostname, url.port) do |http|
    #   http.request(request)
    # end
    response = HTTParty.post(ENV['API_HOST'] + request_url, body: data.to_json, headers: { 'Content-Type' => 'application/json' })
    if response.body == ""
      response.code == "200" ? true : false
    else
      JSON.parse(response.body)
    end
  end

  def delete_request(request_url)
    puts "******************* DELETE URL ***********************"
    puts ENV['API_HOST'] + request_url
    # url = URI.parse(ENV['API_HOST'] + request_url)
    # request = Net::HTTP::Delete.new(url)
    # response = Net::HTTP.start(url.hostname, url.port) do |http|
    #   http.request(request)
    # end

    response = HTTParty.delete(ENV['API_HOST'] + request_url, headers: { 'Content-Type' => 'application/json' })
    JSON.parse(response.body)
  end

  def update_request(request_url, data)
    puts "******************* PUT URL ***********************"
    puts ENV['API_HOST'] + request_url
    # url = URI.parse(ENV['API_HOST'] + request_url)
    # request = Net::HTTP::Put.new(url)
    # request.set_form_data(data)
    # response = Net::HTTP.start(url.hostname, url.port) do |http|
    #   http.request(request)
    # end

    response = HTTParty.put(ENV['API_HOST'] + request_url, body: data.to_json, headers: { 'Content-Type' => 'application/json' })
    JSON.parse(response.body)
  end
end
