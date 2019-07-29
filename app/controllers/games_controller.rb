class GamesController < ApplicationController
  def new
    @get_letters = Game.get_letters
    my_letters = Game.create(letters:@get_letters.join(""))
    # byebug
    session[:game_id] = my_letters.id
    @letters = my_letters.letters.split("")
  end

  def score
    @word_match =  HTTParty.get("https://recode-dictionary.herokuapp.com/#{params["q"]}")
    # byebug
    if @word_match["found"]==true
      @letters = Game.find(session[:game_id])
      # byebug
      @word = @word_match["word"].split("").map{|m|m.upcase}
      matched=@word & @letters.letters.split("")
      # byebug
      if matched == @word
        session[:win?] = true
      else
        session[:win?] = false
      end
      session[:status] = true
    else
      @letter_search= params["q"]
      session[:status] = false
    end
    # byebug
  end
end
