require 'rubygems'
require 'sinatra'
require 'json'
require 'builder'
require 'open-uri'

SW_API_KEY = ENV['SW_API_KEY']

def get_keys_for_table(name)
  keys = %$http://api.scraperwiki.com/api/1.0/datastore/getkeys?key=#{SW_API_KEY}&format=json&name=#{name}$
  keys_as_json = URI.parse(keys).read
  JSON.parse(keys_as_json)
end

get '/:table.xml' do
   content_type 'application/xml', :charset => 'utf-8'
   response.headers['Cache-Control'] = 'public, max-age=3600'
   scraper = params[:table]
   builder :scraper_wiki, {}, {:keys => get_keys_for_table(scraper),:name=>scraper}
end