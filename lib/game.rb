class Game

    def initialize
        @secret_word = self.select_secret_word
    end

    private

    def select_secret_word
        file = File.open("5desk.txt", 'r')
        word_list = file.read.split("\r\n").filter { |word| word.length.between?(5, 12) }.map! { |word| word.upcase }
        return word_list[rand(0..(word_list.length - 1))]
        file.close
    end

end
