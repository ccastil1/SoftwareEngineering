# Load DSL and set up stages
require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/puma'

# Loads custom tasks from `lib/capistrano/tasks` if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
