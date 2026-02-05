# Partials

Partials allow you to extract reusable pieces of code, reducing duplication and improving maintainability. By using partials, you can create modular components that can be rendered across multiple pages with consistent behavior.

## Directory Structure

Partials are stored in the `app/views/partials/` directory. The file path corresponds to the partial's name when rendered.

Example directory structure:
```
app/views/partials/contacts/
└── form.liquid
```

## Creating a Partial

Create a `.liquid` file in the `app/views/partials/` directory. The file contains the template code that will be rendered when the partial is called.

Example partial at `app/views/partials/contacts/form.liquid`:

```liquid
<h2>Contact Us</h2>
<form action="/contacts/create" method="post">
  <input type="hidden" name="authenticity_token" value="{{ context.authenticity_token }}"></input>
  <div>
      <label for="email">Email</label>
      <input type="text" name="contact[email]" id="email" value="{{ contact.email }}">
      {% if contact.errors.email != blank %}
        <p>{{ contact.errors.email | join: ', ' }}</p>
      {% endif %}
  </div>
  <div>
    <textarea name="contact[body]">{{ contact.body }}</textarea>
      {% if contact.errors.body != blank %}
        <p>{{ contact.errors.body | join: ', ' }}</p>
      {% endif %}
  </div>
  <input type="submit" value="Send">
</form>
```

## Rendering a Partial

Use the `{% render %}` tag to include a partial within a template. The partial name corresponds to its path relative to `app/views/partials/`.

### Basic Syntax

```liquid
{% render 'partial_name' %}
```

For the example above:
```liquid
{% render 'contacts/form' %}
```

This renders the partial located at `app/views/partials/contacts/form.liquid`.

### Passing Variables to Partials

Partials can accept variables to display dynamic content. Pass variables as comma-separated key-value pairs.

Example:
```liquid
{% render 'contacts/form', contact: contact %}
```

In the partial, the passed variable is accessible as `contact`.

### Rendering with Null Values

When no data is available initially, pass `null` for the variable:

```liquid
{% render 'contacts/form', contact: null %}
```

### Rendering with Default Values

Provide default values by creating an object and passing it to the partial:

```liquid
{% parse_json contact %}
{
  "email": "[email protected]",
  "body": "Write your message here"
}
{% endparse_json %}
{% render 'contacts/form', contact: contact %}
```

## Benefits of Using Partials

- **Code Reusability**: Write code once and reuse it across multiple pages
- **Maintainability**: Changes to a partial are reflected everywhere it is rendered
- **Separation of Concerns**: Decouple presentation logic from business logic
- **Consistency**: Ensure consistent UI elements across the application
- **Flexibility**: Pass different data to the same partial for various use cases

## Example Usage in Pages

Render the same form partial from multiple pages:

```liquid
{# app/views/pages/contacts/create.liquid #}
{% render 'contacts/form', contact: contact %}

{# app/views/pages/contacts/index.html.liquid #}
{% render 'contacts/form', contact: null %}
```
