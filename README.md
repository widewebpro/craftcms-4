# Wideweb base project

# Preparing your envieroment 

### Valet

- PHP 7.2
- MySQl
- Install redis 'brew install redis'
- RUN redis server 'redis-server --daemonize yes'

### Installation

- Create project 'composer create-project widewebpro/craftcms <directory>'
- Create Database in your local server
- Go to your new project folder 'cd <directory>'
- RUN './craft setup' and follow all steps it will suggest (fill all needed data)
- Open '.env' file and fill next data

    _ASSETS_URL=_
    _SITE_URL=_
    _WEB_ROOT_PATH=_ (run pwd command to check it and add /web after )
    
- Go to Admin panel and enable needed plugins
- RUN 'yarn install'
- RUN 'yarn run dev'
