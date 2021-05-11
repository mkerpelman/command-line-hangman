require './lib/display.rb'

class Game

    attr_reader :blanks, :wrong_letters, :remaining

    ALPHABET = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
    GUESSES_ALLOWED = 8

    def initialize
        self.generate_secret_word
        @blanks = self.retract_all_letters
        @display = Display.new(@blanks)
        @remaining = GUESSES_ALLOWED
    end

    def play
        while @remaining > 0
            if @blanks.include?("_")
                @display.show(@remaining)
                letter = self.get_user_guess
                if self.scan_secret_for_letter(letter)
                    self.right_letter(letter)
                else
                    self.wrong_letter(letter)
                    @remaining -= 1
                end
            else
                @display.show(@remaining)
                break
            end
        end
        if self.win?
            puts "        You won. Great job!"
            puts ""
            puts "        *********************************************"
        else
            @display.show(@remaining)
            puts "        You lost. Too bad! The word was #{@secret_word.join}."
            puts ""
            puts "        *********************************************"
        end
    end

    private

    def generate_secret_word
        file = File.open("5desk.txt", 'r')
        word_list = file.read.split("\r\n").filter { |word| word.length.between?(5, 12) }.map! { |word| word.upcase }
        @secret_word = word_list[rand(0..(word_list.length - 1))].chars
        file.close
    end

    def retract_all_letters
        blanks_array = Array.new(0)
        @secret_word.length.times { blanks_array << "_" }
        blanks_array
    end

    def get_user_guess
        print "Please enter a letter: "
        letter = gets.chomp.upcase
        until ALPHABET.include?(letter) && !@display.wrong_letters.include?(letter)
            print "Not a valid letter. Please try again: "
            letter = gets.chomp.upcase
        end
        letter
    end

    def scan_secret_for_letter(upcase_letter)
        @secret_word.include? upcase_letter
    end

    def wrong_letter(upcase_letter)
        @display.wrong_letters << upcase_letter
    end

    def right_letter(upcase_letter)
        @secret_word.each_with_index do |letter, index|
            @blanks[index] = letter if letter == upcase_letter
        end
    end
    
    def win?
        !(@remaining == 0) && !@blanks.include?("_")
    end


end