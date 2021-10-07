require 'rubygems'
require 'mechanize'

agent = Mechanize.new
page = agent.get('https://genius.com/albums/King-of-the-dot/Kotd-title-matches')