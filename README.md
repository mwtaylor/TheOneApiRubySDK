# ElephantInTheRoom::TheOneApiSdk

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add elephant_in_the_room-the_one_api_sdk

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install elephant_in_the_room-the_one_api_sdk

## Usage

An access key is required to use this SDK. Visit [The One API sign up](https://the-one-api.dev/sign-up) to get one.

Start using the SDK by passing the access key to get an instance of the SDK.

    the_one = ElephantInTheRoom::TheOneApiSdk::TheOne.new("YOUR_ACCESS_KEY")

Access one type of data by calling the appropriate method on the SDK, such as `.movies` to get information about one or more movies.

    the_one.movies.list # Get all movies
    the_one.movies.get("#{movie_id}") # Get one movie by ID

The SDK behavior can be changed with modifier methods. These can be chained.

    # Return at most 10 results
    the_one.paginated(limit: 10).movies.list

    # Try to make the call up to 3 times
    exponential_backoff = ElephantInTheRoom::TheOneApiSdk::RetryStrategy::ExponentialBackoff.new(3)
    the_one.with_retry_strategy(exponential_backoff).movies.list
    
    # Both modifiers active
    the_one.paginated(limit: 10).with_retry_strategy(exponential_backoff).movies.list

    # Use modifiers more than once
    the_one.paginated(limit: 10).with_retry_strategy(exponential_backoff) do |modified_sdk|
        modified_sdk.movies.list
        modified_sdk.movies.get("#{movie_id}")
    end

Quotes from a movie can be queried by movie ID or name

    the_one.movies.quotes_from_movie("#{movie_id}")
    the_one.movies.quotes_from_movie_name("#{movie_name}")

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

## Release

This gem is released every time code is pushed to the main branch.

To manually release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mwtaylor/TheOneApiRubySDK.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
