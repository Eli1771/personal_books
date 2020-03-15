# PersonalBooks

Welcome to Personal Books! This Sinatra web application allows you to create a virtual library for your personal/office book collection. Add books, rooms, bookcases and books and view your collection through a dynamically generated map of your library. You can log in and out, create multiple libraries with different login credentials and keep your collection secure. You can also update, edit and delete books from your collection with dynamically generated forms.

## Installation

Ensure that Git is installed on your local machine, then into your terminal type:

    $ git clone git@github.com:Eli1771/personal_books.git

And then execute:

    $ bundle

Launch server with:

    $ shotgun

Launch in your browser by going to:

    localhost:9393

## Usage

TODO: Write usage instructions here

Start by creating a user with a unique username and password. Your username should be the name of your organization or library.

Add books by following the prompts on the screen. If you make a mistake, the error message will give you descriptive instructions to correct your entry.

View the map of your library with 'VIEW LIBRARY'

In each view, each colored field is a clickable views

You can delete a book from the individual book views

You can only view, edit and delete books when you are logged into that book's library

## Development

From within the repo, run rake '$ db:console' to experiment

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/'Eli1771'/shelter_pets. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ShelterPets project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/'Eli1771'/shelter_pets/blob/master/CODE_OF_CONDUCT.md).# ShelterPets

Welcome to Shelter Pets! This gem uses www.adoptapet.com to bring you information about local Dogs living in shelters near you. Provide your zip code to the CLI and get a list of the first 10 dogs on the page. From there you can change your location or get additional information on any of the dogs on the list, including ways to contact the shelter if you're interested in adopting someone.
