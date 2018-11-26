require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a.sample }
    session[:letters] = @letters
  end

  def score
    @letters = session[:letters]
    @word = params[:try]
    @valid = @word.split(//).all? do |lettre|
      @letters.delete_at(@letters.index(lettre)) if @letters.include? lettre
    end
    @english = english_words(@word)
    compute_score(@word)
  end
end

def english_words(attempt)
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  word_serialized = open(url).read
  word = JSON.parse(word_serialized)
  word['found']
end

def user_score(number_letter)
end

def compute_score(attempt)
  if @english == false && @valid == true
    @score = { score: 0, message: "doesn't seem to be an english word..." }
  elsif @valid == false && @english == true
    @score = { score: 0, message: "can't be built out of" }
  else
    @score = { score: user_score(@word.length), message: "is a valid English word !" }
  end
end
