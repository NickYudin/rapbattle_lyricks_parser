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
      title = battle.search('h2.text_label').text
      lyric = battle.search('.lyrics').text
      @lyrics.push(title: title.delete_suffix(' (Title Match) Lyrics') ,
                  link: link.href,
                  text: lyric)
    end
    lyrics.each do |battle|
      @battlers = battle[:title].split(' vs. ') 
      battle[:first_battler] = @battlers[0]
      battle[:second_battler] = @battlers[1]
      battle[:first_text] = ''
      battle[:second_text] = ''

      rounds = battle[:text].strip.split('[Round ')
      rounds.delete_at(0)
      rounds.each do |round|
        @q = round.split(']')

        if @q[0].include?("#{battle[:first_battler]}")
          battle[:first_text] << "#{@q[1]}"
        else
          battle[:second_text] << "#{@q[1]}"
        end
      end
    end
  end
end
binding pry