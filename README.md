# mira

Beautiful and complete EPUB server and reader written in Crystal and Vue

## Installation
Run the install script
Binary is located at `/usr/bin/mira`
Config is located at `/etc/mira/config.yml`

Set an environment variable `MIRA_LIBRARY_DIR`, listing where all your books are

## Usage

TODO: Write usage instructions here

## Endpoints
All endpoints with the exception of `/login` and `/register` require an Authorization token, and are within the `/api/v1/auth/` scope, whereas the aforementioned 2 are in the `/api/v1/` scope (meaning you should add that in front of your requests)

### `/scan_library`
Scans the given library directory for EPUB files, in case a new file has been added or there's been a change.

Type: `GET`

Should return:
`Status Code 200`

### `/fetch_library`
Fetches the library files and metadata about them.

Type: `GET`

Should return: `Status Code 200`

- `totalResults`: Int, counts total items in the library.
- `items`: Array, contains all EPUB entry metadata
    - `id`: Int, an incremental identifier of the book
    - `title`: String, the title of the book according to its metadata file
    - `author`: String, the author of the book according to the dc:creator entry in the metadata file
    - `date`: String, a timestamp of when the book was released. (to be deprecated)
    - `cover`: String, directory within the EPUB of the book's cover image
    - `directory`: String, directory of the EPUB file
    
    - `failedParse`: String, in some cases parsing an EPUB may fail, which is when this item is created listing the name of the faulty file in question 

### `/user_info`
[WIP]

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
