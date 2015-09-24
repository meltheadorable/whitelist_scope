#Whitelist Scope

[![Gem Version](https://badge.fury.io/rb/whitelist_scope.svg)](http://badge.fury.io/rb/whitelist_scope)[![Build Status](https://travis-ci.org/meltheadorable/whitelist_scope.svg)](https://travis-ci.org/meltheadorable/whitelist_scope)[![Code Climate](https://codeclimate.com/github/meltheadorable/whitelist_scope/badges/gpa.svg)](https://codeclimate.com/github/meltheadorable/whitelist_scope)[![Coverage Status](https://coveralls.io/repos/meltheadorable/whitelist_scope/badge.svg?branch=stable)](https://coveralls.io/r/meltheadorable/whitelist_scope?branch=stable)[![Dependency Status](https://gemnasium.com/meltheadorable/whitelist_scope.svg)](https://gemnasium.com/meltheadorable/whitelist_scope)[![Documentation Status](http://inch-ci.org/github/meltheadorable/whitelist_scope.svg?branch=develop)](http://inch-ci.org/github/meltheadorable/whitelist_scope)

`whitelist_scope` provides a safe way to register and call scopes inside rails apps

> #### :warning: **Warning**:
>
> whitelist_scope is in the very early stages of development right now, has few tests and could introduce breaking changes. Use at your own risk.

Getting Started
---------------

To get started, add whitelist_scope to your gemfile:

`gem 'whitelist_scope'`

Then run `bundle install` to fetch the current version.

Usage
-----

Using WhitelistScope is very simple. All you need to do is specify whitelisted scopes in your models, then call `call_whitelisted_scope` in your controllers naming a scope.

### Models

Whitelist Scope acts as a wrapper around ActiveRecord scopes, providing a tiny bit of extra functionality to keep track of the whitelist.

If you don't know what scopes are, [you can read about them here](http://guides.rubyonrails.org/active_record_querying.html#scopes):

First you'll need to extend WhitelistScope, and then you can specify your scopes.

```ruby
class Item < ActiveRecord::Base
  extend WhitelistScope # includes the whitelist_scope methods in your model

  whitelist_scope :most_recent, -> { order(updated_at: :desc) }
  whitelist_scope :created_first, -> { order(created_at: :asc) }
  whitelist_scope :approved, -> { where(approved: true) }
  whitelist_scope :featured, -> { where(featured: true) }
end
```

`whitelist_scope` takes a symbol as a name, and a lambda, exactly like an ActiveRecord scope.

### Controllers

For your controllers, WhitelistScope provides the `call_whitelisted_scope` method, which takes a string naming one of your whitelisted scopes as an argument. Because WhitelistScope uses scopes under the hood, it can be chained with other scopes.

> #### :warning: **Warning**:
>
> The `whitelist_scope` method will raise a `NoMethodError` if it cannot find a whitelisted with the name you passed in.

```ruby
class ItemController < ApplicationController
  def index
    @items = Item.call_whitelisted_scope("most_recent") # sorts your items by most recent
    @others = Item.call_whitelisted_scope(params[:sort]) # sorts by the method specified in the params
    @approved_features = Item.call_whitelisted_scope("approved", "featured") # call multiple at once
  end
end
```

Because it uses scopes under the hood, WhitelistScope also provides separate methods for your whitelisted scopes:

```ruby
class ItemController < ApplicationController
  def index
    @items = Item.created_first # all of your Items, sorted by creation date
  end
end
```

License
-------

WhitelistScope is released under the [MIT License](LICENSE)
