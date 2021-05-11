require './lib/display.rb'
require 'json'

class Game

    attr_reader :blanks, :wrong_letters, :remaining

    ALPHABET = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
    GUESSES_ALLOWED = 8

    def initialize(type)
        if type == "1"
            self.generate_secret_word
            @blanks = self.retract_all_letters
            @display = Display.new(@blanks)
            @remaining = GUESSES_ALLOWED
            self.play
        else
            puts "        Enter full filename of saved game to load (including file extension, i.e. .json): "
            filename = gets.chomp
            source = self.import_progress(filename)
            saved_data = self.unpack_json(source)
            self.load_secret_word(saved_data["secret_word"])
            @blanks = saved_data["blanks"]
            @display = Display.new(@blanks)
            @wrong = saved_data["wrong"]
            @display.wrong_letters = @wrong
            @remaining = saved_data["remaining"]
            self.play
        end
    end

    def play
        while @remaining > 0
            if @blanks.include?("_")
                @display.show(@remaining)
                if self.save_game?
                    self.export_progress
                    break
                else
                    letter = self.get_user_guess
                    if self.scan_secret_for_letter(letter)
                        self.right_letter(letter)
                    else
                        self.wrong_letter(letter)
                        @remaining -= 1
                    end
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
        elsif !self.win? && @remaining == 0
            @display.show(@remaining)
            puts "        You lost. Too bad! The word was #{@secret_word.join}."
            puts ""
            puts "        *********************************************"
        else
            puts "        Game saved. See you next time!" 
        end
    end

    private

    def generate_secret_word
        file = File.open("5desk.txt", 'r')
        word_list = file.read.split("\r\n").filter { |word| word.length.between?(5, 12) }.map! { |word| word.upcase }
        @secret_word = word_list[rand(0..(word_list.length - 1))].chars
        file.close
    end

    def load_secret_word(array)
        @secret_word = array
    end

    def retract_all_letters
        blanks_array = Array.new(0)
        @secret_word.length.times { blanks_array << "_" }
        blanks_array
    end

    def get_user_guess
        print "        Please enter a letter: "
        letter = gets.chomp.upcase
        until ALPHABET.include?(letter) && !@display.wrong_letters.include?(letter)
            print "        Not a valid letter. Please try again: "
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

    def save_game?
        print "        Would you like to save your game and quit? (Y/N)"
        answer = gets.chomp.upcase
        until ["Y", "N"].include?(answer)
            print "        Not a valid answer. Please select 'Y' or 'N': "
            answer = gets.chomp.upcase
        end
        if answer == 'Y'
            true
        else
            false
        end
    end

    def export_progress
        Dir.mkdir('savegames') unless Dir.exist?('savegames')
        time = Time.new
        print "        Please enter a name for your save: "
        custom_part = gets.chomp
        file_name = "savegames/#{custom_part}.json"
        file = File.open(file_name, "w")
        file.puts self.make_json_object
        file.close
    end

    def import_progress(filename)
        filenamepath = "savegames/#{filename}"
        file = File.open(filenamepath, 'r')
        return file.read
        file.close
    end

    def make_json_object
        for_json = {
            :secret_word => @secret_word, 
            :blanks => @blanks, 
            :wrong => @display.wrong_letters,
            :remaining => @remaining
        }
        JSON.generate(for_json)
    end

    def unpack_json(content)
        JSON.parse(content)
    end

end