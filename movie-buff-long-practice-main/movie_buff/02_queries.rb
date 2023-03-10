# Table name: actors
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null


# class Actor < ApplicationRecord
#   validates :name, presence: true

#   has_many :castings,
#     class_name: :Casting,
#     foreign_key: :actor_id,
#     primary_key: :id,
#     dependent: :destroy

#   has_many :movies,
#     through: :castings,
#     source: :movie

#   has_many :directed_movies,
#     class_name: :Movie,
#     foreign_key: :director_id,
#     primary_key: :id,
#     dependent: :nullify
#   end

#-------------------------------------------------------------------------------------

# Table name: castings
#
#  id         :bigint           not null, primary key
#  actor_id   :bigint           not null
#  movie_id   :bigint           not null
#  ord        :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null

# class Casting < ApplicationRecord
#   belongs_to :actor
#   belongs_to :movie
# end

#-------------------------------------------------------------------------------------

# Table name: movies
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  yr          :integer          not null
#  score       :float            not null
#  votes       :integer          not null
#  director_id :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# class Movie < ApplicationRecord
#   validates :title, :yr, :score, :votes, presence: true

#   belongs_to :director,
#     class_name: :Actor,
#     foreign_key: :director_id,
#     primary_key: :id

#   has_many :castings,
#     class_name: :Casting,
#     foreign_key: :movie_id,
#     primary_key: :id,
#     dependent: :destroy

#   has_many :actors,
#     through: :castings,
#     source: :actor
# end

#-------------------------------------------------------------------------------------

def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between 3 and 5
  # (inclusive). Show the id, title, year, and score.

  Movie
    .select(:id, :title, :yr, :score)
    .where('yr BETWEEN 1980 AND 1989')
    .where('score BETWEEN 3 AND 5')

end

def bad_years
  # List the years in which no movie with a rating above 8 was released.
  Movie
  .group(:yr)
  .having('MAX(score) < 8')
  # .where.not('score > 8')
  .pluck(:yr)
end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.
  Movie
    .select('actors.id, actors.name')
    .joins(:actors)
    .order('ord ASC')
    .where('title IN (?)', title)

end

def vanity_projects
  # List the title of all movies in which the director also appeared as the
  # starring actor. Show the movie id, title, and director's name.

  # Note: Directors appear in the 'actors' table.
  Movie
    .select(:id, :title, :name)
    .joins(:actors)
    .where('movies.director_id = castings.actor_id')
    .where('ord = 1')
end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name, and number of supporting roles.
  Casting 
    .select(:id, :name, 'COUNT(ord)')
    .joins(:actor)
    .order('COUNT(ord) DESC')
    .limit(2)
end
