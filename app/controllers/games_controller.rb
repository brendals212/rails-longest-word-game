require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def generate_grid(grid_size)
    i =0
    array = []
    while i < grid_size
      array << ('A'..'Z').to_a.sample
      i += 1
    end
    return array
  end

  def score_generator(time_difference, attempt)
    (attempt.length.to_f / time_difference) *10
  end

  def run_game(attempt, grid, start_time, end_time)
    time_difference = end_time - start_time
    attempt.upcase!
    @hash = {}
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    word_info = JSON.parse(word_serialized)

    if word_info["found"] == true
      word_array = attempt.split("")
      word_array.each do |element|
        if grid.include?(element.upcase) == false
          return @hash = {message: "not in the grid", score: 0, time: time_difference }
        end
          @hash[:message] = "well done"
      end
    else
      @hash = {message: "not an english word", score: 0, time: time_difference}
    end

    if @hash[:message] == "well done"
      score = score_generator(time_difference, attempt)
      @hash[:score] = score
      @hash[:time] = time_difference
    end

    return @hash
  end

  def new
    @letters = generate_grid(10)
  end

  def score
    @start_time = Time.now
    @letters = params["letters"]
    @word = params["answer"]
    @end_time = Time.now
    @score = run_game(@word, @letters , @start_time, @end_time)

  end



end
