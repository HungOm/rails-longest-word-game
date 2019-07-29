class Game < ApplicationRecord

    def self.get_letters
        letter = *("A".."Z")
        letters = letter.sample(10)
    end
end
