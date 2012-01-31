# Crawl errors [![Build Status](https://secure.travis-ci.org/ekampp/crawl_errors.png)](http://travis-ci.org/ekampp/crawl_errors)


This is a simple rack application that crawls through a website on a domain, reporting the links it visits along the way.

You can use this to find different errors (such as 404 and 500) on your site.

## Setup

Setting up is as simple as cloning the project and then install dependencies:

    git clone git://github.com/BenjaminMedia/crawl_errors.git
    bundle install

And you can go to the usage section.

## Usage

You run it with this command:

    ./crawl_errors.rb http://example.com/

You can format the domain as you like, adding a port `http://example.com:8080` or a subdomain `http://something.example.com`, but must include the protocol (http://).

If you want the crawler to only repport actual errors (not 200 OK) you should pass the `--report-errors-only` flag when you run the script, like this:

    ./crawl_errors.rb http://example.com --report-errors-only

If you need to log the error output of the crawl to the `log.txt` file for later use this can be done with the `--log-errors` flag.

    ./crawl_errors.rb http://example.com --log-errors

## Limitations

For now it only performs GET requests, and it doesn't adhere to the rel-nofollow rules. This is something that could be expanded on in later versions.
