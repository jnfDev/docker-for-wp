# Docker for WordPress

## Run and Build ##
After cloning the repo, you will have both `docker-compose.yml` and `Dockerfile` files, you can simply run this command `docker-compose up -d`, if you made any change over the file, you can run also `docker-compose build` to include the changes. 

## Setting up permissions ##
If you are using a LINUX or similar, you have to make sure you have proper write permissions, to do so run:
`sudo chmod 775 -R .` on the root folder.

## Use custom domains other than localhost
If you want to work with custom domains in your local environment, there are a couple of steps to take first.

### Step 1: Create a network
This network will be used to connect all the container with the Reverse Proxy. Use the next command:

``
docker network create --driver bridge reverse-proxy
``

### Step 2: Set up an Reverse Proxy
``
docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro --network reverse-proxy --name reverse-proxy jwilder/nginx-proxy
``

If for any reason you experience any timeout error you can increase the timeout by adding this to the previous command `-v ~/path-in-your-machine/nginx/conf.d:/etc/nginx/conf.d`, also you need to add a new file with name `proxy-settings.conf` and add the next statements inside:

```
proxy_connect_timeout       300;
proxy_send_timeout          300;
proxy_read_timeout          90m;
send_timeout                300;

client_max_body_size        5000m;
```

You can increase the values if is needed.

### Step 3: Create an entry on the **hosts** file
It's depend on your operating system, for windows is on `C:\Windows\System32\drivers\etc\hosts`, for Linux Ubuntu based is on `/etc/hosts`. Search for your specific operating system.

Once you found your hosts file location, add a new entry inside, should look like this:

```
127.0.0.1 mywpsite.local
127.0.0.1 myotherwpsite.dev
```
And so on...

### Step 4: Customize your docker-compose.yml file
Add the next entries at the very bottom of your `docker-compose.yml`

```
networks:
    reverse-proxy:
        external: true
    default:

```
Also, add these entries in your web/server container 

```
  wordpress:
    ...
    ...
    networks:
      - reverse-proxy
      - default
    environment:
        ...
        VIRTUAL_HOST: mywpsite.local
        ..
    ...
    ...
```

The `VIRTUAL_HOST` env variable value will be your domain and need to match with the value settled on the hosts file.
