# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Event.create({
  title: 'Small business hackathon',
  starts_at: Time.zone.parse('2017-03-04'),
  ends_at: Time.zone.parse('2017-03-05'),
  url: 'http://www.smallbizhack.com/',
  description: 'Hack to create new innovations that help small businesses save time so they can get back to their passions',
})

Event.create({
  title: 'Forward JS',
  starts_at: Time.zone.parse('2017-03-01'),
  ends_at: Time.zone.parse('2017-03-01'),
  url: 'https://forwardjs.com/',
  description: 'Illuminating lectures, & enlightening workshops',
})

Event.create({
  title: 'Render',
  starts_at: Time.zone.parse('2017-03-30'),
  ends_at: Time.zone.parse('2017-03-31'),
  url: 'http://2017.render-conf.com/',
  description: 'A 2-day conference for front-end developers',
})
