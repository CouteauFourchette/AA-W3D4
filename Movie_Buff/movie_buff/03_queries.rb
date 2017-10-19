require 'byebug'
# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  id          :integer      not null, primary key
#  movie_id    :integer      not null
#  actor_id    :integer      not null
#  ord         :integer

def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
  Movie
    .select(:title, :id)
    .joins(:actors)
    .where(actors: { name: those_actors })
    .group(:id)
    .having('COUNT(actors.id) >= ?', those_actors.length)


end

def golden_age
  # Find the decade with the highest average movie score.
  Movie
    .order('AVG(score) DESC')
    .group('(yr / 10)')
    .limit(1)
    .pluck('(yr/10)*10').first
end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery
  Actor
    .select('DISTINCT name')
    .joins(:castings)
    .where('castings.movie_id'=>
      Movie.select(:id).joins(:actors).where('actors.name = ?', name))
    .where.not(name: name)
    .pluck(:name).uniq
end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie
  Actor
    .left_outer_joins(:castings)
    .select('actors.id')
    .group('actors.id')
    .having('COUNT(castings.actor_id) = 0')
    .to_a.count
end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"
  new_s = '%' + whazzername.split('').join('%') + '%'
  Movie.joins(:actors).where("UPPER(actors.name) LIKE UPPER(?)", new_s)
end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.
  
end
