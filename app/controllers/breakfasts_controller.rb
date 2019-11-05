require 'open-uri'

class BreakfastsController < ApplicationController
  def index
    url = 'https://gist.github.com/latoyaallen/b54dff46402740fd1be5d1dfbb038bda'
    create_breakfasts_from(url)
    @breakfasts = Breakfast.all
    json_response(@breakfasts)
  end

  private

  def create_breakfasts_from(url)
    doc = Nokogiri::HTML.parse(open(url))
    days = doc.xpath("//h2")
    names = doc.xpath("//h3")
    content = doc.xpath("//p")

    count = days.size
    i = 0

    while i < count
      if Breakfast.find_by_id(i).nil? # If the id exists, do nothing.  If no id, create a new Breakfast obj.
        Breakfast.new(id: i, day: get_day(i, days), name: get_name(i, names), content: get_content(i, content)).save
      end
      i = i + 1
    end
  end

  def get_day(i, days)
    days[i].children[0].attributes['href'].value
  end

  def get_name(i, names)
    names[i].children[0].attributes['href']
  end

  def get_content(i, content)
    content[i + 1]
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
