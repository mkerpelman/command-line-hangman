require './lib/game.rb'

class Display

    attr_accessor :wrong_letters, :current

    def initialize(blank_array)
        @current = blank_array
        @wrong_letters = Array.new(0)
    end

    def update(updated_blank_array)
        @current = updated_blank_array
    end

    def show(remaining)
        system "clear"
        puts <<-HEREDOC

        ****** Hangman - The Classic Word Game ******

                      #{@current.join(" ")}

                    # GUESSES REMAINING: #{remaining}

        WRONG LETTERS: #{@wrong_letters.sort}

        HEREDOC
    end

end