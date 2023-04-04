# Stashify

Stashify is a common abstraction to interact with several different storage mediums in a uniform way. Provided in this gem is an implementation of the local filesystem, but other gems provide other implementations.

* [Google Cloud Storage](https://github.com/Lambda-Null/stashify-google-cloud-storage)
* [AWS S3](https://github.com/Lambda-Null/stashify-aws-s3)
* [Azure Blob Storage](https://github.com/Lambda-Null/stashify-microsoft-azure-storage-blob)

The uniform nature of these implementations allows results from one be passed to others. This not only affords you flexibility in your implementation and testing, but a simple way of transferring information from one storage provider to another.

## Installation

Add this line to your application's Gemfile:

	gem 'stashify'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install stashify

## Usage

Provided in this gem is an implementation of local storage. Here is an example of how to use that implementation:

	> require "stashify/file/local"
	=> true
	> file = Stashify::File::Local.new(path: "/tmp/foo")
	=> #<Stashify::File::Local:0x000055a2a62f53c0 @contents="", @name="foo", @path="/tmp/foo">
	> file.contents
	=> "1\n"
	> file.delete
	=> true
	> file.write("100")
	=> 3
	> file.contents
	=> "100"
	> file.delete
	=> 1
	> file.exists?
	=> false
	> require "stashify/directory/local"
	> dir = Stashify::Directory::Local.new(path: "/tmp")
	> file2 = dir.find("bar")
	=> #<Stashify::File::Local:0x000055a2a62ff000 @contents="", @name="bar", @path="/tmp/bar">
	> file2.contents
	=> "2\n"
	> dir.exists?(file.name)
	=> false
	> dir.write(Stashify::File.new(name: "foo", contents: "1"))
	> dir.exists?("foo")
	=> true
	> dir.find("foo").contents
	=> "1"
	> dir.exists?("bar")
	=> true
	> dir.delete("bar")
	=> 1
	> dir.exists?("bar")
	=> false
	> subdir = dir.find("foobar")
	=> 
	#<Stashify::Directory::Local:0x000055a2a5ffb660
	...
	> subdir.files.map(&:name)
	=> ["baz"]
	> subfile = subdir.files.first
	=> 
	#<Stashify::File::Local:0x000055a2a62937b0
	...
	> subfile.name
	=> "baz"
	> subfile.contents
	=> "3\n"

To interact with `Stashify::File` implementations is through `exists?`, `contents`, `write` and `delete`. To interact with `Stashify::Directory` implementations, use the methods `exists?`, `find`, `write`, `delete` and `files`. Regardless of the implementation of `Stashify::Directory`, `find` will return and `write` will take implementations of `Stashify::File`.

This consistency allows a lot of portability. For instance, pulling in a couple [other](https://github.com/Lambda-Null/stashify-google-cloud-storage) [gems](https://github.com/Lambda-Null/stashify-aws-s3) allows you to do cool things like this:

	> require "stashify/directory/local"
	=> true
	> dir = Stashify::Directory::Local.new(path: "/tmp/foobar")
	=> 
	#<Stashify::Directory::Local:0x0000564d9e8f9f48
	...
	> dir.files.map(&:name)
	=> ["baz"]
	> require "stashify/directory/google/cloud/storage"
	=> true
	> gdir = Stashify::Directory::Google::Cloud::Storage.new(bucket: bucket, path
	: "")
	=> 
	#<Stashify::Directory::Google::Cloud::Storage:0x0000564d9ee87140
	...
	> gdir.write(dir)
	> gdir.files.map(&:name)
	=> ["foobar"]
	> require "stashify/directory/aws/s3"
	=> true
	> adir = Stashify::Directory::AWS::S3.new(bucket: bucket, path: "")
	=> 
	#<Stashify::Directory::AWS::S3:0x0000564da0851580
	...
	> adir.write(gdir)
	> adir.files.map(&:name)
	=> ["baz"]

As you can see in the above examples, `Stashify::File` and `Stashify::Directory` can be created directly to define in-memory objects. This helps avoid the need to do silly things like write files to disk in order to get them to the desired destination.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/stashify. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/stashify/blob/master/CODE_OF_CONDUCT.md).

If you wish to create an implementation for a new provider, the gem [stashify-contract](https://github.com/Lambda-Null/stashify-contract) provides shared examples which verifies the consistency which maintains portability. To have your gem included in the list above, it must implement these examples in the way documented in that gem.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stashify project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/stashify/blob/master/CODE_OF_CONDUCT.md).
