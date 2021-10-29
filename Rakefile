# frozen_string_literal: true

require 'confidante'
require 'rake_terraform'
require 'rake_fly'
require 'paint'

configuration = Confidante.configuration

RakeFly.define_installation_tasks(version: '6.7.2')
RakeTerraform.define_installation_tasks(
  path: File.join(Dir.pwd, 'vendor', 'terraform'),
  version: '1.0.10'
)

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

namespace :ci do
  RakeFly.define_project_tasks(
    pipeline: 'aws-organisation',
    argument_names: %i[
      ci_deployment_group
      ci_deployment_type
      ci_deployment_label
    ]
  ) do |t, args|
    configuration = configuration
                    .for_scope(args.to_h.merge(role: 'pipeline'))
    ci_deployment_identifier = configuration.ci_deployment_identifier

    t.concourse_url = configuration.concourse_url
    t.team = configuration.concourse_team
    t.username = configuration.concourse_username
    t.password = configuration.concourse_password

    t.config = 'pipelines/pipeline.yaml'

    t.vars = configuration.vars
    t.var_files = [
      'config/secrets/pipeline/constants.yaml',
      "config/secrets/pipeline/#{ci_deployment_identifier}.yaml"
    ]

    t.non_interactive = true
    t.home_directory = 'build/fly'
  end
end
