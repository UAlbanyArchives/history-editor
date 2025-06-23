# history-editor
A basic CRUD app for creating and editing UAlbany events

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