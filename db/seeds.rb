# Set up users.
User.create!(name: "Example User", email: "adminman@boggygofast.org", password: "foobar", password_confirmation: "foobar", admin: true)

99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name: name, email: email, password: password, password_confirmation: password)
end

# Set up games.
Game.create!(name: "Metroid Prime", slug: "metroid_prime")
Game.create!(name: "Ori and the Blind Forest: Definitive Edition", slug: "ori_bf_de")
Game.create!(name: "Metroid 2: Samus Returns", slug: "metroid_sr")

# Set up runcats.
Runcat.create!(category: "any%", rules: "Beat the game as fast as possible.", game_id: 1)
Runcat.create!(category: "100% Pickups", rules: "Beat the game as fast as possible, collecting every pickup along the way.", game_id: 1)
Runcat.create!(category: "All Cells any%", rules: "Beat the game as fast as possible, collecting every health, energy, and ability cell along the way.", game_id: 2)
Runcat.create!(category: "All Abilities any%", rules: "Beat the game as fast as possible while unlocking all of Ori's abilities along the way.", game_id: 2)
Runcat.create!(category: "100% No Amiibo", rules: "Beat the game as fast as possible, collecting all pickups along the way. Amiibo usage is forbidden.", game_id: 3)
Runcat.create!(category: "100%", rules: "Beat the game as fast as possible, collecting all pickups along the way.", game_id: 3)

# Set up speedruns.
Speedrun.create!(game_id: 1, user_id: 1, date_finished: "2018-01-18", runcat_id: 1, run_time: "01:10:45", run_notes: "I should be in Metroid Prime 1 any%", is_valid: true)
Speedrun.create!(game_id: 1, user_id: 1, date_finished: "2018-01-18", runcat_id: 1, run_time: "00:00:01", run_notes: "I'm a cheating dirtbag!", is_valid: false)
Speedrun.create!(game_id: 1, user_id: 2, date_finished: "2017-12-31", runcat_id: 2, run_time: "01:47:23", run_notes: "I should be in Metroid Prime 1 100%", is_valid: true)
Speedrun.create!(game_id: 2, user_id: 2, date_finished: "2018-01-01", runcat_id: 3, run_time: "01:56:25", run_notes: "I should be in Ori BF DE All Cells any%", is_valid: true)
Speedrun.create!(game_id: 2, user_id: 3, date_finished: "2017-09-15", runcat_id: 3, run_time: "01:47:01", run_notes: "Ditto", is_valid: true)
Speedrun.create!(game_id: 2, user_id: 4, date_finished: "2017-09-16", runcat_id: 4, run_time: "00:58:34", run_notes: "I should be in Ori BF DE All Abilities", is_valid: true)
Speedrun.create!(game_id: 3, user_id: 5, date_finished: "2017-10-11", runcat_id: 5, run_time: "00:59:59", run_notes: "I should be in Metroid SR 100% No amiibo", is_valid: true)
Speedrun.create!(game_id: 3, user_id: 6, date_finished: "2017-11-12", runcat_id: 6, run_time: "00:56:00", run_notes: "I should be in Metroid SR 100%", is_valid: true)
Speedrun.create!(game_id: 2, user_id: 37, date_finished: "2017-05-04", runcat_id: 4, run_time: "00:30:34", run_notes: "Validate me in Ori BF DE All abilities", is_valid: false)
Speedrun.create!(game_id: 3, user_id: 100, date_finished: "2017-12-04", runcat_id: 6, run_time: "01:00:04", run_notes: "Validate me in Metroid SR 100%", is_valid: false)