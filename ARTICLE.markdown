# Getting Started with Sequel

Ever since Rails came up in 2005, creating database-backed web applications has
never been easier. ActiveRecord still is one of its strongsuits because of how
it integrates tightly with the rest of the framework. However, through the
course of time some developers found the tool to be difficult to handle outside
of Rails.

Sequel is an Object-Relational Mapper (ORM) that qualifies as a first-class
tool in your arsenal, in and out of Rails. It is well tested and maintained by
the Ruby community. Read more if you want to get your hands wet.

## Bootstrapping Sequel

### Installtion

Like almost any tool in Ruby, installing Sequel is as easy as installing a gem:

    $ gem install sequel

If you're using Bundler within your project — which you should, by the way —
you'll need to refer to it in your Gemfile:

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

## Thinking Datasets

* Select
* Insert
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
