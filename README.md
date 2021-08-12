# DcLog

## About

vc pode configurar o environment.rb para deixar o log padrao em todos os ambientes, ou configurar apenas no production.rb (mas recomendamos que configure no env.rb para que nao tenha overwrite das configuracoes de ambiente)
ele garante que loga o stdout/stderr tanto na maquina Rails quanto Sidekiq
cria uma interface amigavel pro rails logger e pro sidekiq logger, tentando, inclusive, passar a funçao que chamou ele e reduzindo consideravelmente o tamanho da linha de codigo

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dclog'
```

And then execute:

    $ bundle install

explicar config logger JSON

vc pode configurar o environment.rb para deixar o log padrao em todos os ambientes, ou configurar apenas no production.rb (mas recomendamos que configure no env.rb para que nao tenha overwrite das configuracoes de ambiente)

```ruby
# config/environment.rb

require_relative 'application'

Rails.application.configure do
  ...

  logger = ActiveSupport::Logger.new($stdout)
  logger.formatter = proc do |severity, datetime, progname, message|
    "#{JSON.dump(
      severity: severity,
      date: datetime.strftime('%Y-%m-%d %H:%M:%S'),
      caller: progname,
      message: message
    )}\n"
  end
  config.logger    = ActiveSupport::TaggedLogging.new(logger)
  level            = ENV.fetch('LOG_LEVEL', 'info')
  config.log_level = Rails.env.test? ? :warn : level.underscore.to_sym
  config.log_tags  = [:request_id]

  ...
end

Rails.application.initialize!
```

## Usage

chamar a gem + nivel de severidade e ela busca automaticamente o nome do metodo

```ruby
Dclog.info('Im an info log')

Dclog.warn('Im an info log')

Dclog.error('Im an info log')

Dclog.fatal('Im an info log')

Dclog.debug('Im an info log')
```

verifique a possibilidade de substituir todas as chamadas de log para utilizar apenas o Dclog e não mais o logger padrao

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dclog.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
