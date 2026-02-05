# Create a layout.

## Steps

Creating a Layout is a three-step process:

### Step 1: Create a directory for layouts
In order to correctly communicate with the platformOS engine and API, your codebase should be organized into a specific directory structure. The root directory of your project should contain the `app` directory, and layouts should be placed into the `views/layouts` directory inside `app`.

If you are starting from scratch (without having created the codebase), create a `views` directory inside `app`, then a `layouts` directory inside `views`.

If you have already installed the codebase, you can skip this step, and just locate your `app/views/layouts` directory.

### Step 2: Create a layout file
In the `layouts` directory, create a Liquid file called `application.liquid`.

### Step 3: Edit the Layout file
Edit the `application.liquid` layout file.

Find a sample layout file with explanations below:

```liquid

<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Page title</title>
</head>

<body>
  <h1>Layout</h1>
  {{ content_for_layout }}
</body>
</html>

```

The special variable `{{ content_for_layout }}` renders the page content at the exact place where it has been included.

Save your layout file.
