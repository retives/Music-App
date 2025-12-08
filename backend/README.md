# README

## Getting Started
Clone the repository from GitLab to your local computer with `git clone`.

Open a terminal window.

Use `cd` command to change the directory to that of your cloned directory.

Make sure you have Docker and Docker Compose installed on your machine.

## Credentials

The master key is required for running all kinds of activities within the app. Please contact the backend team for the master key.

## Running the App Infrastructure
#### (Instructions for all the team)

### Run the app
1. Uncomment the line: `# gem 'redis-client', '~> 0.16.0'` in Gemfile
2. Uncomment the line: `# JWTSessions.token_store = :redis` in config/initializers/jwt_sessions.rb

There are two options for running the app:
1. Run the command: `docker compose up`. In this case, you'll need to enter all other commands in a separate terminal window.
2. Run the containers in the detached mode: `docker compose up -d`. In this case, you can use the same terminal window for entering all other commands. Please note that you'll need to stop the containers manually by running the command: `docker compose down`.

A network of four containers will be created: `web`, `postgres`, `redis`, `pgadmin`.

All necessary actions within the container can be performed using the container name (please refer to the docker compose file corresponding to the current environment).

Currently, there is a docker compose file only for the development environment (`docker-compose.yml`).

### Setup the development database

Run the following commands to create the development database:

1. `docker exec epam_music_web_container rails db:create`

2. `docker exec epam_music_web_container rails db:migrate`

Run the following command to populate the database with the mock data:

`docker exec epam_music_web_container rails db:seed`

**NOTE: You can create, migrate, and seed the database all at once:**

`docker exec epam_music_web_container rails db:create db:migrate db:seed`

### Access the App

_Access REST API endpoints:_

**Base URL:** `http://0.0.0.0:3000`

_Access Active Admin dashboard:_

**URL:** `http://0.0.0.0:3000/admin`

Credentials:

- login: `admin@example.com`
- password: `secreT!123`

(Or check out `db/seeds/development/users.seeds.rb`)

_Access pgAdmin dashboard:_

`http://0.0.0.0:5050`

Credentials:

- login: `admin@example.com`
- password: `admin`

### Reset the database

`docker exec epam_music_web_container rails db:reset`

### Generate the REST API documentation

`docker exec epam_music_web_container rails rswag:specs:swaggerize`

## Testing and documentation
#### (Instructions for the backend team)

**NOTE: Currently, the below instructions are not relevant - you can run the tests right within your development network, without the need to create a separate test network of containers.**

A network of three containers is created for the test environment: `web`, `postgres`, `redis`.

Stop the development containers first, then run the test network of containers by running the command:

`docker-compose -f docker-compose-test.yml up`

In another terminal window, run the following commands to create the test database:

1. `docker exec epam_music_web_container_test rails db:create`

2. `docker exec epam_music_web_container_test rails db:migrate`

You do not need to populate the test database with the mock data, as the tests will do it for you.

**Note:** You can also adjust the ports in the `docker-compose-test.yml` file, so that both networks can be up and running simultaneously.

### Run the tests

`docker exec epam_music_web_container_test rspec`

## Front-end Development and Testing Using Swagger

### Review OpenAPI Specification (Swagger)

`http://0.0.0.0:3000/api-docs/index.html`

### Login

Endpoints: `/api/v1/login`, `/api/v1/refresh`

The endpoint accepts parameters: `email` and `password`

The response returns: a set of tokens: `csrf`, `access`, `access_expires_at`, `refresh`, `refresh_expires_at`.

The **access token** must be further sent along with the requests to make authorized calls. The access token is valid for 1 day.

Headers must include `Authorization: Bearer` with access token:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
GET /api/v1/users
```

The **refresh token** should be used for obtaining a new access token after the current one is expired. The refresh token is valid for 1 year.

The refresh request with headers must include X-Refresh-Token header with the refresh token.

```
X-Refresh-Token: eyJhbGciOiJIUzI1NiJ9...
POST /api/v1/refresh
```

-------------------

_To be edited later for the production environment:_

### Seeding the database

Seed data depend on the environment.

Assuming `RAILS_ENV` is not set or is set to `development`:

-- Type `rails db:seed` to populate the database with the mock data.

To populate the database with the initial data for the production environment:

-- Type `RAILS_ENV=production rails db:seed`

### Production environment

For the login, please check out `db/seeds/production/users.seeds.rb`

For the password, please check out `config/credentials.yml.enc`
