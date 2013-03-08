roles_field
===========

## Target
To add simple roles feature to a model (like user) in a field.

## Install
include in Gemfile:

```bash
gem 'roles-field'
```

## Usage
in a model:

```ruby
class User < ActiveRecord::Base
  roles_field :roles_mask, :roles => [:admin, :manager, :teacher, :student]
end
```

then

```ruby
@user.roles
# -> []

@user.set_role :admin
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