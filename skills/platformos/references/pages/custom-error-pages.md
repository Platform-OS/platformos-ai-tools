# Custom Error Pages

Custom error pages allow you to serve branded error responses that match your site's design and provide helpful information to users. These pages can include relevant links, search functionality, or guidance to help visitors navigate when errors occur.

## Supported Error Codes

You can customize error pages for the following HTTP status codes:

- 403 - Forbidden
- 404 - Not Found
- 500 - Server Error
- 503 - Maintenance

## Creating an Error Page

Error pages are standard platformOS pages with all the same features available, including layouts and partials. To create a custom error page, create a page file named with the appropriate status code.

### File Naming Convention

The file name defines the error code: `{status_code}.{format}.liquid`

Example file: `app/views/pages/404.html.liquid`

```yaml
---
layout: error_page
---
The resource you were looking for does not exist.
```

## Error Page Types

### 403 - Forbidden

Triggered when an Authorization Policy is violated. The user does not have permission to access the requested resource.

### 404 - Not Found

Rendered in multiple scenarios, most commonly when attempting to access or modify an object that does not exist. Can also be triggered by setting an Authorization Policy's `http_status` to 404 instead of the default 403.

### 500 - Server Error

Displayed when an unhandled error occurs on the server.

### 503 - Maintenance

Rendered when maintenance mode is enabled through the Partner Portal (configured via the `maintenance_mode` attribute).

## Multiple Formats

Error pages can support different response formats, just like any other page. Create separate files for each format using the appropriate extension.

### HTML Format

File: `app/views/pages/404.html.liquid`

```liquid
---
layout: error_page
---
<h1>Page Not Found</h1>
<p>The page you are looking for does not exist.</p>
<a href="/">Return to Home</a>
```

### JSON Format

File: `app/views/pages/404.json.liquid`

```liquid
---
format: json
---
{% hash_assign error = { "status": 404, "message": "Page not found" } %}
{{ error | json }}
```

### Text Format

File: `app/views/pages/404.txt.liquid`

```text
This text file does not exist. Double-check the URL in the address bar.
```

### XML Format

File: `app/views/pages/404.xml.liquid`

```xml
---
format: xml
---
<?xml version="1.0" encoding="UTF-8"?>
<Error>
  <Message>This file does not exist.</Message>
</Error>
```

## Configuration Notes

Both `slug` and `format` properties can be omitted from the page definition when they are already specified in the file name. For example, `404.json.liquid` automatically sets the slug to `404` and format to `json`. You can still explicitly define these properties if preferred.

## Best Practices

- Keep error page design consistent with your site's branding
- Provide helpful navigation options (home link, search, related content)
- Include relevant contact information for persistent errors
- Test error pages by triggering them intentionally
- Keep error messages informative but avoid exposing sensitive information
