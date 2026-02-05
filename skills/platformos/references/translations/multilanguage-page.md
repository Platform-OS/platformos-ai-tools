# Multilanguage Pages

Multilanguage support allows you to create pages that display different content based on the selected language. Use translation files and the `t` (translate) filter to serve localized content.

## Defaults

English is the default language. The language can be specified in the URL using the `language` query parameter, for example `/contact?language=de`. The language setting is stored in `context.session` and can be modified with the `language` parameter.

## Translation Files

Translation files are stored in `app/translations` with `.yml` extension. Each file corresponds to a language code (e.g., `en.yml` for English, `pl.yml` for Polish).

### Example Translation Files

**app/translations/en.yml**

```yaml
en:
  general:
    greeting: Hello, World!
```

**app/translations/pl.yml**

```yaml
pl:
  general:
    greeting: Witaj świecie!
```

## Translating Content

Use the `t` filter to translate content based on the current language:

```liquid
---
slug: multilanguage
---
{{ 'general.greeting' | t }}
```

### Output

- `/multilanguage` → `Hello, World!` (default English)
- `/multilanguage?language=pl` → `Witaj świecie!`

## Language Switching

Create language switch functionality by modifying the current URL with the desired language parameter:

```liquid
{% liquid
  assign language_switch_url = context.location.pathname
  assign language_icon = 'language-pl'
  if context.session.language == 'pl'
    assign language_switch_url = language_switch_url | append: '?language=en'
    assign language_icon = 'language-en'
  else
    assign language_switch_url = language_switch_url | append: '?language=pl'
  endif
%}
<a href="{{ language_switch_url }}" aria-label="Change language">
  {% include "svg/icons", icon: language_icon %}
</a>
```

## Arrays in Translations

Translation files support arrays and other JSON-compatible data structures. Use this feature to store localized collections.

### Example

**app/translations/en.yml**

```yaml
en:
  general:
    cars:
      - Ford Mustang
      - Corvette
      - Gran Torino
```

**app/translations/jp.yml**

```yaml
jp:
  general:
    cars:
      - Honda
      - Subaru
      - Lexus
```

### Using Arrays in Templates

```liquid
{% assign cars = 'general.cars' | t | to_hash %}

<ul>
  {% for car in cars %}
    <li>{{ car }}</li>
  {% endfor %}
</ul>
```

### Output

- `/multilanguage?language=en`
  ```html
  <li>Ford Mustang</li>
  <li>Corvette</li>
  <li>Gran Torino</li>
  ```

- `/multilanguage?language=jp`
  ```html
  <li>Honda</li>
  <li>Subaru</li>
  <li>Lexus</li>
  ```

## Parameterization

Use named arguments and the `%{variable}` syntax to translate sentences with dynamic content:

### Translation Files

**app/translations/en.yml**

```yaml
en:
  personal:
    hello: 'Hello %{name}. Take a look at my website: %{url}'
```

**app/translations/pl.yml**

```yaml
pl:
  personal:
    hello: 'Cześć %{name}. Zerknij na moją stronę www: %{url}'
```

### Template Usage

```liquid
{% liquid
  assign my_name = context.params.name | default: "Pawel"
  assign url = context.params.url | default: "https://example.com"
%}

{{ 'personal.hello' | t: name: my_name, url: url }}
```

### Output

- `/multilanguage?language=en&name=John&url=https://documentation.platformos.com`
  ```
  Hello John. Take a look at my website: https://documentation.platformos.com
  ```

- `/multilanguage?language=pl&name=Pawel&url=https://platform-os.com`
  ```
  Cześć Pawel. Zerknij na moją stronę www: https://platform-os.com
  ```

## Pluralization

The `t` filter supports pluralization to handle different grammatical forms for singular and plural quantities. Use the `count` variable to select the appropriate plural form.

### Translation File

```yaml
en:
  about_x_item:
    one: 'One item'
    other: '%{count} items'
```

### Template Usage

```liquid
{{ 'about_x_item' | t: count: 12 }}
{{ 'about_x_item' | t: count: 1 }}
```

### Output

```
12 items
One item
```

## Fallback Behavior

When a translation key is not found for the selected language, the system falls back to the English translation. This ensures that content is always displayed even when translations are incomplete.
