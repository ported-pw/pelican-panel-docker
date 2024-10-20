# Pelican panel
Container image for https://pelican.dev/, Copyright © 2024 Pelican. Source code releases built into this Docker image: https://github.com/pelican-dev/panel.

This container is setup for running everything the Pelican panel needs (with an `sqlite3` database).
Other options including enabling Redis etc. are possible (mostly just by changing stuff in the `.env`), but not considered here.

## Building
```
docker build --tag pelican-panel .
```

## Env file
Create an `.env` file somewhere, you can copy the sample.
You should generate your own `APP_KEY` once, you can do this on any machine with:
```
docker run -v ./.env:/var/www/pelican/.env pelican-panel php artisan key:generate --no-interaction
```
(where your `.env` file is in the current working directory).

## Running
```
docker run \
  --name pelican-panel
  -p 8080:80 \
  -v ./.env:/var/www/pelican/.env \
  -v pelican-storage:/var/www/pelican/storage \
  -v pelican-db:/var/www/pelican/database/data \
  pelican-panel
```
This will run the panel, listening on port 8080, mount your `.env` file, and two volumes for the application storage and database each.
It will also perform any necessary database migrations on startup.

## Creating an admin user
The container as it is setup skips the `.env` file entirely, so we need to create a user ourselves.

Enter the container, and create a user:
```
docker exec -it pelican-panel php artisan p:user:make
```
and follow the prompt.

## Go to your panel, and login! :)