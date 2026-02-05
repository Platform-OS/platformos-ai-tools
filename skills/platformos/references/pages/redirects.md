# Redirects

Redirects allow you to forward one URL to another using HTTP status codes. This is useful for URL restructuring, SEO management, and handling legacy URLs.

## Configuration

Define redirects in the page's front matter using the `redirect_to` and `redirect_code` properties:

```yaml
---
redirect_to: /destination-page
redirect_code: 302
---
```

## Properties

| Property | Description |
|----------|-------------|
| `slug` | Defines the URL at which this page will be accessible. Combined with your site's domain to form the full URL (e.g., `https://example.com/my-page`). |
| `redirect_to` | The endpoint to which users will be redirected. Can be a static path or include dynamic values using Liquid syntax. |
| `redirect_code` | HTTP status code for the redirect. Valid values: `301` (Moved Permanently) or `302` (Found). |

## HTTP Status Codes

### 301 (Moved Permanently)

Use when the redirect is permanent. Search engines will update their index to the new URL.

```yaml
---
redirect_to: /new-location
redirect_code: 301
---
```

### 302 (Found)

Use when the redirect is temporary. Search engines will continue to index the original URL.

```yaml
---
redirect_to: /temporary-page
redirect_code: 302
---
```

## Dynamic Redirects

Liquid syntax is supported in `redirect_to` to create dynamic redirects based on request parameters:

```yaml
---
redirect_to: '/category/cars/{{ context.params.maker }}'
redirect_code: 301
---
```

This example redirects `/cars?maker=honda` to `/category/cars/honda`.

Use this pattern for SEO-friendly URL restructuring or for mapping legacy URL patterns to new routes.

## Use Cases

- URL restructuring during site redesigns
- Moving content to a new location
- Handling legacy URLs after changes
- Redirecting based on query parameters
- SEO optimization with clean URL structures
