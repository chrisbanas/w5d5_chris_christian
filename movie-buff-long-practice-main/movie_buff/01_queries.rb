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


def it_was_ok
  # Consider the following:
  #
  # Movie.where(yr: 1970..1979)
  #
  # You can use ranges (a..b) inside a where method.
  #
  # Find the id, title, and score of all movies with scores between 2 and 3.


  Movie
    .select(:id, :title, :score)
    .where("score BETWEEN 2 AND 3")
end

def harrison_ford
  # Consider the following:
  #
  # Actor
  #   .joins(:movies)
  #   .where(movies: { title: 'Blade Runner' })
  #
  # It's possible to join based on Active Record associations defined in models.
  #
  # Find the id and title of all movies in which Harrison Ford appeared but not
  # as a lead actor.

  Movie
    .select(:id, :title)
    .joins(:actors)
    .where("name = 'Harrison Ford' AND ord > 1")

end

def biggest_cast
  # Consider the following:
  #
  # Actor
  #   .joins(:movies)
  #   .group('actors.id')
  #   .order('COUNT(movies.id) DESC')
  #   .limit(1)
  #
  # Sometimes you need to use aggregate SQL functions like COUNT, MAX, and AVG.
  # Often these are combined with `group` (SQL: `GROUP BY`).
  #
  # Find the id and title of the 3 movies with the largest casts (i.e., most
  # actors).

  Movie
    .select(:id, :title)
    .joins(:castings)
    .group(:id)
    .order('COUNT(actor_id) DESC')
    .limit(3)

end

def directed_by_one_of(them)
  # Consider the following:
  #
  # Movie.where('yr IN (?)', years)
  #
  # You can use IN to test if an element is present in an array.
  #
  # Active Record gives you an even better way to write this:
  #
  # Movie.where(yr: years)
  #
  # Find the id and title of all the movies directed by one of 'them'.

  # Note: Directors appear in the 'actors' table.
  Movie 
    .select(:id, :title)
    .joins(:director)
    .where('name IN (?)', them)

end

def movie_names_before_1940
  # Consider the following:
  #
  # Movie.where('score < 2.0').pluck(:title)
  # => ['Police Academy: Mission to Moscow']
  #
  # Pluck works similarly to select, except that it converts a query result
  # directly into a Ruby Array instead of an Active Record object. This can
  # improve performance for larger queries.
  #
  # Use pluck to find the title of all movies made before 1940.
  Movie.where('yr < 1940').pluck(:title)
end
