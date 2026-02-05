# Create a page.

## Steps

Creating a page is a four-step process:

### Step 1: Create a directory for pages

Pages should be placed into the `views/pages` directory inside `app`.

If you are starting from scratch (without having created the codebase), navigate to the `views` directory you created for the `layouts` directory inside `app`, then create a directory called `pages` inside `views`.

If you have already created the codebase, you can skip this step, and just locate your `app/views/pages` directory.

### Step 2: Create a page file
In the `pages` directory, create a Liquid file called `index.liquid`.

### Step 3: Edit the Page file

Edit the `index.liquid` page file.

Find a sample page file with explanations below:

##### app/views/pages/index.liquid

```liquid
Homepage
```

Explanation:

* Pages have an optional parameter `slug`, which indicates where the page will be accessible. `/` marks the root page, which is the homepage.
* `---` separate configuration from content.
* `format` is derived from the file name, in this case it is `html`. Since that's the default, the file could be named `index.liquid` as well.

Save your page file.

### Step 4: Deploy and check

Deploy or sync your changes, and check the source code of your homepage. The layout file with the page content injected into it, like this:

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Layout title</title>
  </head>

  <body>
    <h1>Layout</h1>

    Homepage
  </body>
</html>
```
