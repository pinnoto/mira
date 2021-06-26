# mira

Beautiful and complete EPUB server and reader written in Crystal and Vue

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Endpoints
All endpoints are in the scope of `/api/v1/` (meaning you should add that in front of your requests)

### `/scan_library`
Scans the given library directory for EPUB files, in case a new file has been added or there's been a change.

Type: `GET`

Should return:
`Status Code 200`

### `/fetch_library`
Fetches the library files and metadata about them.

Type: `GET`

Should return: `Status Code 200`

JSON Response should contain:

- `totalResults`: Int, counts total items in the library.
- `items`: Array, contains all EPUB entry metadata
    - `id`: Int, an incremental identifier of the book
    - `title`: String, the title of the book according to its metadata file
    - `author`: String, the author of the book according to the dc:creator entry in the metadata file
    - `date`: String, a timestamp of when the book was released. (to be deprecated)
    - `cover`: String, directory within the EPUB of the book's cover image
    - `directory`: String, directory of the EPUB file

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

JSON Response should contain:
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
