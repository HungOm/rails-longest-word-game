# Recode Rails Javascript and CSS Guidelines

Make sure you are running Rails 6.

For your information, if you are working with Rails 5.1+, you would need to add the `--webpack` flag, like this. Some of the folder structure might also be different.

```bash
rails new APP_NAME --webpack
# If you have, don't run the command again!
```

## Background

This setup will allow you to mix and match the usage of Sprockets and Webpacker. This is to lessen confusion as the Webpack configuration has been changing rapidly for Rails, and many resources available online are for the Sprockets based configuration. With this, CSS/SCSS is loaded via Sprockets (Asset Pipeline) and JS will be loaded through Webpack.

A full configuration where your SCSS and Images being loaded through Webpack **is** possible and even encouraged for a new project in production. There are several advantages of doing it - one namely being able to integrate PostCSS. However, you can transition to this later once you are more familiar with the components of Webpack and how it works.

## Setup

Ensure you have bootstrap and it's dependencies

```bash
yarn add bootstrap
yarn add jquery popper.js
```

Ensure you have the following gems in your Rails `Gemfile`

```ruby
# Gemfile
gem 'autoprefixer-rails'
gem 'font-awesome-sass'
gem 'simple_form'
```

In your terminal, generate SimpleForm Bootstrap config.

```bash
bundle install
rails generate simple_form:install --bootstrap
```

Then replace Rails' stylesheets by Recode's stylesheets.

```
rm -rf app/assets/stylesheets
curl -L https://github.com/MedetaiAkaru/recode-stylesheets/archive/master.zip > stylesheets.zip
unzip stylesheets.zip -d app/assets && rm stylesheets.zip && mv app/assets/recode-stylesheets-master app/assets/stylesheets
```

And the viewport in the layout

```html
<!-- app/views/layouts/application.html.erb -->
<head>
  <!-- Add these line for detecting device width -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

  <!-- [...] -->
</head>
```

## Changes to Webpack Configuration

Make sure you change the webpack config with the following code to include jQuery & Popper in webpack:

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker');

// Bootstrap 4 has a dependency over jQuery & Popper.js:
const webpack = require('webpack');
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
);

module.exports = environment;
```

## Importing Bootstrap via JS
Finally import bootstrap:

```js
// app/javascript/packs/application.js
import 'bootstrap';
```
And add this to `application.html.erb`
```erb
<!-- app/views/layouts/application.html.erb -->

  <!-- [...] -->

  <%= javascript_pack_tag "application" %>    <!-- from app/javascript/packs/application.js -->
</body>
```

## Adding new `.scss` files

Look at your main `application.scss` file to see how SCSS files are imported. There should **not** be a `*= require_tree .` line in the file.

```scss
// app/assets/stylesheets/application.scss

// Graphical variables
@import "config/fonts";
@import "config/colors";
@import "config/bootstrap_variables";

// External libraries
@import "bootstrap/scss/bootstrap"; // from the node_modules
@import "font-awesome-sprockets";
@import "font-awesome";

// Your CSS partials
@import "pages/index";
```

For every folder (**`pages`**), there is one `_index.scss` partial which is responsible for importing all the other partials of its folder.

Let's say you add a new `_contact.scss` file in **`pages`** then modify `pages/_index.scss` as:

```scss
// pages/_index.scss
@import "home";
@import "contact";
```


## Adding new `.js` files

Put the JS file in `/app/javascript/packs`, then add the reference in `application.js`
For example, if the file name is `example.js`, in your `application.js`:

```js
import "./example";
```
