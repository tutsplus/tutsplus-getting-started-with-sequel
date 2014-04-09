# Getting Started with Sequel

Ever since Rails came up in 2005, creating database-backed web applications has
never been easier. ActiveRecord still is one of its strong suits because of how
it integrates tightly with the rest of the framework. However, through the
course of time some developers found the tool to be difficult to handle outside
of Rails.

[Sequel](http://sequel.jeremyevans.net) is an Object-Relational Mapper (ORM)
that qualifies as a first-class tool in your arsenal, in and out of Rails. It
is well tested and maintained by the Ruby community. In this article you'll
learn the bulk of Sequel's features so read on if you want to get your hands
dirty.

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
documentation](http://sequel.jeremyevans.net/rdoc/files/doc/opening_databases_rdoc.html#label-Adapter+specific+connection+options).

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
more SQL-like approach, _dataset oriented_, in which you consider data in the form of generic
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
be added to the query, which allows you to iteratively build your queries
without complications:

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
section](http://sequel.jeremyevans.net/rdoc/classes/Sequel/Dataset.html#2+-+Methods+that+execute+code+on+the+database)
in the docs.

You apply each of these methods on top of your query builder. An example of
this would be:

    DB[:posts].select(:id, :name).order(:name).where(id: 1..5).all

You would be retrieving a dataset with all the posts whose ids are between 1
and 5, but just the name and id, sorted by name.

### Inserting Data

Notice how we've been using the same `DB` global object throughout the entire
set of examples. Well, we're not deviating from it to insert some data into our
repository.

To insert data we request the same table as we did before. After selecting it,
we request to insert a new record into it:

    DB[:posts].insert(title: "Hello Tuts+", body: "A really big post.")
    # INSERT INTO posts (title, body) VALUES ("Hello Tuts+", "A really big post.")

The arguments list consists of a hash of options. Each key matches a column in
the table. If the record is successfully saved, you get the value of the
primary key, usually an `id` property. That way, we have a means of accessing
it later.

### Updating Data

Updating data in your repository is achieved through the `update` method:

    DB[:posts].update(title: "Hello Tuts+", body: "A really big post.")
    # UPDATE posts SET title = "Hello Tuts+", body = "A really big post."

Watch out for performing updates like this without filtering out your data
first. Wait, we already know how to do that!

    DB[:posts].where(id: [1,4,6]).update(title: "Hello Tuts+", body: "A really big post.")
    # UPDATE posts SET title = "Hello Tuts+", body = "A really big post." WHERE id in (1,4,6)

### Deleting Data

The same way we use `insert` to add new data and `update` to change existing
data, you use `delete` to remove data:

    DB[:posts].delete
    # DELETE FROM posts

The same way you should be careful with updating data, pay the same attention
to removing data, filter it out first:

    DB[:posts].where(id: 1).delete
    # DELETE FROM posts WHERE id = 1

* * *

As you can see by the examples given, Sequel closes the gap between developers
and database systems a great deal. You can focus on your beautiful, semantic
Ruby code and take maximum advantage of your database. This dataset oriented
approach awards different takes at managing your product's data. You can either
build quick scripts to gather intelligence about your data or you can build
solid application code with strong methods and practices, covered by tests.
That's what makes Sequel so appealing, there's more than one way to tackle your
data.

## Thinking Models

The second approach to using Sequel is _model oriented_. You resort to Ruby
classes that represent and add behavior to your records. Models give you the
possibility of establishing relationships between them as you'll see in the
examples ahead.

### Defining Models

To define a model, you create a class that inherits from `Sequel::Model`.
That's it.

    class Post < Sequel::Model
    end

The mapping that's established between the model and the table is very similar
to ActiveRecord in that regard, it uses pluralization. If you have a model
called `Post`, the table should be called `posts`.

From this new class you've created you can perform any operation that you've
learned from the dataset perspective. Models in Sequel are just wrappers around
`Sequel::Dataset`. The main difference is in the return value, in the way that
instead of getting a hash or a dataset, you get an actual model instance with
accessors to the various properties.

    Post.where(id: 1).first # Returns an instance of Post

The code sample fetches the record with the id of 1. However, `Sequel::Model`
allows you to simply reach that same record via the `[]` method:

    Post[1] # Returns an instance of Post

As you would expect, there are a load of different methods available in
`Sequel::Model`:

* `save` allows you to insert a new record into the database. The object is
  created via the `new` method with all the data and then you save it.

* `update` changes the data in your object. You pass a hash of new data and it
  persists.

* `destroy` removes the record from the database.

These are the core methods to manipulate records as models. They are just some
of the many commands you can issue to a model. You can check the [full
reference](sequel.jeremyevans.net/rdoc/classes/Sequel/Model/InstanceMethods.html)
for more details but these should get you started.

### Associations

Similar to ActiveRecord, Sequel allows you to define associations between
models by invoking class methods inside the model class. The conventions are
must more SQL-like than ActiveRecord but they're pretty straightforward.

    # Post has many Comments
    class Post < Sequel::Model
      one_to_many :comments
    end

    # Comment belongs to Post
    class Comment < Sequel::Model
      many_to_one :post
    end

The example demonstrates a relationship between a blog post and the comments
users can submit. A post has many comments. In turn, the comments belong to a
post. If nothing else is declared, we are assuming that:

* There are two tables: `posts` and `comments`;
* The `comments` table has a `post_id` property.

### Associations methods

By having a relationship, you get a plethora of methods that allow you
manipulate that relationship. For instance, a post can now access its comments:

    post = Post[1]
    post.comments # Returns an array of Comments

The same way happens for the comments:

    comment = Comment[1]
    comment.post # Returns an instance of Post

Let's now consider the example where you want to actually add a new comment to
a particular post. You have all the data gathered and you know which to post to
attach the comment to. Sequel provides a dynamic method that consists of `add_`
and the associated model. So you get:

    post = Post[1]
    post.add_comment(comment_data)

The same behavior is achieved as when calling the `save` method, except the
association is properly set by adding the reference of the post into the
comment, we don't need to do it ourselves.

Another kind of relationship available in Sequel is the `many_to_many`
relationship. It relies on a third table that holds the primary keys from both
parties of the relationship, which can optionally include its own set of data.
An example of this pattern is a product belonging to many categories at once,
while a category holds many products of its own.

    class Category < Sequel::Model
      many_to_many :products
    end

    class Product < Sequel::Model
      many_to_many :categories
    end

This way you can reach out to a `product` and call the `categories` method on
it and vice-versa; a `category` can be called the `products` method. It assumes
that a `categories_products` table exists to hold the relationship data.

An example of the very common relationship pattern used in ActiveRecord is
`has_many :through`. Sequel has a different way of solving that challenge in a
traditional SQL-like dialect:

    class Doctor < Sequel::Model
      many_to_many :patients, join_table: :appointments
      one_to_many :appointments
    end

    class Patient < Sequel::Model
      many_to_many :doctors, join_table: :appointments
      one_to_many :appointments
    end

    class Appointment < Sequel::Model
      many_to_one :doctor
      many_to_one :patient
    end

Both doctors and patients can view their appointments. In order for the doctor
to know which patient he's going to check, he goes through the appointments via
the `join_table` option and reaches out to the respective patients.

* `doctor.patients` retrieves all patients he's checked;
* `doctor.appointments[index].patient` retrieves a patient for a particular
  appointment.

These are just some of the most used relationship patterns available in Sequel
but you can check the remaining ones in these
[two](http://sequel.jeremyevans.net/rdoc/files/doc/association_basics_rdoc.html)
[locations](http://sequel.jeremyevans.net/rdoc/files/doc/advanced_associations_rdoc.html).

## Other Features

### Transactions

Using transactions in Sequel is very straightforward. Every time you need to
perform non-atomic, interdependent changes to your database, you can wrap your
code under a transaction:

    DB.transaction do
      post = Post.new(post_data)
      post.save

      @comments_data.each do |comment|
        unless post.add_comment(comment)
          raise Sequel::Rollback
        end
      end
    end

You use the global `DB` object to start it and pass the code into a block.

The example tries to show how to store the comments on a valid post. Should the
former be invalid for some reason — maybe the comment body was an empty string
—, you wouldn't want the post to be created in the first place. The transaction
above is meaningful in the way that it prevents the post to be persisted in
case any of the comments fail to persist as well.

One thing to notice in the example is the exception being raised. You could
abstract the details into a separate class and raise the exception there but
we're being explicit. The point of the exception is to demonstrate that if you
raise `Sequel::Rollback` the transaction is rolled back and code execution
proceeds. However, if you raise any other exception, it will be reraised so you
can treat it the way you find most useful in your application.

If you need to look up on transactions further, check the [documentation on
transactions](http://sequel.jeremyevans.net/rdoc/files/doc/transactions_rdoc.html).

### Migrations

Up until here we haven't specified how to actually manipulate the database
schema. Sequel doesn't let you empty handed as it provides a solid migration
mechanism. It's similar to ActiveRecord but with a tiny set of changes.

In order to modify the database schema to embody the example above on doctors
and patients, you would create the following migrations:

    Sequel.migration do
      change do
        create_table :doctors do
          primary_key :id
          String :name
          String :specialty
          Time :created_at
        end

        create_table :patients do
          primary_key :id
          String :name
          Bignum :ss_number
          Time :created_at
        end

        create_join_table(
          doctor_id: :doctors,
          patient_id: :patients
        )
      end
    end

If you want to fully explore Sequel's migration mechanism, you can check [this
part of the
docs](http://sequel.jeremyevans.net/rdoc/files/doc/schema_modification_rdoc.html).
It refers to the many possibilities for data types, options for each property
being created, indexes and much more.

How do you persist the changes into the database? You need to execute the
`sequel` binary and tell it to migrate the changes.

    $ sequel -m db/migrate postgres://tutsplus:password@localhost/my_app_db

Most likely you will want to have a folder filled with migration files, similar
to ActiveRecord. You pass the `-m` option to indicate a migration process, the
folder where the migrations are stored and then the URI pointing to the
database.

## Conclusion

We just unveiled the tip of Sequel's iceberg, as there are so many things yet
to be told about Sequel such as plugins, support for sharding, hooks, testing
integration, security, the `sequel` executable, etc. Sequel's
[documentation](http://sequel.jeremyevans.net/documentation.html) is
brilliantly simple and organized and it should act as constant companion when
using the tool.

In a time where Rails is more modular than ever, object oriented Ruby and test
driven development are more present in the Ruby community, Sequel rises as a
solid candidate for great database-backed applications. ActiveRecord is still
in the spotlight but I believe it's not that distant at the moment.

Do you think that Sequel is a strong competitor to ActiveRecord? Or do you find
Sequel to suit parallel purposes? Do you have experience with both tools and
have an educated opinion? Let us know by hitting a comment below.
