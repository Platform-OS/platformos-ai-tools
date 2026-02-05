# Add a new page to your site at the URL you specify.

## Steps

Adding a new page at a custom URL is a two-step process:

<div data-autosteps></div>

### Step 1: Create link to new page

Add a link to the previously created `index.liquid` page, that links to the About page:

##### app/views/pages/index.liquid

```liquid

<a href="/about">About</a>

Homepage

```

Sync or deploy. You should find the About link appear on your Homepage.

### Step 2: Create new Page

Create the `about.liquid` page in the `app/views/pages` directory. Add a short description ("About"), that shows you this is the About page, and also a link back to the Homepage.

##### app/views/pages/about.liquid

```liquid

About page

<a href="/">Home</a>

```

Sync or deploy. You should find that the About link on your Homepage now links to the newly created About page. The Home link on your About page links to your Homepage, so you can switch back and forth between the two pages.
