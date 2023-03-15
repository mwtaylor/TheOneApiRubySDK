# frozen_string_literal: true

require_relative "lib/michael_taylor_sdk/version"

Gem::Specification.new do |spec|
  spec.name = "michael_taylor_sdk"
  spec.version = MichaelTaylorSdk::VERSION
  spec.authors = ["Michael Taylor"]
  spec.email = ["mwtaylor@users.noreply.github.com"]

  spec.summary = "SDK for the Lord of the Rings API"
  spec.homepage = "https://github.com/mwtaylor/MichaelTaylor-SDK"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["github_repo"] = "https://github.com/mwtaylor/MichaelTaylor-SDK"

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

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
