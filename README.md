# pINT - Presentations INTeractively

### Requirements:
* Ruby 2.2+ 
* Bundler 1.9+
* ImageMagick 6.8+
* PostgreSQL 9.3+

### Setup:
Configure the database access in `db/database.yml`, then run:
```
bundle install
bundle exec rake db:migrate
```

## Usage:
```
bundle exec rails s -b 0.0.0.0
```
Only 4:3 PDF slides are supported and they are converted with ImageMagick to JPEG files for quicker rendering. After a successful upload, the questions can be added by clicking on the **Edit** button in the list of the presentations. Only one question per slide can be added (except for the first slide), minimally with two different choices.

The server should be accessed from an interface IP, not from the loopback address. Otherwise the QR code will be rendered with wrong URL and the browsers would not find the presentation. The presentation mode can be started by clicking on the **Start** button.

The first slide always shows a QR code with a link to the web-based feedback client, this should be scanned by the audience. When moving between slides, both the presenter and the client shows the according question with the possible answers. When a client submits an answer, it's rendered into a *percentage-progressbar* on the presenter side in real time. The slides can be moved backwards, but each client can answer each question only once.

### Disclaimer:
This project was a university homework for the course [Internet Applications](https://www.fit.vutbr.cz/study/course-l.php.en?id=10255) at the [Brno University of Technology](https://www.fit.vutbr.cz/.en) and it's provided as-is with no license at all.

### Authors:
* [Gabriel Lehocký](http://github.com/lgstudio)
* [Dávid Halász](http://github.com/skateman)
