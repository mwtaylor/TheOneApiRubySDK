# frozen_string_literal: true

require_relative "lib/elephant_in_the_room/the_one_api_sdk/version"

Gem::Specification.new do |spec|
  spec.name = "elephant_in_the_room-the_one_api_sdk"
  spec.version = ElephantInTheRoom::TheOneApiSdk::VERSION
  spec.authors = ["Michael Taylor"]
  spec.email = ["mwtaylor@users.noreply.github.com"]

  spec.summary = "SDK for The One API to return data about The Lord of the Rings"
  spec.homepage = "https://github.com/mwtaylor/TheOneApiRubySDK"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["github_repo"] = "https://github.com/mwtaylor/TheOneApiRubySDK"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
