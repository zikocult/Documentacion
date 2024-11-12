## Implementing NginX as a Reverse Proxy  
##### LPIC-2: Linux Engineer (202-450)  

### Objectives:  

At the end of this episode, I will be able to:  

1. Describe the purpose and function of a reverse proxy. 
2. Configure NginX to act as a reverse proxy for an Apache-based back-end. 

>Additional resources used during the episode can be obtained using the download link on the overview episode.  

-----------------------------------------------------------

* Implementing NginX as a Reverse Proxy
	+ What is a reverse proxy?
	+ When to use a reverse proxy
	+ Configuring NginX as a reverse proxy
* What is a reverse proxy?
	+ Middle-man
	+ Sits in between a source and destination
	+ Can provide many features
		- Caching
		- Encryption
		- Load balancing
* When to use a reverse proxy
	+ Encryption
		- Can be used to off-load SSL/TLS operations from a web server
	+ Performance
		- Edge servers to support geo-routing
	+ Masking complexity
		- Hide multiple servers behind one server
		- Very useful with Docker containers
	+ Minimize attack surface
		- The proxy is the only server exposed to the Internet
* Configuring NginX as a reverse proxy
	+ Edit the configuration
		- `sudoedit /etc/nginx/sites-available/default`
	+ Modify the `location` section
	+ Minimum entry
		- `proxy_pass <remote_destination>;`

#### Example:
```
server {
	listen 80 default_server;
	server_name lab.itpro.tv;
	location / {
        proxy_pass http://web01.lab.itpro.tv:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
	}
}
```
