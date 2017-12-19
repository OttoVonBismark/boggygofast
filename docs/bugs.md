# Bugfix Log
Find a bug? Great! Log what it was and how it was fixed here. Ongoing bugs to be listed at the bottom.
## Rails Test Output Duplication (12/19/2017)
### Problem
Running 'rails test' resulted in duplicated output which broke minitest and was generally hideous to look at.
### Caused by
The cause of the bug appears to be something in Rails 5.1.4 or it's base components. I'm not certain as to what, though.
### Fixed by
Downgrading Rails to 5.1.2 in the Gemfile and running bundle update.