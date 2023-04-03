# frozen_string_literal: true

module ApplicationHelper
  require 'uri'
  require 'net/http'

  def get_request(request_url)
    url = URI.parse(ENV['APP_HOST'] + ':' + ENV['APP_PORT'] + request_url)
    request = Net::HTTP::Get.new(url)
    response = Net::HTTP.start(url.hostname, url.port) { |http|
      http.request(request)
    }
    JSON.parse(response.body)
  end

  def post_request(request_url, data)
    url = URI.parse(ENV['APP_HOST'] + ':' + ENV['APP_PORT'] + request_url)
    request = Net::HTTP::Post.new(url)
    request.set_form_data(data)
    response = Net::HTTP.start(url.hostname, url.port) do |http|
      http.request(request)
    end

    if response.body == ""
      response.code == "200" ? true : false
    else
      JSON.parse(response.body)
    end
  end

  def delete_request(request_url)
    url = URI.parse(ENV['APP_HOST'] + ':' + ENV['APP_PORT'] + request_url)
    request = Net::HTTP::Delete.new(url)
    response = Net::HTTP.start(url.hostname, url.port) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def update_request(request_url, data)
    url = URI.parse(ENV['APP_HOST'] + ':' + ENV['APP_PORT'] + request_url)
    request = Net::HTTP::Put.new(url)
    request.set_form_data(data)
    response = Net::HTTP.start(url.hostname, url.port) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end
