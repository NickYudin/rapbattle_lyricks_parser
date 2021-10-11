require_relative 'app'

data = Parser.new.lyrics
data.each do |battle|
  @battlers = battle[:title].split(' vs. ') 
  battle[:first_battler] = @battlers[0]
  battle[:second_battler] = @battlers[1]
  battle[:second_text] = ''
  battle[:first_text] = ''
  rounds = battle[:text].strip.split('[Round ')
  rounds.delete_at(0)
  rounds.each do |round|
    @q = round.split(']')

    if @q[0].include?("#{battle[:first_battler]}")
      battle[:first_text] += "#{@q[1]}"
    end
    if @q[0].include?("#{battle[:second_battler]}")
      battle[:second_text] += "#{@q[1]}"
    end
  end
end
binding pry