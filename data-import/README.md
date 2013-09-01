## README

This application runs using Ruby 2.0.0-p247 and is reliant upon MySQL

The easiest way to get up and running in the author's opinion is to utilize
RVM and Homebrew to install Ruby and MySQL respectively. If you aren't using a
Mac, then you can utilize whatever package manager you choose for whatever
flavor of Linux you're running instead of Homebrew.

RVM installation instructions can be found at: https://rvm.io/rvm/install
Alternatively, just run `\curl -L https://get.rvm.io | bash -s stable --ruby`

Homebrew installation instructions can be found at: http://brew.sh/
Or, just run `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
after installing ruby.
Once Homebrew is installed, you can simply use `brew install mysql` to get the
latest MySQL installation up and running.

After these are installed, feel free to use git to clone the repository.
If you don't have git installed, use a package manager or Homebrew to get it.

After cloning, hop into the home directory (if you're using RVM, you'll be
prompted to trust the .rvmrc file). From there you'll want to do the following:

* Run `bundle install`
* Run `rake db:create db:migrate`
* Run `rake db:create db:migrate RAILS_ENV=test`

That should get you to a point where you can run the tests. If you don't want
to run the tests, feel free to skip ahead.

To run the tests, you should do the following:

* Run `rspec` to run the unit tests
* Run `cucumber features/` to run the acceptance tests

All tests should be green and you should be ready to fire up the server.
To do so, simply run `rails s` and you're good to go!

Visit http://localhost:3000 and you'll be dropped into the importer process
directly.

## The Nitty Gritty

I purposely kept my tests sparse in this project because I feel that tests
should ultimately be testing business logic alone. I shouldn't need to write
tests that test ActiveRecord... ActiveRecord writes tests for ActiveRecord. As
such, I've tested only the parts of the project that are actually business
concerns, which is primarily the TextImporter found in lib/text_importer.rb

There is also a single Cucumber scenario for testing what was asked in the
project description, utilizing the UI to do so. Basically this ensures that
the business requirements are met and are functioning. Nothing else really
needs to be tested at that level.

### TextImporter

I made some decisions from the get go, I tried to make the application flexible
so that even if the formatting of the document was inconsistent (i.e. columns
in different orders, etc.) the results would still be the same. Therein lies
the concept of the key, and using the key to zip together the data from each
row and make a hash from it.

I hemmed and hawed about the TextImporter#create_records method, trying to
decide whether I wanted to extract out the TextImporter#prepare_options
method and do some fancy metaprogramming or not. I decided to do the fancy
metaprogramming because I honestly find metaprogramming to be incredibly fun.
There's an artistry to metaprogramming that I absolutely adore and I felt I
would rather share that enthusiasm over it with you rather than neglecting to
do so. I added comments to that method explaining exactly what is going on as
well, so hopefully, clarity isn't lost.

The other, potentially odd, decision I made was to wrap the entire import
process in one transaction. I made this as a conscious decision because,
if there are failures, I would rather have the entire file be considered
a failure than to have records created, so that when I upload the file again,
I have duplicates. The methods are extracted out in such a way that making it
a per record transaction would be trivial.

One other odd thing about the text importer is the inclusion of the
ActiveRecord::Naming module and the three methods: ::human_attribute_name,
::lookup_ancestors, and #read_attribute_for_validation. These are all
necessary to allow one to include ActiveModel::Errors and have those function
properly. Those were originally going to be used in conjunction with a
method to concatenate errors onto the object to display issues as they arose
with the import process. When I moved everything into a transaction, I needed
to use the error raising versions of ::create! in order to have the transaction
rollback. In doing so, I now found myself relying on the error percolating up
and causing a 500 rather than handling it gracefully. Also, there was no point
in tracking the errors, as the entire process would abort on the first error
regardless. I left these methods in to allow me to revisit the possibility of
spending more time on creating that error tracking if it became a desired
feature in the future.

== In Closing

If you're so inclined, feel free to respond to the pull request and have me
build out more features on this as desired. I really wouldn't mind some small
collaboration and back-and-forth to give you a feel for what it is like to
work with me more directly. I would also appreciate the chance to get to know
what typical code review is like at LivingSocial.

Thanks!
