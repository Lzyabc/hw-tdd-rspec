# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  # fail "Unimplemented"
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  # fail "Unimplemented"
  expect(page.body.index(e1) < page.body.index(e2))
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  all_ratings = Movie.all_ratings
  if uncheck == "un"
    uncheck_ratings = rating_list.gsub(' ', '').split(',')
    check_ratings = all_ratings - uncheck_ratings
  else
    check_ratings = rating_list.gsub(' ', '').split(',')
    uncheck_ratings = all_ratings - check_ratings
  end
  check_ratings.each do |single|
    # step %{I #{uncheck.nil? ? '' : 'un'}check "ratings_#{rating}"}
    step %{I check "ratings_#{single}"}    
  end
  uncheck_ratings.each do |single|
    step %{I uncheck "ratings_#{single}"}    
  end

end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    step %{I should see "#{movie.title}"}
  end
end
