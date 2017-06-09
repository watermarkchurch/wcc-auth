# WCC::Auth

Provides the necessary tools for handling authentication through
Watermark's OAuth provider as well as authorizing the user has access to
specific features within the application. There are special hooks for
Rails apps using Devise, but the primitive structures could be used on
any Ruby project. Currently, the only tested path is Rails with Devise.

## Installation

**NOTE: `v0.6.0` has been updated for use with Rails 5.1 and requires Ruby 2.2 or greater.**

Add this line to your application's Gemfile:

```ruby
gem 'wcc-auth', '~> 0.3.2'
```

If you are using a Rails app with Devise you can use a special require
hook that will setup all the Devise specific configuration for you.

```ruby
gem 'wcc-auth', '~> 0.3.2', require: 'wcc/auth/devise'
```

## Configuration

There are a few steps to setup your app. These instructions are specific
to a Rails app.

#### Add the configuration block to an initializer

In order to configure the gem you must run the `WCC::Auth.setup` block.
See below for an example:

```ruby
WCC::Auth.setup do |config|
  config.app_name = "app-name"
  config.environment = Rails.env
  config.app_id = 'app-client-id-from-oauth-provider'
  config.app_secret = 'app-client-secret-from-oauth-provider'
end
```

#### Setup your controllers

```ruby
# Add this include to your ApplicationController
class ApplicationController < ActionController::Base
  include WCC::Auth::ControllerHelpers
end
```

#### Setup your user model

```ruby
class User < ActiveRecord::Base
  include WCC::Auth::Providers::ActiveRecord
  devise :omniauthable

  # ...

end
```

#### Setup authorization (optional)

If you would like to use the `TieredAbility` class included with
`WCC::Auth` just create an Ability class that extends the
`WCC::Auth::TieredAbility` class. The authenticated user will include an
info variables called `access_level_id`. This corresponds to a
`WCC::Auth::AccessLevel`.

The access levels are broken down into 5 tiers with the following rules:

* **No access** -- This is the default level
* **Basic** -- This is provides read-only access
* **Contribute** -- Read-write for only data the user owns
* **Manage** -- Read-write for other's data
* **App Admin** -- Can change app configuration
* **System Admin** -- Has full access to all features always

Each tier inherits all priveleges of the lower tiers. The rules here are
guidelines for the app to follow. It is ultimately up to the client
application to decide what each of these tiers means for it. Do your
best to adhere to these rules.

Here is an example Ability class using the DSL provided by `WCC::Auth`.

```ruby
class Ability < WCC::Auth::TieredAbility
  at_level(:contribute) do |user|
    can :read, Person
    can :manage, Task, created_by_id: user.id
    can :manage, Comment, created_by_id: user.id

    cannot :destroy, Task
  end

  at_level(:appadmin) do |user|
    can :manage, :all
    cannot :create, TaskGroup
  end


  at_level(:sysadmin) do |user|
    can :manage, :all
  end
end
```

## Notes

#### Sign out links

If your project is using `TurboLinks`, you'll need to disable it for the sign out link(s). Otherwise, it will cause your app to enter an infinite redirect loop.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
