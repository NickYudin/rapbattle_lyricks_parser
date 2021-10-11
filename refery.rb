require_relative 'app'

data = Parser.new.lyrics
data.each do |battle|
  battlers = battle[:title].delete_suffix(' (Title Match) Lyrics').split(' vs. ') 
  battle[:first_battler] = battlers[0]
  battle[:second_battler] = battlers[1]

end
binding pry