# mira
<img src="https://img.shields.io/github/license/pinnoto/mira"/> <img src="https://img.shields.io/github/last-commit/pinnoto/mira"/>

Beautiful and complete EPUB server and reader written in Crystal and Vue

## Installation (Backend)
1. Clone the repositry
2. Run `install.sh`
3. Binary is located at `/usr/bin/mira`
4. Config is located at `/etc/mira/config.yml`, take a look at it and configure to your liking
5. Set an environment variable `MIRA_LIBRARY_DIR`, stating where all your books are
6. Set up NGINX to serve the static files and reverse proxy the service and optionally create a systemd service file

## Installation (Frontend)
NOTE: The frontend is not in a finished state, it's still in heavy development.
1. Go into the `ui` folder
2. Run `yarn install` and `yarn build`
3. This will create a `dist` folder that contains the built static files, which you can serve using NGINX.

## Usage

TODO: Write usage instructions here

## Endpoints
All endpoints are within the `/api/v1/` scope (meaning you have to add that in front of your requests

### `/scan_library`
Scans the given library directory for EPUB files, in case a new file has been added or there's been a change.

Type: `GET`

Should return:
`Status Code 200`

### `/fetch_library`
Fetches the library files and metadata about them.

Type: `GET`

Should return: `Status Code 200`

- `totalResults`: Int - counts total items in the library.
- `items`: Array - contains all EPUB entry metadata
    - `id`: Int - an incremental identifier of the book
    - `title`: String - the title of the book according to its metadata file
    - `author`: String - the author of the book according to the dc:creator entry in the metadata file
    - `authors`: Array - an array containing all the authors of the book according to the dc:creator entry in the metadata file (if there's more than 1 author)
        - `author`: String - an author
    - `date`: String - a timestamp of when the book was released.
    - `cover`: String - directory of the cover image within the /api/v1/static/cover scope
    - `directory`: String - directory of the EPUB file within the /api/v1/static/ scope
    
    - `failedParse`: String - in some cases parsing an EPUB may fail, which is when this item is created listing the name of the faulty file in question 

### `/get_user_info`
Receives username, and other user information for logged in user (via JWT).

Type: `GET`

Should return: `Status Code 200`

- `username`: String, the username of the logged in user

### `/register`
Registers a user through the API

Type: `POST`

Should return: `Status Code 200`

JSON Response should contain:
- `token`: String, a JWT token signed by the server

### `/login`
Receives JWT for authentication

Type: `POST`

Should return: `Status Code 200`

- `token`: String, a JWT token signed by the server

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
