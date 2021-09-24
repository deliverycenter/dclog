# frozen_string_literal: true

require_relative 'lib/dclog/version'

Gem::Specification.new do |spec|
  spec.name          = 'dclog'
  spec.version       = Dclog::VERSION
  spec.authors       = ['Jairo Junior', 'Matheus Acosta', 'Vinicius Machado']
  spec.email         = ['jairo.junior@deliverycenter.com', 'matheusthebr@gmail.com',
                        'vinicius.santana@deliverycenter.com']

  spec.summary       = 'A logger'
  spec.description   = 'A gem to format logs to json, and run one commando to log into sidekiq and rails'
  spec.homepage      = 'https://github.com/deliverycenter/dclog'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/deliverycenter/dclog'
  spec.metadata['changelog_uri'] = 'https://github.com/deliverycenter/dclog'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'

  spec.add_dependency 'rails', '>= 5.0.0'
end
