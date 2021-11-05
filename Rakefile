# frozen_string_literal: true
require "yaml"
require 'securerandom'
require 'rake_circle_ci'
require 'rake_gpg'
require 'confidante'
require 'rake_terraform'
require 'paint'

configuration = Confidante.configuration

RakeTerraform.define_installation_tasks(
  path: File.join(Dir.pwd, 'vendor', 'terraform'),
  version: '1.0.10'
)

namespace :encryption do
  namespace :passphrase do
    desc 'Generate encryption passphrase for CI GPG key'
    task :generate do
      File.open('config/secrets/ci/encryption.passphrase', 'w') do |f|
        f.write(SecureRandom.base64(36))
      end
    end
  end
end

namespace :secrets do
  desc 'Check if secrets are readable'
  task :check do
    if File.exist?('config/secrets')
      puts 'Checking if secrets are accessible.'
      unless File.read('config/secrets/.unlocked').strip == 'true'
        raise Paint['Cannot access secrets.', :red]
      end

      puts 'Secrets accessible. Continuing.'
    end
  end

  desc 'Unlock secrets'
  task :unlock do
    if File.exist?('config/secrets')
      puts 'Unlocking secrets.'
      sh('git crypt unlock')
    end
  end
end

namespace :bootstrap do
  RakeTerraform.define_command_tasks(
    configuration_name: 'bootstrap infrastructure',
    argument_names: %i[
      deployment_group
      deployment_type
      deployment_label
    ]
  ) do |t, args|
    configuration = configuration
                    .for_scope(args.to_h.merge(role: 'bootstrap'))

    deployment_identifier = configuration.deployment_identifier
    vars = configuration.vars

    t.source_directory = 'infra/bootstrap'
    t.work_directory = 'build'

    t.state_file =
      File.join(
        Dir.pwd, "state/bootstrap/#{deployment_identifier}.tfstate"
      )
    t.vars = vars
  end
end

namespace :organization do
  RakeTerraform.define_command_tasks(
    configuration_name: 'AWS organisation and accounts',
    argument_names: %i[
      deployment_group
      deployment_type
      deployment_label
    ]
  ) do |t, args|
    configuration = configuration
                    .for_scope(args.to_h.merge(role: 'organization'))

    t.source_directory = 'infra/organization'
    t.work_directory = 'build'

    t.backend_config = configuration.backend_config
    t.vars = configuration.vars
  end
end

RakeCircleCI.define_project_tasks(
  namespace: :circle_ci,
  project_slug: 'github/infrablocks-examples/aws-organisation'
) do |t|
  circle_ci_config =
    YAML.load_file('config/secrets/circle_ci/config.yaml')

  t.api_token = circle_ci_config['circle_ci_api_token']
  t.environment_variables = {
    ENCRYPTION_PASSPHRASE:
      File.read('config/secrets/ci/encryption.passphrase')
          .chomp
  }
  t.checkout_keys = []
end
