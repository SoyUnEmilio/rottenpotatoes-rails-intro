class Movie < ActiveRecord::Base
    def self.movie_ratings()
        ['G','PG','PG-13','R']
    end
end
