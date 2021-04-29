# elabs-bubble-apps-proxy
Manages HTTPS naming &amp; access of local server applications (e.g. cockpit, etc.) behind elabs-https-nginx-proxy

**Table Of Contents:**
  - [Docker environment preparation](#docker-environment-preparation)
  - [Bubble Apps proxy deployment preparation](#bubble-apps-proxy-deployment-preparation)
  - [Stack deployment and management](#stack-deployment-and-management)

----

## Docker environment preparation 
This stack is meant to be deployed behind an automated NGINX based HTTPS proxy. The recommanded automated HTTPS proxy for this stack is the [Elasticlabs HTTPS Nginx Proxy](https://github.com/elasticlabs/elabs-https-nginx-proxy. This composition repository assumes you have this environment :
* Working HTTPS Nginx proxy using Let'sencrypt certificates
* A local docker LAN network called `revproxy_apps` for hosting your *bubble apps* (Nginx entrypoint for each *bubble*). 

**Once you have a HTTPS reverse proxy**, navigate to the  [next](#bubble-apps-proxy-deployment-preparation) section.


## Bubble Apps proxy deployment preparation :
* Choose & register a DNS name (e.g. `bubble.your-awesome-domain.ltd`). Make sure it properly resolves from your server using `nslookup`commands.
* Carefully create / choose an appropriate directory to group your applications GIT reposities (e.g. `~/AppContainers/`)
* GIT clone this repository `git clone https://github.com/elasticlabs/elabs-bubble-apps-proxy.git`

**Configuration**
* **Rename `.env-changeme` file into `.env`** to ensure `docker-compose` gets its environement correctly.
* Modify the following variables in `.env-changeme` file :
  * `VIRTUAL_HOST=` : replace `bubble.your-domain.ltd` with your choosen subdomain for teamengine.
  * `LETSENCRYPT_EMAIL=` : replace `email@mail-provider.ltd` with the email address to get notifications on Certificates issues for your domain.
* Modify the `proxy/bubble-stack.conf` file to fit your proxy needs. Example configuration givne for cockpit admin web GUI.


## Stack deployment and management
**Deployment**
* Get help : `sudo make`
* Bring up the whole stack : `sudo make up`
* Head to **`http://bubble.your-awesome-domain.ltd/app`** and enjoy your `app`!

**Useful management commands**
* Go inside a container : `sudo docker-compose exec -it <service-id> bash` or `sh`
* See logs of a container: `sudo docker-compose logs <service-id>`
* Monitor containers : `sudo docker stats` or... use portainer!