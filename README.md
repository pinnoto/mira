# mira
<img src="https://img.shields.io/github/license/pinnoto/mira"/> <img src="https://img.shields.io/github/last-commit/pinnoto/mira"/> <img src="https://img.shields.io/badge/Crystal-1.3.0-black"/>

EPUB media server written in Crystal

NOTE: Mira is currently in development, and cannot be used in its current state.

## Installation (Backend)
1. Clone the repositry and cd into it `git clone https://github.com/pinnoto/mira && cd mira`
2. Create a PostgreSQL database
3. Set the `MIRA_CONFIG` environment variable to where you want your config file to be: `export MIRA_CONFIG=/etc/mira/config.yml` and configure it
```yml
port: 11880
working_dir: /home/user/mira
library: /home/user/library
covers: /home/user/covers
open_registrations: true
db_name: mira
db_user: mira
db_password: replaceme123
```
4. Build it with release optimizations `crystal build --release ./src/mira.cr`

## Installation (Frontend)
1. Go into the `ui` folder
2. Run `yarn install` and `yarn build`
3. This will create a `dist` folder that contains the built static files, which you can serve using NGINX.

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it (<https://github.com/pinnoto/mira/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Troplo](https://github.com/Troplo) - creator and maintainer
- [straw](https://github.com/acoolstraw) - creator and maintainer
- [Giorgi Kavrelishvili](https://github.com/grkek) - creator of Grip Framework, helped immensely with this project, and is a very kind person
