require 'open-uri'

class LogsController < ApplicationController
  def index
    url = 'https://gist.github.com/latoyaallen/c585656a196dab73158d9ffcd0a26688'
    create_logs_from(url)
    @logs = Log.all
    json_response(@logs)
  end

  private

  def create_logs_from(url)
    doc = Nokogiri::HTML.parse(open(url))
    titles = doc.xpath("//h2")
    dates = doc.xpath("//h3")
    content = doc.xpath("//p")

    count = titles.size
    i = 0

    while i < count
      if Log.find_by_id(i).nil? # If the id exists, do nothing.  If no id, create a new Log obj.
        Log.new(id: i, title: get_title(i, titles), date: get_dates(i, dates), content: get_content(i, content)).save
      end
      i = i + 1
    end
  end

  def get_title(i, titles)
    titles[i].children[0].attributes['href'].value
  end

  def get_dates(i, dates)
    dates[i].children[0].attributes['href']
  end

  def get_content(i, content)
    content[i + 1]
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
