require 'rubygems'
require 'mechanize'
require 'pry'

class Parser

  START_PAGE  = 'https://genius.com/albums/King-of-the-dot/Kotd-title-matches'.freeze

  def initialize
    @page = Mechanize.new.get(START_PAGE)
  end
 
  def call
    battles_data
  end

  def links
    @page.links.filter_map { |link| link if link.text.include?('(Title Match)') } 
  end

  def battles_data
    links.map { |link| Battle.new(link)} 
  end  

end

class Battle 

  def initialize (link)
    @link =link
    @battle = link.click
  end

  def call
    parse_battle(@battle)
  end

  def parse_battle (link)
    parse_title(link)
    parse_url(@link)
    parse_battlers(link)
    parse_texts(link)
    make_hash
  end

  def make_hash
    @data = { 
              title: @title,
              link: @url,
              first_battler: @first_battler,
              second_battler: @second_battler,
              first_text: @first_text,
              second_text: @second_text
              }
  end

  def parse_url (link)
    @url = link.href
  end    

  def parse_title (link)
      @title = link.search('h2.text_label').text.delete_suffix(' (Title Match) Lyrics')
  end

  def parse_texts (link)
    @first_text = ''
    @second_text = ''
    lyric = link.search('.lyrics').text.strip.split('[Round ')
    lyric.delete_at(0)
    compilate_battlers_text(lyric)
  end

  def compilate_battlers_text (rounds)
    rounds.each do |round|
      arr = round.split(']')
      compilation(arr[0], arr[1])
    end    
  end

  def compilation (round_title, round_text)
      if round_title.include?("#{@first_battler}") ? add_to_first(round text) : add_to_second(round text)
  end  

  def add_to_first (round text)
    @first_text << "#{round_text}"
  end

  def add_to_second (round text)
    @second_text << "#{round_text}"
  end

  def parse_battlers (link)
    battlers = @title.split(' vs. ') 
    @first_battler = battlers[0]
    @second_battler = battlers[1]
  end
  
end