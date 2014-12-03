# Ruby JSON-ROA Client

A ruby client for `JSON_ROA`.

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

