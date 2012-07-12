chef-client-mobile
==================

In 3 steps, you'll have chef-client-mobile up and running in your browser from scratch.


Developing
==========

## 1 - [Installing node.js and NPM](http://nodejs.org/#download)

## 2 - Run Stylus/CoffeeScript compilers

    > script/stylus-compiler
    > script/coffee-compiler

This will compile `.styl` *to* `.css` and `.coffee` *to* `.js`.  
File changes will **automatically** be recompiled.

If you encounter SSL problems installing npm modules then tell npm to default to http by setting up a .npmrc:
    > echo "registry = http://registry.npmjs.org/" >> ~/.npmrc

## 3- Run development server

    > script/server

In a browser, visit `http://localhost:3000/index-dev.html`.


Running Tests
=============

## Generate specs

    > make specs

## Run specs (in the browser)

If the server isn't running...

    > script/server

Visit [http://localhost:3000/spec-runner/index.html]


Deploying Checklist
===================

## 1 - Compile Stylus/CoffeeScript

    > script/stylus-compiler
    > script/coffee-compiler

## 2 - Rebuild bootstrap.js and bootstrap.css

    > make clean; make

## 3 - Automated Browser Test

    > make specs

In a browser, go to [http://localhost:3000/spec-runner/](http://localhost:3000/spec-runner/).

## 4 - Manual Browser Test

    > script/server

In a browser, go to [http://localhost:3000](http://localhost:3000) and spotcheck functionality hasn't regressed.


SublimeText Setup
=================

## 1 - Install this TextMate bundle to get CoffeeScript syntax highlighting:

[https://github.com/jashkenas/coffee-script-tmbundle]

Extract it in "~/Library/Application\ Support/Sublime\ Text\ 2/Packages"

## 2 Install the SublimeLinter from package control

This will show CoffeeeScript syntax errors in the editor.  More information is
available at [https://github.com/lunixbochs/sublimelint].

Note: the coffee command needs to be in your path for the the SublimeLinter to
work with CoffeeScript.

Note #2: the jsl command needs to be installed for the SublimeLinter to work
with JavaScript. Install using `brew install jsl`

## 3 Install the Stylus TextMate bundle

    > cp -R node_modules/stylus/editors/Stylus.tmbundle "~/Library/Application\ Support/Sublime\ Text\ 2/Packages"


Development URL Parameters
==========================

### mock-data

Simulates the service, loads mock data from mock-resources.coffee 

## Example
  http://localhost:3000/index-dev.html?mock-data
