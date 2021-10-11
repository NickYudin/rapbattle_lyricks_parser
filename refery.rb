require_relative 'app'

data = Parser.new.lyrics
data.each do |battle|
  battlers = battle[:title].split(' vs. ') 
  battle[:first_battler] = battlers[0]
  battle[:second_battler] = battlers[1]

  rounds = battle[:text]
end
binding pry