# Injecting Dynamic Content into Layouts

The `content_for` and `yield` tags enable injecting dynamic content from pages into layouts. This pattern is commonly used for setting page metadata, loading per-page JavaScript or stylesheets, and customizing layout elements on a per-page basis.

## yield

The `yield` tag in a layout defines a placeholder where dynamic content can be injected. It waits for content to be provided by the corresponding page.

### Syntax

```liquid
{% yield 'name' %}
```

The `name` parameter is an identifier that links the yield placeholder to its corresponding `content_for` block.

### Example

Place a `yield` tag in your layout file:

```liquid
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>{% yield 'meta_title' %}</title>
  </head>

  <body>
    <h1>Layout</h1>
    {{ content_for_layout }}
  </body>
</html>
```

## content_for

The `content_for` tag in a page provides content that will be rendered at the matching `yield` location in the layout.

### Syntax

```liquid
{% content_for 'name' %}
  Content here
{% endcontent_for %}
```

The `name` parameter must match a `yield` tag in the layout. The placement of `content_for` within the page does not affect where the content is rendered—it always renders at the corresponding `yield` location in the layout.

### Example

Provide content for the yield in your page:

```liquid
{% content_for 'meta_title' %}Homepage title{% endcontent_for %}
Homepage
```

When the page is rendered, "Homepage title" is injected into the layout at the `{% yield 'meta_title' %}` placeholder.

## Use Cases

### Page Metadata

Set page-specific metadata such as titles, descriptions, or keywords:

```liquid
{# In layout #}
<title>{% yield 'page_title' %}</title>
<meta name="description" content="{% yield 'page_description' %}">

{# In page #}
{% content_for 'page_title' %}Contact Us{% endcontent_for %}
{% content_for 'page_description' %}Get in touch with our team{% endcontent_for %}
```

### Per-Page Stylesheets

Load stylesheets specific to individual pages:

```liquid
{# In layout #}
<head>
  {% yield 'page_stylesheets' %}
</head>

{# In page #}
{% content_for 'page_stylesheets' %}
  <link rel="stylesheet" href="/assets/contact.css">
{% endcontent_for %}
```

### Per-Page JavaScript

Include JavaScript files or scripts for specific pages:

```liquid
{# In layout #}
{% yield 'page_scripts' %}

{# In page #}
{% content_for 'page_scripts' %}
  <script src="/assets/form-validator.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      // page-specific logic
    });
  </script>
{% endcontent_for %}
```

## Multiple Content Blocks

You can define multiple `yield` and `content_for` pairs in the same layout and page:

```liquid
{# Layout #}
<title>{% yield 'title' %}</title>
{% yield 'head_content' %}
{% yield 'body_scripts' %}

{# Page #}
{% content_for 'title' %}Products Page{% endcontent_for %}
{% content_for 'head_content' %}
  <meta name="robots" content="index, follow">
{% endcontent_for %}
{% content_for 'body_scripts' %}
  <script src="/assets/product-filter.js"></script>
{% endcontent_for %}
```

## Fallback Content

If no `content_for` is provided for a given yield, nothing is rendered at that location. To provide fallback content, use Liquid's default handling:

```liquid
{# In layout #}
<title>{% yield 'title' %}Default Site Title{% endyield %}</title>
```

This renders "Default Site Title" if no content is provided by the page.
