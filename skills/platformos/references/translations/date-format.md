# Date Format

The `localize` filter (aliased as `l`) renders date and time values in a specified format. This enables consistent date/time formatting across the application and supports localization.

## Usage

```liquid
{{ user.created_at | localize: 'short' }}
```

Output: `11:45`

## Customizing Formats

Predefined formats can be overridden in translation files by defining format keys with strftime directives. Format directives follow standard UNIX date formatting conventions.

### Translation File Configuration

Define custom formats in the appropriate translation file (e.g., `app/translations/en.yml`):

```yaml
en:
  time:
    formats:
      short: '%-H:%M'
```

This configures the `short` format to render time as `11:45`.

## Format Directives

Format directives use strftime syntax. Common directives include:

- `%H` - Hour (24-hour clock)
- `%M` - Minute
- `%d` - Day of month
- `%m` - Month number
- `%Y` - Year
- `%a` - Abbreviated weekday name
- `%A` - Full weekday name
- `%b` - Abbreviated month name
- `%B` - Full month name
- `%Z` - Time zone name

For a complete list of format directives, refer to [strftime documentation](https://devhints.io/strftime).

## Default English Formats

Default formats for the `en` locale:

```yaml
en:
  time:
    formats:
      short: '%-H:%M'
      long: '%a, %m/%d/%Y %H:%M'
      with_time_zone: '%m/%d/%Y %H:%M (%Z)'
      short_with_time_zone: '%-H:%M (%Z)'
      day_and_month: '%b %d'
      day_month_year: '%d-%m-%Y'
  date:
    abbr_months:
      jan: Jan
      feb: Feb
      mar: Mar
      apr: Apr
      may: May
      jun: Jun
      jul: Jul
      aug: Aug
      sep: Sep
      oct: Oct
      nov: Nov
      dec: Dec
    months:
      jan: January
      feb: February
      mar: March
      apr: April
      may: May
      jun: June
      jul: July
      aug: August
      sep: September
      oct: October
      nov: November
      dec: December
    abbr_days:
      sun: Sun
      mon: Mon
      tue: Tue
      wed: Wed
      thu: Thu
      fri: Fri
      sat: Sat
    days:
      sun: Sunday
      mon: Monday
      tue: Tuesday
      wed: Wednesday
      thu: Thursday
      fri: Friday
      sat: Saturday
    yesterday: Yesterday
    formats:
      long: '%B %d, %Y'
      short: '%m/%d/%Y'
      day_and_month: '%b %d'
      day_month_year: '%d-%m-%Y'
      stripe: '%m-%d-%Y'
```

## Translation Scope

The translation scope for format selection depends on the data type passed to the `localize` filter:

- **Time values**: Uses `time.formats`
- **Date values**: Uses `date.formats`

Ensure format definitions are placed in the appropriate scope based on your use case.
