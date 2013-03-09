roles_field
===========

[![Build Status](https://travis-ci.org/mindpin/roles-field.png?branch=master)](https://travis-ci.org/mindpin/roles-field)
[![Code Climate](https://codeclimate.com/github/mindpin/roles-field.png)](https://codeclimate.com/github/mindpin/roles-field)

## Target
To add simple roles feature to a model (like user) in a field.

## Install
include in Gemfile:

```bash
gem 'roles-field'
```

## Usage
in a model width a field named 'roles_mask':

```ruby
# generate a model with a integer field
create_table :users, :force => true do |t|
  t.column :roles_mask, :integer
end

class User < ActiveRecord::Base
  # you can change to another field
  roles_field :roles_mask, :roles => [:admin, :manager, :teacher, :student]
end
```

then

```ruby
@user.roles
# -> []

@user.role = :manager
@user.save
@user.roles
# -> [:manager]

@user.set_role :admin
@user.save
@user.roles
# -> [:admin]

@user.role? :admin
@user.is_admin?
# -> true

@user.role? :teacher
@user.is_teacher?
# -> false

User.with_role :admin
# -> scope [...]
```

## TODO
to support multi-roles setting