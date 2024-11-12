## Redirecting URLs with Apache  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Define 301, 302, redirects, and rewrites as well as when to use them.
2. Configure redirects using an htaccess file in Apache.

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Redirecting content
	+ Apache uses the `.htaccess` file
	+ Types
		- Redirect
			+ 301 (permanent)
			+ 302 (temporary)
		- Rewrite
* Enabling htaccess files
	+ Can be enabled/disabled on a per-vhost basis
	+ `sudoedit /etc/apache2/sites-available/<name>`
		- `AllowOverride All`
	+ `.htaccess` file is placed in the website content folder
* Basic redirects
	+ Redirect a file to another file
		- `Redirect 301 /old.html /new.html`
	+ Redirecting all URLs to another domain
		- `Redirect 301 / https://newsite.com/`
	+ Redirect a single directory to another site
		- `Redirect 301 /account/ https://newsite.com/account/`
* Using context matching and regex
	+ Redirect from a directory to another
		- `RedirectMatch 301 ^/shop/ /products/`
	+ Redirecting an old directory to new directory
		- `RewriteRule ^blog/(.*)/(.*)/(.*)$ /news/$2/$1/$3 [R=301,NC,L]`
	+ Options
		- `R`  - Redirect. Indicates an external redirect
		- `NC` - No case. Disables case sensitivity
		- `L`  - Last. Do not apply any other rules
* Real-world example
	+ Adding www and redirecting to HTTPS
		- `RewriteEngine On`
		- `RewriteCond %{HTTP_HOST} ^website.com`
		- `RewriteRule (.*) https://www.website.com/$1 [R=301,L]`
