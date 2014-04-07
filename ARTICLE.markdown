# Getting Started with Sequel

Ever since Rails came up in 2005, creating database-backed web applications has
never been easier. ActiveRecord still is one of its strongsuits because of how
it integrates tightly with the rest of the framework. However, through the
course of time some developers found the tool to be difficult to handle outside
of Rails.

Sequel is an Object-Relational Mapper (ORM) that qualifies as a first-class
tool in your arsenal, in and out of Rails. It is well tested and maintained by
the Ruby community. In this article you'll learn the bulk of Sequel's features
so read on if you want to get your hands wet.

## Bootstrapping Sequel

### Installation

Like almost any tool in Ruby, installing Sequel is as easy as installing a gem:

    $ gem install sequel

If you're using Bundler within your project — which you should, by the way —
you'll need to refer to it in your `Gemfile` instead:

    gem "sequel"

Remember that you will also need to refer the appropriate database Ruby adapter
gem in order for Sequel to interact properly with the database.

* For Postgres, install `pg`;
* For MySQL, install `mysql2`;
* For SQLite3, install `sqlite3`.

There are many other adapters you can choose from, depending on which database
system you pick. A full list of adapters that Sequel is found in [its
documentation](http://sequel.jeremyevans.net/rdoc/files/doc/opening_databases_rdoc.html).
Check the _Adapter specific connection options_ chapter.

Once you have these two gems installed, you will be ready to use Sequel to
actually connect to a database.

### Connecting to a Database

Connecting to a database using Sequel is really easy. All you need to do is
type an instruction inside your project:

    DB = Sequel.connect(args)

A strong convention of Sequel users is to assign a `DB` variable to the result
of `connect`. Every operation you'll want to perform will be called from that
`Sequel::Database` object.

You're wondering what kind of `args` you can insert into the instruction above.
It turns out there are two kinds:

* You can pass a URI string to your database location like this:
  `sqlite://db/development.sqlite3`. If you're using Postgres with a username
  and password, you can send that information along too:
  `postgres://username:password@localhost/my_app_db`.

* You can also use a hash to accomplish the same effect. Considering the same
  Postgres example, you can connect by typing:

      DB = Sequel.connect({
        adapter:  "postgres",
        host:     "localhost",
        database: "my_app_db",
        user:     "username",
        password: "password"
      })

Sequel makes it easy for those who want to quickly connect to a DB without much
trouble via a URI, as well as those who require configuration to be stored in a
hash. This is great if you use something like Rails and already have a YAML
file with all the database access data. You can load that file and convert it
to a hash, ready to be injected to `Sequel.connect`.

Now that you are connected to the database, let's operate on it!

## Thinking Datasets

There are two perspectives you can assume when using Sequel. One of them is the
more SQL-like approach, in which you consider data in the form of generic
datasets.

### Querying for Data

Let's consider a basic example of accessing a set of posts. The resulting SQL
query would be something in the lines of `SELECT * FROM posts`, pretty
standard.

> **Note:** Sequel abstracts SQL away by providing as much of a Ruby API as
possible, making up for easier development and also greater protection against
hacking.

To achieve the result in Ruby, you access the `DB` global object:

    DB[:posts]

The symbol matches the respective table name. This instruction is super simple
and yet so understandable: it's like the database is a hash and its many items
in the hash are tables, represented by their name in the index.

What if we want to filter those posts with a condition? For example, find a
particular post by its id. To retrieve it, you use the `where` method:

    DB[:posts].where(id: 1)

The `where` method takes different [kinds of
arguments](http://sequel.jeremyevans.net/rdoc/classes/Sequel/Dataset.html#method-i-where).
Each key in the hash you pass matches a column in your table. The values can
vary between strings, numbers, arrays, ranges and procs. Let me give you some
examples for each one of them:

    DB[:posts].where(id: 1)
    # SELECT * FROM posts WHERE (id = 1)
     
    DB[:posts].where(id: 1..5)
    # SELECT * FROM posts WHERE (id > 1 and id <= 5)
     
    DB[:posts].where(id: [1, 3, 6])
    # SELECT * FROM posts WHERE (id IN (1, 3, 6))
     
    DB[:posts].where { id > 7 }
    # SELECT * FROM posts WHERE (id > 7)

Because of Sequel's design, you can chain multiple `where` calls and they will
added to the query, which allows to iteratively build your queries without
complications:

    DB[:posts].where("id > ?", 1).where("id <= ?", 5)
    # SELECT * FROM posts WHERE (id > 1 and id <= 5)

If you want to know everything about filtering in Sequel, you can check more
information in the [official
documentation](http://sequel.jeremyevans.net/rdoc/files/doc/dataset_filtering_rdoc.html).

You also have the possibility of choosing particular columns with the `select`
method, sort results with the `order` method, limit the number of record with
`limit` and [many more
methods](http://sequel.jeremyevans.net/rdoc/files/doc/dataset_basics_rdoc.html#label-Methods+that+return+modified+datasets).
Here's an example:

    DB[:posts].select(:id, :name).order(:name).where(id: 1..5)
    # SELECT id, name FROM posts WHERE (id > 7) ORDER BY name

#### Retrieving data

All of the features I've shown you up until here manipulate the SQL query to be
executed in the database. You still don't have any data in your hands to use
yet, let's learn what we can do to accomplish that.

The most generic method, `all`, allows you to fetch all of the records, but
there are also other methods you can use to retrieve data differently:

* `first` gets you the first record;
* `last` gets you the last record;
* `[index]` gets you the record in that position;
* `count` performs a `COUNT` query and retrieves the resulting amount of records;
* `avg(:age)` gets you an average for a possible `age` attribute;
* `max(:age)` gets the maximum value for a possible `age` attribute;
* `max(:age)` gets the minimum value for a possible `age` attribute.

All of these retrieve actual data in the form of a hash. Many more methods are
at your disposal, check them out at the [correct
section](sequel.jeremyevans.net/rdoc/files/doc/dataset_basics_rdoc.html#label-Methods+that+execute+code+on+the+database)
in the docs.

### Inserting Data

* Update
* Delete

## Thinking Models

* Models
* Associations
* Associations methods

## Other Features

* Transactions
* Migrations
* Sharding
* Plugins

## [?] Compared to ActiveRecord

## Conclusion
