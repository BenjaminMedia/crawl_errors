# Crawl errors [![Build Status](https://secure.travis-ci.org/ekampp/crawl_errors.png)](http://travis-ci.org/ekampp/crawl_errors)


This is a simple rack application that crawls through a website on a domain, reporting the links it visits along the way.

You can use this to find different errors (such as 404 and 500) on your site.

## Usage

You run it with this command:

    ./crawl_errors.rb http://example.com/

You can format the domain as you like, adding a port `http://example.com:8080` or a subdomain `http://something.example.com`, but must include the protocol (http://).

If you want the crawler to only repport actual errors (not 200 OK) you should pass the `--report-errors-only` flag when you run the script, like this:

    ./crawl_errors.rb http://example.com --report-errors-only

## Limitations

For now it only performs GET requests, and it doesn't adhere to the rel-nofollow rules. This is something that could be expanded on in later versions.
