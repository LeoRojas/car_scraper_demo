class HomeController < ApplicationController

require 'nokogiri'
require 'open-uri'

  def index
    # Fetch and parse HTML document
    @car_models = get_car_models("toyota")
  end

  def get_car_models brand
    car_url = 'https://www.toyota.com/' if brand == 'toyota'
    car_url = 'http://www.globalsuzuki.com/automobile/' if brand == 'suzuki'
    car_url = 'https://automobiles.honda.com/' if brand == 'honda'
    doc = Nokogiri::HTML(open(car_url))
    # puts "### Search for nodes by css"
    # doc.css('nav ul.menu li a', 'article h2').each do |link|
    #   puts link.content
    # end
    models = []
    # <div class="tcom-model-sweep-info">
    # doc.css("a[class='tcom-model-sweep-title']")
    # model string
    # starting_price integer
    # brand string
    # miles_galon integer
    # km_liter
      if brand == 'toyota'
        doc.css("div[class='tcom-model-sweep-info']").each do |elem|
          models << elem.content
          unless elem.content.index('$').nil?
            data = elem.content.split(' ')
            model = elem.content.split('$').first[0..-2].squish
            starting_price = data[2]
            miles_gallon = data[3]
            km_liter = nil
            # puts "WE ARE PRINTING A MODEL"
            puts model
            car = Car.find_by(model: model)
            if car.nil?
              Car.create(model: model, starting_price: starting_price, miles_gallon: miles_gallon, brand: brand)
              p "Car created"
            else
              car.update(starting_price: starting_price, miles_gallon: miles_gallon, brand: brand)
              p "Car updated"
            end
            # models << model
          end
        end
      end
      if brand == 'suzuki'
        doc.css("section[id='models-area'] li").each do |elem|
          models << elem.content
        end
      end
      if brand == 'honda'
        doc.css("section[class='rzf-gry rzf-gry-carousel rzf-gry-display-x-small-true rzf-gry-display-small-true rzf-gry-display-medium-true rzf-gry-display-large-true rzf-gry-display-x-large-true'] section[class='rzf-gray info-container'] svg").each do |elem|
          models << elem.content
        end
      end
    return models
  end
end
