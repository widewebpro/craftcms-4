# Wideweb base project

## Preparing your envieroment 

### Docker

- Docker
- stop mysql if you're using it on local machine
- stop nginx if you're using it on local machine

## Installation

- Create project `composer create-project widewebpro/craftcms <directory> --no-install`
- Go to your new project folder `cd <directory>`
- RUN `docker-compose up`. It's simple docker setup so there is only nginx and mariadb containers will be build and up.
- Using credentials from `docker-compose.yml` - connect to mariadb container and import DB
- RUN `yarn install`
- RUN `yarn run dev`

