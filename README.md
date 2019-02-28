# README

Droplet is a work-in-progress. More to come in the future!

At this point in time you can expect the following functionality:<br>
* A user is able to create an account and link their existing Reddit account (or create a new one)
* A user is able to log in and log out successfully
* Ability to browse the 100 most popular subreddits at load time and add them to your personalized feed
* Ability to browse the 100 top posts from your personalized feed
* Ability to open any given post from Reddit and view up to the 100 most recent comments

Droplet-api is the backend repo for the Droplet web app. To access the React/Redux frontend, droplet-web, please [click here](https://github.com/btmccollum/droplet-web).

## Quick Start:
1) You'll need to clone both the front and backend repos:
```
git clone git@github.com:btmccollum/droplet-web.git
git clone git@github.com:btmccollum/droplet-api.git
```

2) Navigate into the droplet-api file and run:
```
bundle install
```

3) From the droplet-api file:
```
rake db:migrate
```

4) Start the server for the backend using:
```
thin start --ssl
```

5) Navigate into the droplet-web file and run:
```
npm install
```

6) Start the server for the droplet-web frontend using:
```
npm start
```

7) Enjoy!

NOTES: 
* You may need to manually visit (https://localhost:3000) to provide SSL authorization

* If the frontend is not loaded on port 3001 you will need to adjust the following files to point to the correct page: 
```
config/initializers/cors.rb
controllers/api/v1/users/omnniauth_callbacks_controller.rb
```

## Built With
* Ruby on Rails
## Authors
* Brad McCollum
## License
This project is licensed under the MIT License - see the LICENSE.md file for details
## Acknowledgments
* Flatiron and their help!
* Anyone who has helped inspire and motivate me
