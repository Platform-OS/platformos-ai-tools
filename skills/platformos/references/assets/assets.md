# Assets

Assets are files that can be served by an HTTP web server without any backend or server processing. They include JavaScript files, stylesheets (CSS), images, documents (PDF, DOC), fonts, or media (audio, video) files.

## Directory Structure

### Main Application Assets

Assets for the main application are stored in the `app/assets` directory.

### Module Assets

Assets within a module are stored in `modules/[my_module]/public/assets`.

### Organization

While assets can be placed directly in the `assets` directory, it is recommended to organize them into subdirectories based on file type:

```
app/assets/
├── images/
├── scripts/
├── styles/
└── fonts/
```

This structure matches the default layout created by the `pos-cli init` command.

## Content Delivery Network (CDN)

Assets are automatically uploaded to a Content Delivery Network (CDN) during deployment. The directory structure on the CDN mirrors your codebase structure, starting from the `assets` directory.

### CDN URL Format

The CDN URL format includes the CDN host, instance ID, and the asset path:

```
https://[cdn-host]/instances/[instance-id]/assets/[path-to-asset]?updated=[timestamp]
```

### Example

File location in codebase:
`app/assets/images/svg/logo.svg`

CDN URL:
`https://uploads.prod01.oregon.platform-os.com/instances/1/assets/images/svg/logo.svg?updated=1586975239`

Non-CDN URL (via vanity domain, slower):
`https://documentation.platformos.com/assets/images/svg/logo.svg`

The CDN host and Instance ID are specific to your instance and region.

## Browser Cache Busting

When using the `asset_url` or `asset_path` filters, asset URLs are suffixed with an `updated` parameter containing an epoch timestamp (`?updated=1586975239`). This timestamp indicates when the file was last updated and forces browsers to fetch the newer version from the CDN instead of using a locally cached version.

The `updated` parameter is only added for files that exist, as the server must know the last update time.

## Accessing Assets

### Relative Paths (CSS)

Use relative paths in CSS files to reference other assets within the `assets` directory:

```css
background: transparent url('../images/logo.svg') top center no-repeat;
```

This approach is commonly used in CSS for referencing fonts, images, and other stylesheets.

### asset_url Filter

The `asset_url` filter returns an absolute URL to the CDN with the `updated` parameter:

```liquid
<script src="{{ 'scripts/app.js' | asset_url }}"></script>
```

Output for existing file:
`https://uploads.staging.oregon.platform-os.com/instances/335/assets/scripts/app.js?updated=1586946301`

Output for non-existent file:
`https://uploads.staging.oregon.platform-os.com/instances/335/assets/scripts/app.js`

**Important**: Do not use a leading `/` in the path when using `asset_url`.

### asset_path Filter

The `asset_path` filter returns a relative path to the instance domain without the CDN, with the `updated` parameter:

```liquid
<script src="{{ 'scripts/app.js' | asset_path }}"></script>
```

Output for existing file:
`/assets/scripts/app.js?updated=1586946301`

Output for non-existent file:
`/assets/scripts/app.js`

Using `asset_path` bypasses the CDN and may result in slower performance. The `asset_url` filter is recommended for optimal performance.

**Important**: Do not use a leading `/` in the path when using `asset_path`.

## Accessing Module Assets

Assets in modules are namespaced to prevent conflicts. Access them by prefixing the path with `modules/[my_module]`. The path depends only on the asset file location, not on where the referencing code is located.

### Example

File location: `modules/[my_module]/public/assets/js/app.js`

Access via `asset_url`:
```liquid
{{ 'modules/[my_module]/js/app.js' | asset_url }}
```

Access via `asset_path`:
```liquid
{{ 'modules/[my_module]/js/app.js' | asset_path }}
```

## Deleting Assets

Unlike pages, partials, and layouts, assets are **not** automatically deleted during deployment. To physically remove an asset from storage, use the `admin_asset_delete` GraphQL mutation. This operation cannot be undone.
