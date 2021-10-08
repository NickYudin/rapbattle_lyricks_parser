require 'rubygems'
require 'mechanize'
require 'pry'

agent = Mechanize.new
page = agent.get(
                  'https://genius.com/albums/King-of-the-dot/Kotd-title-matches'
                )
links = []
 page.links.each do |link|
   if link.text.include?('(Title Match)')
     arr << link
   end
end

lyrics = []
links.each do |link|
  battle = link.click
  title = battle.search('h2').text.split(battle.search('h2 a').text)
  lyric = battle.search('.lyrics').text
  lyrics.push(title: title.last.strip,
              lyrics: lyric)


end

