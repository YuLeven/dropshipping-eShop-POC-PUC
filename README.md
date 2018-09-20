# Dropshipping e-Shop

Simple proof-of-concept application based on three use cases for a dropshipping-based e-Shop: Registration, authentication and product purchase.

## Running

The application is containerized using Docker. Docker-compose is used to orchestrate the depencies between containers.

**Build the application**

`$ docker-compose build`

**Provision the application database**

`$ docker-compose run maintenance mix do ecto.create, ecto.migrate`

**Run the application**

`$ docker-compose up`

After every service has finished starting, the application will be accessible at http://localhost:3000
