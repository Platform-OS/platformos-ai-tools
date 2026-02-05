# Reusing Code Across Multiple Pages

Partials allow you to extract reusable code into separate files, following the DRY (Don't Repeat Yourself) principle. This improves code maintainability by eliminating duplication and ensuring consistency across multiple pages.

## Partials

Partials are template files stored in the `app/views/partials` directory that contain reusable code snippets. Any code that appears in multiple locations—such as meta tags, navigation elements, or common form components—can be extracted into a partial.

### Benefits

- **Reduced duplication**: Write code once and reuse it across multiple pages
- **Improved maintainability**: Changes to a partial are reflected everywhere it is included
- **Better organization**: Separates concerns by isolating reusable components
- **Consistency**: Ensures identical code execution wherever the partial is used

## Creating a Partial

Create a `.liquid` file in the `app/views/partials` directory with the code you want to reuse.

### Directory Structure

Partials are resolved relative to the `app/views/partials` directory:

```
app/views/partials/
├── meta_tags.liquid
├── navigation.liquid
└── footer.liquid
```

### Example: Meta Tags Partial

Extract meta tags from a layout into `app/views/partials/meta_tags.liquid`:

```html
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
```

## Including a Partial

Use the `{% include %}` tag to render a partial within a template. Specify only the partial's filename (without the directory path or `.liquid` extension).

### Syntax

```liquid
{% include 'partial_name' %}
```

### Example

In a layout file at `app/views/layouts/application.liquid`:

```liquid
<!doctype html>
<html lang="en">
  <head>
    {% include 'meta_tags' %}
    <title>My Application</title>
  </head>
  <body>
    <h1>Layout</h1>
    {{ content_for_layout }}
  </body>
</html>
```

The `{% include 'meta_tags' %}` tag renders the contents of `app/views/partials/meta_tags.liquid` at that location.

## Use Cases

### Page Meta Tags

Extract common meta tags used across multiple layouts:

```liquid
{# app/views/partials/meta_tags.liquid #}
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="description" content="{{ context.page.metadata.description }}">
```

### Navigation Components

Create reusable navigation menus:

```liquid
{# app/views/partials/navigation.liquid #}
<nav>
  <a href="/">Home</a>
  <a href="/about">About</a>
  <a href="/contact">Contact</a>
</nav>
```

### Form Elements

Extract form inputs or complete forms:

```liquid
{# app/views/partials/search_form.liquid #}
<form action="/search" method="get">
  <input type="text" name="query" placeholder="Search...">
  <button type="submit">Search</button>
</form>
```

### Stylesheets and Scripts

Include page-specific or shared assets:

```liquid
{# app/views/partials/page_stylesheets.liquid #}
<link rel="stylesheet" href="/assets/main.css">
<link rel="stylesheet" href="/assets/styles.css">
```

## Combining with yield and content_for

Partials can contain `{% yield %}` and `{% content_for %}` tags for dynamic content injection:

```liquid
{# app/views/partials/head.liquid #}
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{% yield 'page_title' %}Default Title{% endyield %}</title>
  {% yield 'page_stylesheets' %}
  <link rel="stylesheet" href="/assets/main.css">
</head>
```

Include the partial in a layout:

```liquid
{% include 'head' %}
```

Provide content from pages:

```liquid
{% content_for 'page_title' %}Products{% endcontent_for %}
{% content_for 'page_stylesheets' %}
  <link rel="stylesheet" href="/assets/products.css">
{% endcontent_for %}
```

## Best Practices

- Name partials descriptively to reflect their purpose (e.g., `meta_tags.liquid` rather than `header1.liquid`)
- Keep partials focused on a single responsibility
- Use subdirectories to organize related partials (e.g., `app/views/partials/forms/`)
- Avoid circular dependencies between partials
- Test partials independently to verify their behavior
