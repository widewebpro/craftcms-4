# Fusion Layer
CraftCMS ^3.5
node v12.20.0
PostgreSQL

#### Setup
Clone this repository and run commands
  ```sh
$ composer install  // to download all CraftCMS vendors and depencies
$ npm install // to download all frontend depencies and modules
$ npm run build // to build complete sources for the project
$ npm run start // to run webpack in development mode 
```

Few notes:
  - `/templates/layout/base-template.twig` - sample file. It's using to create `main.twig` during the build command
  - `/web/compiled` folder for compiled sources. `NOTE!` This folder will be delated and created from scratch during build. Don't put anything there manually
