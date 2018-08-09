# Updates SQLite databases to use integers for true/false instead of t/f
namespace :upgrades do
  desc "Updates database entries for SQLite so that booleans use integers instead of 't' and 'f' since that is now deprecated."
  task update_sqlite_bools: :environment do
    puts "Updating Speedrun model..."
    Speedrun.where("is_valid = 't'").update_all(is_valid: 1)
    Speedrun.where("is_valid = 'f'").update_all(is_valid: 0)
    puts "Done."
    puts "Updating User model..."
    User.where("admin = 't'").update_all(admin: 1)
    User.where("admin = 'f'").update_all(admin: 0)
    puts "Done."
  end

end
