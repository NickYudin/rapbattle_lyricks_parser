require 'rubygems'
require 'mechanize'
require 'pry'

agent = Mechanize.new
page = agent.get(
                  'https://genius.com/albums/King-of-the-dot/Kotd-title-matches'
                )
arr = []
 page.links.each do |link|
   if link.text.include?('(Title Match)')
     arr << link
   end
end
