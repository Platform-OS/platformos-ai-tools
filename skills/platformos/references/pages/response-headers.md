# Response Headers

The `response_headers` property allows you to define custom HTTP response headers for a page. Pass a JSON key-value object to specify the headers to be included in the response.

## Configuration

Define `response_headers` as a JSON object in your page configuration:

```yaml
slug: xml-data
response_headers: >
  {
    "Content-Type": "text/xml",
    "Some-Header": "value"
  }
```

## Usage

Custom headers give you full control over the HTTP response. You can override default headers or add additional ones for specific pages.

### Example: XML Response

Return XML content by setting the `Content-Type` header:

```yaml
slug: xml-data
format: html
response_headers: >
  {
    "Content-Type": "text/xml"
  }
```

Even though the file uses HTML format, the response will be served as XML.

### Example: Custom Headers

Add custom headers for client-side processing:

```yaml
slug: api-endpoint
response_headers: >
  {
    "X-Custom-Header": "custom-value",
    "Access-Control-Allow-Origin": "*",
    "Cache-Control": "no-cache"
  }
```

## Liquid Syntax

Liquid syntax is supported within the `response_headers` value, enabling dynamic header generation:

```yaml
slug: dynamic-headers
response_headers: >
  {
    "Content-Type": "{{ context.params.format | default: 'application/json' }}",
    "X-Request-ID": "{{ context.request_id }}"
  }
```

## Restricted Headers

The following headers cannot be overwritten and are managed by the platform:

- `cache-control`
- `etag`
- `set-cookie`
- `x-request-id`
- `x-xss-protection`

Attempts to set these headers will be ignored.
