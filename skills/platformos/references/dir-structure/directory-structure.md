## Required directory structure

In order to correctly communicate with the platformOS engine and API, your codebase should be organized into a specific directory structure. The root directory of your project should contain the app directory.

### Recommended directories and files inside the `app` and `modules/<module name>` directories

| Directory/file          | File type   | Explanation                                                                                                                                                                                                                                                                                                                       | Learn more                                                                              |
|------------------------ |-----------  |---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  |---------------------------------------------------------------------------------------- |
| .pos                    |             | Configuration file that specifies available endpoints. Usually, you want to have at least two endpoints &ndash; staging and production.                                                                                                                                                                                                   | [Development Workflow](/developer-guide/platformos-workflow/development-workflow)  |
| assets                  | asset       | Directory for static assets, like fonts, images, stylesheets, and scripts.                                                                                                                                                                                    | [Assets](#assets)                                                       |
| authorization_policies  | Liquid      | Directory for .liquid files that contains Authorization Policy configuration files. Authorization Policies define rules that control whether a user has access to a form or page.                                                                                                                                                 | [Authorization Policies](#authorization-policies)           |
| migrations              | Liquid      | Directory for migration files.                                                                                                                                                 | [Migrations](#migrations)           |
| schema      | YAML        | Directory for .yml files that define Tables. Tables define custom objects, including their fields and associations and allow you to create persistence containers for your custom forms.                                                                                                                  | [Records](#records)                   |
| emails     | Liquid      | Directory for .liquid files that define Email notifications. | [Notifications](/developer-guide/notifications/notifications)                               |
| api_calls     | Liquid      | Directory for .liquid files that define API calls notifications. | [Notifications](/developer-guide/notifications/notifications)                               |
| smses     | Liquid      | Directory for .liquid files that define SMS notifications. | [Notifications](/developer-guide/notifications/notifications)                               |
| graphql           | GraphQL     | Directory for .graphql files, each defining one GraphQL Query. GraphQL queries retrieve information from or insert information into the databases. Retrieved information is made available in Liquid.                                                                                                                                               | [GraphQL](https://graphql.org/learn/)                                                   |
| views/pages             | Liquid      | Directory for files that define pages, the most essential building blocks of a platformOS site.                                                                                   | [Views](#views-pages-layouts-and-partials)                                                          |
| views/layouts           | Liquid      | Directory for layouts. Layouts are wrappers around your page content. They ensure consistent outer content for similarly designed pages.                                                                                                                                                                                          | [Views](#views-pages-layouts-and-partials)                                                      |
| views/partials          | Liquid      | Directory for partials  &ndash;  reusable snippets of Liquid code usually used to render HTML.                                                                                                                                                                                                                                    | [Views](#views-pages-layouts-and-partials)                                                                                        |
| lib             | Liquid      | Directory for liquid files that implement business logic, and usually are meant to be invoked via [function](/api-reference/liquid/platformos-tags#function) tag                                                                                   | [Lib](#lib)                                                          |
| translations            | YAML        | Directory for .yml files of Translations for multilingual sites, also used to define date format, or flash messages. Each file is a map of translations which can be used in your pages via Liquid.                                                                                                                               | [Translations](#translations)                                     |
| user_profile_types      | YAML        | Directory for .yml files that define User Profiles. Each instance includes one user role, called â€˜defaultâ€™, so each instance needs to include the default.yml file inside this directory.                                                                                                                                         | [Users](#users)                                                         |
| user.yml      | YAML        | A yml file containing properties for all users  | [Users](#users)                                                         |
| config.yml      | YAML        | A yml file containing configuration flags for backwards incompatible changes  | [Config](/developer-guide/platformos-workflow/directory-structure/config)                                                         |

## Files in your codebase

### Views: pages, layouts, and partials

Views are divided into three categories in your codebase, each with a mandatory subdirectory: layouts, pages, and partials.

**Pages** are the most essential building blocks of a platformOS site, that define content displayed at a given path. Each page is represented by a single file with a .liquid extension.

platformOS allows Liquid pages to be used to create many different types of endpoints beyond HTML, such as JavaScript, JSON, PDF, RSS, XML, etc. The page type can be specified in the page configuration.

**Layouts** are Liquid views that store code that would normally repeat on a lot of pages and is surrounding page content (e.g. header, footer). Without layouts, pages would share a lot of duplicated code, and changing anything would become a very time consuming and error prone process. You can create as many layouts as you need, and decide which page uses which layout.

**Partials** (partial templates) allow you to easily organize and reuse your code by extracting pieces of code to their own files. They help you improve code readability and follow the principle of DRY (Donâ€™t Repeat Yourself). You can parameterize partials and use them in various places, e.g. layouts, pages.

Example directory structure of `views` with sample files:


```
app
└── views
    ├── layouts
    │   └── 1col.html.liquid
    ├── pages
    │   ├── index.html.liquid
    │   └── unauthorized.html.liquid
    └── partials
        └── layout
            ├── constants.liquid
            ├── foot.liquid
            ├── footer.liquid
            ├── head.liquid
            └── header.liquid
```

### Lib

Lib directory is meant to help you organize your code by allowing you to place partials not only in `views/partials/`, but also in `lib/`. Both `render` and [function](/api-reference/liquid/platformos-tags#function) tags invoke partial, however semantically they are different. The first one usually is used for presentation layer and include for example HTML, wheras the second one is meant to invoke business logic and return a valule. To not have to mix files for presentation with business logic, we've created a dedicated directory `lib`.

Example directory structure of `lib` with sample files:


```
app
└── lib
    └── commands
        ├── order
        │   ├── create
        │   │   ├── build.liquid
        │   │   ├── check.liquid
        │   │   └── execute.liquid
        │   └── cancel
        │       ├── build.liquid
        │       ├── check.liquid
        │       └── execute.liquid
        └── item
            └── create
                ├── build.liquid
                ├── check.liquid
                └── execute.liquid
```

### Assets

**Assets** are files that can be served by an HTTP web server without any backend/server processing. They are usually Javascript files, stylesheets (CSS), documents (HTML, pdf, doc), fonts, or media (audio, video) files.

Although only the assets directory is required and you can put your assets there, we recommend you further organize your assets into subdirectories inside the assets directory, e.g. `images`, `scripts` for Javascript files, `styles` for CSS files, etc. This is also how the `pos-cli init` command will create the codebase.

Example directory structure of `assets` with sample files:

```
app
└── assets
    ├── fonts
    ├── images
    │   ├── favicon.ico
    ├── scripts
    │   ├── app.js
    │   ├── vendor.js
    └── styles
        ├── app.css
        └── vendor.css
```

### Migrations

**Migrations** are liquid files, that are guaranteed to be invoked only once per environment during `deploy`. The file name must follow the pattern `<timestamp>_<name>.liquid`. The timestamp is used for uniqueness and also to know in which order migrations should be executed (which might be important).

To generate a migration with the current timestamp, you can use the following command: `pos-cli migrations generate <env> <name>`

Migrations are useful if you are making changes to schema in a project with existing data and need to slightly modify them, for example initiate the value.

Example directory structure of `migrations` with sample files:

```
app
└── migrations
    ├── 20200811133711_set_superadmins.liquid
    └── 20210114080833_set_defaults_for_country.liquid
```

### Users

**Users** are accounts that any of your users can have. Users are identified by their unique email addresses. You can define  properties for all users in the user.yml file.

**User Profiles**: This feature is deprecated. We advise to create a table called `profile` with the `user_id` property.

Example directory structure:

```
app
├── user.yml
```
### Records

**Table** is an object that describes all Record objects that belong to it. Think of Tables as a custom database table, which allows you to build highly customized features. Use them to group Properties, and allow the user to provide multiple values for each of them.

**Properties** are fields that you attach to a User Profile, Table, etc. Think of them as custom database columns (though complex types, like attachments and images should be treated as separate database tables). We also provide some Properties to jumpstart your development.

Example directory structure of `schema` with sample files:

```
app
└── schema
    └── blog_post.yml
```

### Notifications

**Notifications** are messages sent to platformOS users (including admins) when something happens. A message can be an email, SMS, or programmatic call to a 3rd party API.

Notifications can be delayed, and you can use Liquid, GraphQL, and trigger conditions to decide if a notification should be sent. They are a powerful mechanism used for example to welcome new users, follow up after they've added their first item, or reach out to them if they have been inactive for a while.

Each notification has its own directory:

```
app
└──
  ├── api_calls
  │   └── ping_example_com_on_user_sign_up.liquid
  ├── emails
  │   └── welcome_user.liquid
  └── smses
      └── welcome_user.liquid
```
### Authorization Policies

**Authorization Policies** allow you to restrict access to forms and pages in a flexible way. Each form or page can have multiple policies attached to it.

Each policy is parsed using Liquid, and the system checks them in order of their appearance in the code. Depending on policy configuration, it redirects the user to a URL provided by the developer if the condition is not met or renders error status, for example 403. You can also add a flash message for the user who failed authorization.

Example directory structure of `authorization_policies` with sample files:

```
app
└── authorization_policies
    └── example_policy.liquid

```

### Translations

You can use platformOS to build sites in any language, and each site can have multiple language versions. **Translations** are yml files used for multilingual sites but also used to define date formats, flash messages or system-wide default error messages like "can't be blank".

Example directory structure of `translations` with sample files:

```shell
app
└── translations
    ├── en.yml
    └── pl.yml
```

### Modules

**Modules** allow code reuse and sharing, while protecting the IP of creators.

In your codebase, the `modules` directory needs to be at the same level as the `app` directory.

Module code is split into 2 directories to protect IP. To create a module, split module code into `public` and `private` folders, and place all that code into the `modules/MODULE_NAME` directory.

These directories have the same structure as the standard `app` folder, but if developers try to download files after the module has been deployed to an Instance (`pos-cli pull`), they will only have access to the files from the `public` folder.

Example directory structure of `modules` with sample files:

```
app
modules
└──admincms
  ├── private
  │   └── graphql
  │       ├── get_records.graphql
  │       └── get_pages.graphql
  └── public
      └── views
        └── pages
            └── admin.liquid
```

