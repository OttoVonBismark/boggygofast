# Boggy Go Fast
## Speedrun Archive Application

Currently in BETA, Boggy Go Fast is a speedrun archiving tool. The current aim is to polish features for a full LAN-Mode release. Once that's done, I'll begin work on a separate branch for the internet-facing permutation which will feature much more stringent security. That said, do NOT run the LAN version on internet-facing servers. It has no account activation mechanisms, password resets, etc. by design since it is, as it's name would imply, designed for personal usage on a local network environment with no email server.

## What purpose does this serve?

A good question! If you're a speedrunner, Boggy Go Fast can help you keep track of your times, as well as those of your friends. It's geared more towards casual runners who aren't overly interested in world-class speedrunner strats, preferring instead to 'freestyle' through games as fast as possible without feeling pressured by the more dedicated runners. That said, I've designed this application to be usable by anyone regardless of skill level.

## Want to develop locally? Here's what's missing (for security)

You'll want to create `config/credentials.yml.enc` and `config/master.key` since I'm not including mine in repos. All you need to do in this case is run `rails credentials:edit` and Rails will generate what you need. In production, this app requires MySQL for the database backend. (refer to `config/database.yml` for what details you'll need to provide in your credentials file).
If you don't like MySQL, feel free to modify the guts to suit your needs. Just know that I won't accept pull requests that change the DB backend.
Migrations files are periodically deleted to keep file counts lower and to prevent databases from flipping out. Plus, I add migrations to FIX things, which implies there are things that were BROKEN. Don't use `db:migrate` when setting up for the first time. Use `db:schema:load` instead. That'll get you the latest snapshot of the db structure with all the fixes and none of the SQL throttling. It is also HIGHLY ADVISED you do this when deploying! Save yourself a headache or two! You're welcome.
Lastly, if Rails spits out an error asking for an $EDITOR variable, open up your bash profiler of choice (depending on your situation. Google that stuff if you're unsure which one you need) and toss in a line reading `EDITOR="nano"` where 'nano' is either itself or your CLI editor of choice.