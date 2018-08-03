# Penca
![Build Status](https://api.travis-ci.org/martindsq/penca.svg?branch=master)

Penca is a rails web application that allows you to run a [soccer/football association pool](https://en.wikipedia.org/wiki/Football_pools) in your office or with friends..

This application uses:

* [Devise](https://github.com/plataformatec/devise) for user management and authentication
* [DeviseInvitable](https://github.com/scambra/devise_invitable) for inviting new users (users cannot signup in the website without being invited previously)
* [Active Admin](https://github.com/activeadmin/activeadmin) for website administration
* [Bootstrap](https://github.com/twbs/bootstrap) for responsive frontend
* [Kaminari](https://github.com/kaminari/kaminari) for pagination
* [dotenv](https://github.com/bkeepers/dotenv) for loading environment variables in development

If you'd like to add features or bug fixes to improve my application, you can fork this Github repository and make pull request. Your contributions are welcome and I will be happy to check them when I have time.

If you just want to run a pool, you will want to clone this repository, customize the application and upload it to Heroku.

## Getting started

The first logical step is to run the application in a local server. Start by cloning the repository:

```
git clone https://github.com/martindsq/penca.git
```

This is a Ruby on Rails application and I assume that you are already familiarized with it. If not, please take time to learn it, there are many resources in the Internet (personally, I started with [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project)).

### Database

If you don't already have PostgreSQL in your system, download and install it from https://www.postgresql.org.

Now, first we need to create the development and tests databases:

```
rails db:create
rails db:schema:load
rails db:migrate
```

If you want to preview how a existent pool looks like, you can use the seeds I prepared for the Russia World Cup 2018, with the following command you can seed the database with all the teams, stadiums, group stages and matches:

```
rails db:seed
```

### Admin and users

Right now, you are ready to run the application, let's run a local server:

```
rails server
```

Open localhost:3000 and localhost:3000/admin in your browser. The first one is the main website, the one the users will use all the time; the second one is the administration website, only admins can use it. Both sites should be loading fine at this point but, wait, we don't have any admin or users yet so you don't have any way to login.

Users can only be created or invited by admins using the administration site (I will get back to this later), so what we need now is to manually create one or more admins. Please, notice that an admin is not a user so it can only login to the administration website. In this example I will create only one, but you can create as many admins as you wish:

```
rails console
> Admin.create({email: 'john.doe@mail.com', password: 'mysuperstrongpassword'})
```

You should be able to sign in to the administration site. There you will find a main menu with the following options: teams, stadiums, stages, games and users. You should see two action buttons named Invite user and New user if you go to the last option in the menu. The first one allows you to invite a user using the email they provided and is the preferred option, the second option allows you to manually create a new user, it is meant to create users when you are not able to invite them with an email. As we haven't yet configured the email service yet, let's start by manually creating a user so you can check the main site first before configuring more advanced options.

You'll need to provide its email address (unique), alias and password. The alias uniqueness is not checked in this option so be careful to avoid creating two users with the same alias as they will have trouble to sign in later (the uniqueness is checked when inviting users though).

Go ahead a create a new user, then you should be able to sign in to the main site. We will cover user invitations in the following section, Email, as we will need to configure the email service first.

### Email

There are many mailing services out there that are easy to integrate with a Rails app, I used [Mandrill](https://www.mandrill.com) in this project. Go ahead and create an account: you will be first channeled through their parent service, MailChimp, and go to Account > Transactional to add Mandrill (these steps could change at any time).

[Enable the test mode](https://mandrill.zendesk.com/hc/en-us/articles/205582447-Does-Mandrill-Have-a-Test-Mode-or-Sandbox-) that allows us to verify that the service is correctly integrated with our project without actually sending emails and [add a new test API key](https://mandrill.zendesk.com/hc/en-us/articles/205582447-Does-Mandrill-Have-a-Test-Mode-or-Sandbox-).

Now, find the following code in `config/environments/development.rb`:

```
config.action_mailer.smtp_settings = {
    address:              'smtp.mandrillapp.com',
    port:                 587,
    domain:               'localhost',
    user_name:            ENV['SMTP_USER_NAME'],
    password:             ENV['SMTP_PASSWORD'],
    authentication:       'plain',
    enable_starttls_auto: true  }
```

The values we need to keep an eye on are domain, user_name and password. You don't need to change the first one (only in production if you decide to publish the site), but you do need to change the other two with the values that Mandrill gives you. I created two environments variables, SMTP_USER_NAME and SMT_PASSWORD because they should ve hidden to the world. This project uses [dotenv](https://github.com/bkeepers/dotenv) to manage environment variables in development with ease, create a file named `.env` in the parent directory with the following code (or just copy a file named `.env.example`):

```
SMTP_USER_NAME="Mandrill User name"
SMTP_PASSWORD="Mandrill API key"
```

Finally, you just need to update the `mailer_sender` value at `config/initializers/devise.rb`, its what will be shown in *from* and *reply-to* values in the invitation emails:

```
config.mailer_sender = "\"John Doe\" <john.doe@mail.com>"
```

And that's it! Go head and invite a new user using the administration site. Remember that the actual email won't be sent as we are using Mandrill's test mode, but you can check it in the *Outbound* section at Mandrill's dashboard (in their website). The invited user will has to follow the link in the email in order to create an account providing an unique alias and password; for the mean time, you can see the invitation email in the administration site right after you invite a new user, use it to check what accepting an invitation looks like.

## Customization

You should have a functional website at this point. Now its time to customize it a little bit.

### Locale and timezone

The project is localized in two languages, English and Spanish (check the folder `config/locale` to edit any value or to localize it in a new language). If you want to force a specific locale or/and timezone (it will use the timezone of the server otherwise) edit the file `app/controllers/application_controller.rb`; the relevant sections are:

```
# Uncomment the following line if you want to set a specific timezone and locale
# before_action :set_locale
```
```
# Set your specific timezone and locale here
def set_locale
  Time.zone = 'America/Montevideo'
  I18n.locale = :es
end
```

### Scoring system

The game awards 10 points for a perfect result (home and away scores) and an additional 5 points for telling the winning team (in the knockout stage, two teams could tie and define the game in penalty shootout, it that case the user is given the option of telling which team will advance to the nexxt stage). The relevant section if you want to change the system is found at `app/models/bet.rb`:

```
def points
  return if !match.ended?
  points = 0
  if home_score == match.home_score && away_score == match.away_score
    points += 10 
  end
  if bet_winning_team == match.match_winning_team
    points += 5 
  end
  points
end
```

## Acknowledgements

Thanks @dcadenas for helping me improve the code and functionality.

## License

Copyright 2018 Martin Dutra

```
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```
