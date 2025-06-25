# history-editor
A basic CRUD app for creating and editing UAlbany events

## About

History-editor is a basic Rails CRUD (create, read, update, display) app for managing "events" in the [UAlbany history timeline](https://archives.albany.edu/history/). This app is backend-only and indexes to a Solr core. The [UAlbany History app](https://github.com/UAlbanyArchives/history) provides frontend discovery and display for this data.

## Running History-editor

### For development

Run the app:
```
docker-compose -f docker-compose-dev.yml up
```

Navigate to [http://localhost:3000/history-editor](http://localhost:3000/history-editor)

You should be able to edit code in real time.

When you're done:
```
docker-compose down
```

### For deployment

Building the `history-editor` image locally:
```
DOCKER_BUILDKIT=1 docker build --secret id=master_key,src=config/master.key -t history-editor .
```
On Windows:
```
$env:DOCKER_BUILDKIT=1; docker build --secret id=master_key,src=config/master.key -t history-editor .
```

Running the image
```
docker-compose up -d
```
Navigate to [http://localhost:8081/history-editor](http://localhost:8081/history-editor)

&#8594; In production, this should be set up to run as a service.

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
