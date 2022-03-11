AWS Organisation
=================

This repository sets up:
- the AWS organization and all associated organizational units and accounts.

Usage
-----
The configurations in this repository should be executed against an empty
account as the root user. As such a root user access key is required which
should be deleted once all configurations have been successfully applied.

### Provisioning the state storage bucket

To provision the state storage bucket:

```
aws-vault exec <root-profile> -- go "bootstrap:provision[<deployment_type>,<deployment_label>]"
```

### Adding a new AWS account

To add a new AWS account to the organization, update the configuration in
`infra/organization/organization.tf` to include a new account or organisational
unit. Note that all additions should be made at the bottom of the lists to
ensure existing accounts aren't modified.

Once the configuration has been updated, execute:

```
aws-vault exec <root-profile> -- go "organization:provision[<deployment_type>,<deployment_label>]"
```

After the account has been created:
1. Attempt to log in to the account as the root user using the email address
   provided when creating the account.
1. Click "Forgot password?" when prompted for the password.
1. Follow the forgotten password process and log in again.
1. Create and record an access key to bootstrap the account.
1. Use this access key with the `aws-base-account` repository to set up the
   admin user for the account.
1. Once the admin user is in place, remove the access key from the root user
   and enable MFA.

As a general rule, the root account should never be used except in emergencies
so lock the credentials away somewhere very safe and use the admin user for
anything requiring admin access.

Technologies Used
-----------------

The repository makes use of:

### Languages and Scripting

* [Ruby 2.7](https://ruby-doc.org/core-2.7.2/): Used for build and scripting

### Building and Packaging

* [Rake](http://docs.seattlerb.org/rake/): Simple build tool
* [RubyGems](https://rubygems.org): Packaging tool and standard for Ruby
* [Bundler](http://bundler.io): Dependency manager and isolator for Ruby

### Environment Automation

* [InfraBlocks](https://github.com/infrablocks): Modular and composable
  libraries for build and infrastructure.

Development Machine Requirements
--------------------------------

In order for the build to run correctly, a few tools will need to be installed
on your development machine:

* Ruby (2.7)
* Bundler
* git
* git-crypt
* gnupg
* direnv

### Mac OS X Setup

Installing the required tools is best managed by [homebrew](http://brew.sh) and
[homebrew-cask](http://caskroom.io).

To install homebrew:

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Then, to install the required tools:

```
# ruby
brew install rbenv
brew install ruby-build
echo 'eval "$(rbenv init - bash)"' >> ~/.bash_profile
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
eval "$(rbenv init -)"
rbenv install 2.7.2
rbenv rehash
rbenv local 2.7.2
gem install bundler

# git, git-crypt, gnupg
brew install git
brew install git-crypt
brew install gnupg

# direnv
brew install direnv
echo "$(direnv hook bash)" >> ~/.bash_profile
echo "$(direnv hook zsh)" >> ~/.zshrc
eval "$(direnv hook $SHELL)"

direnv allow <repository-directory>
```
