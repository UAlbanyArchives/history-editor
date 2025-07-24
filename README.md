# history-editor
A basic CRUD app for creating and editing UAlbany events

## About

History-editor is a basic Rails CRUD (create, read, update, display) app for managing "events" in the [UAlbany history timeline](https://archives.albany.edu/history/). This app is backend-only and indexes to a Solr core. The [UAlbany History app](https://github.com/UAlbanyArchives/history) provides frontend discovery and display for this data.

## Running History-editor

### For development

Run the app:
```
docker compose up
```

Navigate to [http://localhost:3000/history-editor](http://localhost:3000/history-editor)

You should be able to edit code in real time.

### For deployment

Building the `history` image for production:
```
make build
```

Restarting the service:
```
make restart
```

#### For Windows

These commands don't work on Windows. For that you have to use the full build command:
```
$env:DOCKER_BUILDKIT=1; docker build --secret id=master_key,src=config/master.key -t history-editor .
```

Running the image in the background:
```
docker compose -f docker-compose-prod.yml up -d
```
Navigate to [http://localhost:8081/history-editor](http://localhost:8081/history-editor)

To stop:
```
docker-compose down
```

### For a terminal

If you need another terminal:
```
docker exec -it history-editor bash
```

## Gotchas

For Subject thumbnails in the History app frontend to be editable here, after edits are made, the config/subjects.yml has to be manually copied to the History app for changes to take effect.


## Backup

There is an included backup process which dumps the sqlite to a CSV and adds it to the github repo. This uses the backup service in the compose file.

The [history-database](https://github.com/UAlbanyArchives/history-database) repo needs to be cloned next to the history-editor app.

This cron runs the backup.
```
0 2 * * 0 cd /var/www/history-editor && && docker compose run --rm backup
```
