require 'rubygems'
require 'mechanize'
require 'pry'

class Parser

  START_PAGE  = 'https://genius.com/albums/King-of-the-dot/Kotd-title-matches'.freeze

  def initialize
    @agent = Mechanize.new
    @page = @agent.get(START_PAGE)
    get_data
  end
 

  def get_data
    @data = []
    get_links
    parse_battles
    puts @data
  end

  def get_links
    @links = @page.links.filter_map do |link|
      link if link.text.include?('(Title Match)')
    end
  end

  def parse_battles
    @links.each do |link|
     
      some = Battle.new (link)
      @data << some 
    end 
  end  
end

class Battle 

  def initialize (link)
    parse_url(link)
    battle = link.click
    parse_battle(battle)
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

  def parse_battle (link)
    parse_title(link)
    parse_1st_battler(link)
    parse_2nd_battler(link)
    parse_texts(link)
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
      round_title = arr[0]
      round_text = arr[1]
      compilation(round_title, round_text)
    end    
  end

  def compilation (round_title, round_text)
      if round_title.include?("#{@first_battler}")
        @first_text << "#{round_text}"
      else
        @second_text << "#{round_text}"
      end
  end  

  def parse_1st_battler (link)
    battlers = @title.split(' vs. ') 
    @first_battler = battlers[0]
  end
    
  def parse_2nd_battler (link)
    battlers = @title.split(' vs. ') 
    @second_battler = battlers[1]
  end
end