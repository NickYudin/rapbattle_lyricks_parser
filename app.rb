require 'rubygems'
require 'mechanize'
require 'pry'

class Parser

  START_PAGE  = 'https://genius.com/albums/King-of-the-dot/Kotd-title-matches'.freeze

  attr_reader :lyrics

  attr_reader :lyrics
  def initialize
    @agent = Mechanize.new
    @page = @agent.get(START_PAGE)
    get_data
  end
 
  def get_data
    @links = []
    @lyrics = []

    @page.links.each do |link|
       if link.text.include?('(Title Match)')
         @links << link
       end
    end
    @links.each do |link|
      battle = link.click
      title = battle.search('h2').text.split(battle.search('h2 a').text)
      lyric = battle.search('.lyrics').text
      @lyrics.push(title: title.last.strip,
                  link: link.href,
                  text: lyric)
    end
  end
end
