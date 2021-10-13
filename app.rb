require 'rubygems'
require 'mechanize'
require 'pry'

class Parser

  START_PAGE  = 'https://genius.com/albums/King-of-the-dot/Kotd-title-matches'.freeze

  def initialize
    @page = Mechanize.new.get(START_PAGE)
  end
 
  def call
    puts battles_data
  end

  def links
    @links ||= @page.links.filter_map { |link| link if link.text.include?('(Title Match)') }
  end

  def battles_data
    links.map { |link| Battle.new(link).call} 
  end  

end

class Battle 

  def initialize (link)
    @link =link
    @battle = link.click
  end

  def call
    parse_title(@battle)
    parse_url(@link)
    parse_battlers(@battle)
    parse_texts(@battle)
    make_hash
    return @data
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
      if round_title.include?("#{@first_battler}") ? add_to_first(round_text) : add_to_second(round_text)
      end
  end  

  def add_to_first (round_text)
    @first_text << "#{round_text}"
  end

  def add_to_second (round_text)
    @second_text << "#{round_text}"
  end

  def parse_battlers (link)
    battlers = @title.split(' vs. ') 
    @first_battler = battlers[0]
    @second_battler = battlers[1]
  end
  
end
binding pry
