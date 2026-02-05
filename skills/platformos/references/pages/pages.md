# Pages

**Pages** are the most essential components of our platform, that define content displayed at a given path. All pages have to be located in the `views/pages` directory. Each page is represented by a single file with `liquid` extension.

Each page is accessible on the URL indicated by its location in the codebase if not otherwise specified in the page configuration `slug` property. For example, the page `app/views/pages/get-started/hello-world.html.liquid` deployed to the domain `https://example.com` will be automatically accessible at `https://example.com/get-started/hello-world`.

**Note**

In examples, we often add the `slug` property to show where the page will be accessible, even if it would not be required because it is the same as the default.

Named parameters
----------------

You are able to use named parameters in the slug. For example, a slug `projects/:id` will resolve URL like https://example.com/projects/1 and you will be able to access the named parameter using `context.params`. In this example, `context.params.id` will return `1`.

For optional parameters, use `(/:optional)` syntax. For example, `/search(/:country)(/:city)` will resolve all three types of URLs: `/search` (`context.params.country` and `context.params.city` will be nulls), `/search/Poland` (`context.params.country` will be `Poland`) and `/search/Poland/Warsaw` (`context.params.country` will be `Poland` and `context.params.city` will be `Warsaw`).

You can match any remaining part of the slug with wildcard `*` - for example, a slug `search/*category` will resolve all URLs that start with search and the remaining part will be available via `context.params.category` - for example, for `/search/my/nested/category` the value of `context.params.category` will be `my/nested/category`. It will however not resolve `/search` without any parameter. To make the category optional in this example, wrap the wildcard in the brackets - `search(/*category)`.

For backwards compatibility, named parameters will be also available at corresponding `slug` name.

Page configuration
------------------

All page configuration is optional, but you can use page configuration to overwrite defaults.

A sample page configuration file:

##### app/views/pages/my-page.md.liquid

```
---
layout: my_custom_layout
converter: markdown
---

```


```
# Welcome to My Page

A paragraph explaining what I do.

```


Explanation:

*   `layout: my_custom_layout`: The page uses the layout `views/layouts/my_custom_layout.liquid`.
*   `converter: markdown`: It converts markdown in the body of the page to HTML.

Available properties

| Property | Description | Options | Default | Required |
|----------|-------------|---------|---------|----------|
| authorization_policies | Array of authorization policies run before rendering the page | converter: markdown | | No |
| layout | Defines which layout from views/layouts/ you would like to use for pages with html format. If you don't want to use any layout, set it to an empty string. | application | | No |
| max_deep_level | Defines the intended nesting level of the slug. Useful for SEO to avoid duplicated content. | positive integer | 3 | No |
| metadata | Object that you can define and access via context.page.metadata in different places | | | No |
| method | HTTP method the page responds to | get, post, put, delete | get | No |
| redirect_code | Status that should be added to http response | 301, 302 | 302 | No |
| redirect_to | URL to a page you want to redirect | | | No |
| response_headers | JSON object that you can define to override most of the http headers | | | No |
| slug | Use to overwrite the default slug (created based on location in codebase). | | | No |


Everything after the front matter is the body of the page.

Homepage
--------

The Homepage slug is `/`, which will work for both https://example.com and https://example.com/. The slug of the file `app/views/pages/index.liquid` defaults to `/`. This sample file configures the home page:

##### app/views/pages/index.liquid

```
<h1>Welcome to my home page</h1>
<p>A paragraph explaining what we do</p>

```


Subdomains
----------

You can add subdomains in the header of a page like this:

```
---
layout_name: 1col
format: html
slug: mypage
layout_name: ''
subdomain: subdomain1
---
<h1>Page with domain</h1>

```


The page will match the current request and will be displayed only if the specified subdomain matches the subdomain of the request. You can specify any number of subdomain parts and the system will attempt to match the subdomains of the request from left to right.

This means `subdomain: subdomain1.example2.example3` will match a request coming in for the domain `subdomain1.example2.example3.site.com`. `subdomain: site` will match a request coming in for the domain `site.com`.

Formats
-------

To define which format the endpoint will be available for, place `.<format>` before the file extension.


|Format name|Example filename          |
|-----------|--------------------------|
|html       |about-us.html.liquid      |
|xml        |orders.xml.liquid         |
|csv        |users-report.csv.liquid   |
|json       |coordinates.json.liquid   |
|rss        |feed.rss.liquid           |
|css        |datepicker.css.liquid     |
|js         |server-constants.js.liquid|
|txt        |notes.txt.liquid          |
|ics        |calendar.ics.liquid       |


Accessing different formats
---------------------------

You can have multiple pages with the same slug, but with different formats, and access them at the same time.

For example, you can have both `html`, `csv` and `txt` version of a page with `Hello world`:

##### app/views/pages/hello.html.liquid

Will be accessible under URL: `https://example.com/hello`

```
Hello world

```


##### app/views/pages/hello.csv.liquid

Will be accessible under the URL: `https://example.com/hello.csv`

```
Hello world

```


##### app/views/pages/hello.txt.liquid

Will be accessible under the URL: `https://example.com/hello.txt`

```
Hello world

```


Note that the `html` format is implicit, default, you don't need to specify it in the URL or the file name.

Method
------

To define to which method the endpoint will respond, define `method` in the Page configuration. One page can respond to exactly one method.

### POST/PUT/PATCH/DELETE methods and Cross-Site Request Forgery attacks

Cross-Site Request Forgery allows an attacker to trick users into executing an endpoint without them knowing. We prevent Cross-Site Request Forgery (CSRF) attacks by requiring a CSRF Token to be provided for every request to a Page which is not GET. If the token is missing, then `context.current_user` would appear as null, because the user session will be invalidated. To be able to access `context.current_user`, you need to provide a valid CSRF Token. For Forms we handle it automatically by adding a hidden parameter with the name `authenticity_token`. However, if you manually trigger a POST/PUT/PATCH/DELETE AJAX request, you need to remember about populating `X-CSRF-Token` header with value from `context.authenticity_token` and also specify `X-Requested-With: XMLHttpRequest` header. Common practice is to include a `meta` tag in the layout, for example `<meta content="y5PnjysJOjcQPOL0VWMfNmghZca4oJWmFfp6ETbSlXdIl-QwZEv07XnZBRVz8att3iHs3TGROemmZSGNkoyWdw" name="csrf-token">` and use this value to execute AJAX request.

If you are building a JSON API, for example for a mobile app, you might want to authenticate users using JSON Web Token (JWT).
