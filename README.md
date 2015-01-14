# Ruby JSON-ROA Client

A ruby client for `JSON-ROA`.

## State

[![Code Climate][]][]

  [Code Climate]: https://codeclimate.com/github/json-roa/json-roa_ruby-client/badges/gpa.svg
  [![Code Climate][]]: https://codeclimate.com/github/json-roa/json-roa_ruby-client

## Usage

### Connecting 

```ruby
require 'json_roa/client'

@root_relation= JSON_ROA::Client.connect @base_url do |conn|
  conn.basic_auth(@username,@password)
end
```

`conn` is a [Faraday][] connection.


###  Resources 

#### Retrieving the Resource of the Root Relation

```ruby
@root_resource= @root_relation.get()
```

#### Data

```ruby
@root_resource.data
```

#### JSON-ROA Data

```ruby
@root_resource.json_roa_data
```

### Relations

```ruby
@root_resource.relation('execution')
```

#### Resource of a Relation

In this case the relation is based on an [URI Template][] and we
must provide an `id` parameter.

```ruby
@execution_resource= @root_resource.relation('execution').get('id' => '55744c40-b764-4fd4-98e2-7a69bc57f496')
```

### Collections

A resource that is conceptual an *index* can be processed as an
[Enumerable][] of its relations. The client will abstract pagination
away.

```ruby
@root_resource.relation('executions').get.collection.each do |execution_relation| 
  puts execution_relation.get.data
end
```

  [Enumerable]: http://ruby-doc.org/core-2.1.0/Enumerable.html
  [URI Template]: http://tools.ietf.org/html/rfc6570
  [Faraday]: https://github.com/lostisland/faraday



## Semantic Versioning and Rubygems Versioning

This library is _BETA_ because the [JSON-ROA specifciation][] itself is
_BETA_. This library uses [Semantic Versioning][] and the current version
is [1.0.0-beta.2](./lib/json_roa/client/version.rb).

The rubygems system [claims also to use semantic versioning][] and even *urges
gem developers to follow it*. Rubygems transforms the version as given above
into `1.0.0.pre.beta.1`. Any work using this library should specify the
following in the Gemfile 

    gem 'json_roa-client', '= 1.0.0.pre.beta.2' 

or the following in the gemspec 

    spec.add_runtime_dependency 'json_roa-client', '= 1.0.0.pre.beta.2'

In the latter case, building the gem will result in a warning because of the
prerelease. You can safely ignore this warning. It is in the context of
semantic versioning misleading. However, it is important to fix the dependency
by using the `=` sign. In this case, violation would warrant a warning. 




  [JSON-ROA specifciation]: http://json-roa.github.io/specification.html
  [Semantic Versioning]: http://semver.org/
  [claims also to use semantic versioning]: http://guides.rubygems.org/patterns/#semantic-versioning

