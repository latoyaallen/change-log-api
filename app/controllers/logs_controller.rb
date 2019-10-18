require 'open-uri'

class LogsController < ApplicationController
  def index
    get_logs
    @logs = Log.all
    require 'pry'
    binding.pry
    json_response(@logs)
  end

  private

  def get_logs
    url = 'https://gist.github.com/latoyaallen/c585656a196dab73158d9ffcd0a26688'
    doc = Nokogiri::HTML.parse(open(url))
    titles = doc.xpath("//h2")
    dates = doc.xpath("//h3")
    content = doc.xpath("//p")

    count = titles.size
    i = 0
    logs = []

    while i < count
      logs << Log.new(id: i, title: titles[i].children[0].attributes['href'].value, date: dates[i].children[0].attributes['href'], content: content[i +1]).save
      # for the content we do i + 1 because we want to skip the first element
      # of i withoug mutating the content data.
      i = i + 1
    end
    logs
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
