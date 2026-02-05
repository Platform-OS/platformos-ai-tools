# Metadata

**Metadata** is a property to store any kind of key-value pairs. A page can be extended using `metadata`, for example:

```yaml
---
metadata:
  title: "This it the title"
  description: "A description"
  tags: ["signup", "choose", "landing"]
---
```

## Displaying metadata on the page

Metadata is available through Liquid as `context.page.metadata`:

```liquid

<h1>{{ page.metadata.title }}</h1>

<section>{{ page.metadata.description }}</section>

<ul>
  {% for tag in page.metadata.tags %}
    <li>{{ tag }}</li>
  {% endfor %}
</ul>

<strong>{{ page.metadata.tags | join: "," }}</strong>

```
## Using Liquid in metadata

Metadata for any object accepts Liquid and evaluates it, for example, for each page or layout render. Itâ€™s lazy evaluation that happens only when you use it.

For example, you can set a default title in the page metadata by assigning variables in a partial and then capturing the variables:

```liquid

slug: my-page
metadata:
  title: >
    {% incude 'my-partial' %}
    {{ ... use variables from my-partial ... }}

```

## Searching for a page using its metadata

You can search for a page using its metadata in GraphQL queries (all support `page` and `per_page` pagination arguments). Here's an example of a GraphQL query with all possible parameters.

```graphql
query find_page(
  $page: Int
  $per_page: Int
  $metadata: String
  $exclude: String
  $has_key: String
  $name: String
  $value: String
) {
  pages: pages(
    page: $page
    per_page: $per_page
    filter: {
      metadata: {
        contains: $metadata,
        has_key: $has_key,
        attribute: {
          key: $name,
          value: $value
        },
        exclude: $exclude
      }
    }
  ) {
    total_entries

    results {
      id
      slug
      metadata
      format
      page_url
      title
      content
    }
  }
}
```

Some examples of using the above query from a Liquid template to find metadata:

### Find pages WITH word `TITLE` somewhere in metadata (in keys or values)

```liquid

{% graphql q = 'find_page', page: 1, per_page: 20, metadata: "TITLE" %}

```

### Find pages WITHOUT word `TITLE` in metadata (in keys or values)

```liquid

{% graphql q = 'find_page', exclude: 'true', metadata: "TITLE" %}

```

### Match pages having top-level key `tags`

```liquid

{% graphql q = 'find_page', has_key: 'tags' %}

```

### Match pages without "tags" key

```liquid

{% graphql q = 'find_page', exclude: 'true', has_key: 'tags' %}

```

### Match pages with key `tags` having (or including) value `bar`

```liquid

{% graphql q = 'find_page', name: 'tags', value: 'bar' %}

```

### Match pages that do not have key `tags` equal (or including) to `bar`

```liquid

{% graphql q = 'find_page', exclude: 'true', name: 'tags', value: 'bar' %}

```

## Related topics
* [Pages](/developer-guide/pages/pages)
