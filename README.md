# Gitmirror

Gitmirror is a small library for maintaining local mirrors of remote repositories. This makes it especially useful to handle post-commit triggers and automatically pull changes from a remote.

Gitmirror is inspired by [girror](https://github.com/eladb/node-girror).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitmirror'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gitmirror

## Usage

```ruby
require 'gitmirror'
repository = Gitmirror::Repository.new('https://github.com/databus23/gitmirror')
local_path = repository.mirror                 # create/update a bare local local mirror of remote
repository.checkout("/tmp/checkout", "master") # create a checkout from the local mirror
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec gitmirror` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


