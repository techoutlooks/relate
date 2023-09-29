

## Docker

Blazing fast build. Inspired by cookbook by [albertazzir](https://medium.com/@albertazzir/blazing-fast-python-docker-builds-with-poetry-a78a66f5aed0)

```shell
docker build . -t relate:v1.0
docker run -d --rm --name relate-lms -p 0.0.0.0:8000:8000 relate:v1.0 \
  && docker logs -f relate-lms 
```

