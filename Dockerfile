### BUILDER #################################

FROM python:3.11-buster as builder

RUN pip install poetry==1.4.2

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

COPY pyproject.toml poetry.lock ./
RUN touch README.md

RUN --mount=type=cache,target=$POETRY_CACHE_DIR poetry install --without dev --no-root


### RUNTIME #################################

FROM python:3.11-slim-buster as runtime

WORKDIR /app

# NodeJS deps
RUN apt-get update && apt-get install -y curl \
  && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y nodejs git  \
  && apt-get clean && apt-get autoremove

# Create dirs
RUN bash -c 'mkdir -p ./{git-roots,/frontend-dist}' 

ENV VIRTUAL_ENV=/app/.venv \
    PATH="/app/.venv/bin:$PATH"

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}

COPY relate ./relate
COPY accounts ./accounts
COPY course ./course
COPY saml-config ./saml-config
COPY contrib ./contrib
COPY locale ./locale
COPY manage.py ./manage.py
COPY local_settings.py ./local_settings.py

# npm run build/dev deps
COPY package.json ./package.json
COPY rollup.config.js ./rollup.config.js

COPY --chmod=0755 start.sh .
CMD [ "./start.sh" ]

