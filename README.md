## Forked

This is a forked repo from <https://github.com/tiangolo/uwsgi-nginx-flask-docker>.
A very well maintained repo. Much respect. I suggest you may prefer his repo over this one. I chose to fork it so that I could remove some of the options and "harden" the container somewhat. A specific purpose was chosen to focus on micro-service applications using this configuration. 


## Supported tags and respective `Dockerfile` links

* [`python3.6-alpine3.7` _(Dockerfile)_](https://github.com/chuckamus-prime/uwsgi-nginx-flask-docker/blob/master/python3.6-alpine3.7/Dockerfile)

# uwsgi-nginx-flask

**Docker** image with **uWSGI** and **Nginx** for **Flask** web applications in **Python 3.6** running in a single container using **Alpine Linux**. All libraries and packages are specific versions known to work together.

## Description

This [**Docker**](https://www.docker.com/) image allows you to create [**Flask**](http://flask.pocoo.org/) web applications in [**Python**](https://www.python.org/) that run with [**uWSGI**](https://uwsgi-docs.readthedocs.org/en/latest/) and [**Nginx**](http://nginx.org/en/) in a single container.

uWSGI with Nginx is one of the best ways to deploy a Python web application, so you should have [good performance (check the benchmarks)](http://nichol.as/benchmark-of-python-web-servers) with this image.

**GitHub repo**: <https://github.com/chuckamus-prime/uwsgi-nginx-flask-docker>

**Docker Hub image**: 

## Examples (project templates)

* **`python3.6-alpine3.7`** tag: general Flask web application: 

[**example-flask-python3.6-alpine3.7.zip**](<https://github.com/chuckamus-prime/uwsgi-nginx-flask-docker/releases/download/v0.3.5/example-flask-python3.6-alpine3.7.zip>)

* **`python3.6-alpine3.7`** tag: general Flask web application, structured as a package, for bigger Flask projects, with different submodules. Use it only as an example of how to import your modules and how to structure your own project:

[**example-flask-package-python3.6-alpine3.7.zip**](<https://github.com/chuckamus-prime/uwsgi-nginx-flask-docker/releases/download/v0.3.5/example-flask-package-python3.6-alpine3.7.zip>)

## General Instructions

<!---You don't have to clone this repo, you should be able to use this image as a base image for your project with something in your `Dockerfile` like:

```Dockerfile
FROM chuckamus-prime/uwsgi-nginx-flask:python3.6-alpine3.7

COPY ./app /app
```
--->
Clone this repo, and then run the following command in the base directory:
```
./buildBaseImage.sh
```

Since thie image is not in dockerhub (yet), the script above will put the base container image in your local repo.


As of now, [everyone](https://www.python.org/dev/peps/pep-0373/) [should be](http://flask.pocoo.org/docs/0.12/python3/#python3-support) [using **Python 3**](https://docs.djangoproject.com/en/1.11/faq/install/#what-python-version-should-i-use-with-django).

There are several template projects that you can download (as a `.zip` file) to bootstrap your project in the section "**Examples (project templates)**" above.

This Docker image is based on [**python docker container using alpine linux**](https://hub.docker.com/_/python/). This Docker image adds uWSGI with Flask and Nginx, installed in the same container. This will serve as a base for micro-services written in python.


## QuickStart

**Note**: You can download the **example-flask-python3.6.zip** project example and use it as the template for your project from the section **Examples** above.

---

Or you may follow the instructions to build your project from scratch:

* Go to your project directory
* Create a `Dockerfile` with:

```Dockerfile
FROM chuckamus-prime/uwsgi-nginx-flask:python3.6-alpine3.7

COPY ./app /app
```

* Create an `app` directory and enter in it
* Create a `main.py` file (it should be named like that and should be in your `app` directory) with:

```python
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World from Flask"

if __name__ == "__main__":
    # Only for debugging while developing
    app.run(host='0.0.0.0', debug=True, port=9000)
```

the main application object should be named `app` (in the code) as in this example.

**Note**: The section with the `main()` function is for debugging purposes. To learn more, read the **Advanced instructions** below.

* You should now have a directory structure like:

```
.
├── app
│   └── main.py
└── Dockerfile
```

* Go to the project directory (in where your `Dockerfile` is, containing your `app` directory)
* Build your Flask image:

```bash
docker build -t myimage .
```

* Run a container based on your image:

```bash
docker run -d --name mycontainer -p 443:443 myimage
```

...and you have an optimized Flask server in a Docker container.

You should be able to check it in your Docker container's URL, for example: <https://192.168.99.100:443/>

## QuickStart for bigger projects structured as a Python package

**Note**: You can download the **example-flask-package-python3.6.zip** project example and use it as an example or template for your project from the section **Examples** above.

---

You should be able to follow the same instructions as in the "**QuickStart**" section above, with some minor modifications:

* Instead of putting your code in the `app/` directory, put it in a directory `app/app/`.
* Add an empty file `__init__.py` inside of that `app/app/` directory.
* Add a file `uwsgi.ini` inside your `app/` directory (that is copied to `/app/uwsgi.ini` inside the container).
* In your `uwsgi.ini` file, add:

```ini
[uwsgi]
module = app.main
callable = app
```

The explanation of the `uwsgi.ini` is as follows:

* The module in where my Python web app lives is `app.main`. So, in the package `app` (`/app/app`), get the `main` module (`main.py`).
* The Flask web application is the `app` object (`app = Flask(__name__)`).

Your file structure would look like:

```
.
├── app
│   ├── app
│   │   ├── __init__.py
│   │   ├── main.py
│   └── uwsgi.ini
└── Dockerfile
```

...instead of:

```
.
├── app
│   ├── main.py
└── Dockerfile
```

...after that, everything should work as expected. All the other instructions would apply normally.

### Working with submodules

* After adding all your modules you could end up with a file structure similar to (taken from the example project):

```
.
├── app
│   ├── app
│   │   ├── api
│   │   │   ├── api.py
│   │   │   ├── endpoints
│   │   │   │   ├── __init__.py
│   │   │   │   └── user.py
│   │   │   ├── __init__.py
│   │   │   └── utils.py
│   │   ├── core
│   │   │   ├── app_setup.py
│   │   │   ├── database.py
│   │   │   └── __init__.py
│   │   ├── __init__.py
│   │   ├── main.py
│   │   └── models
│   │       ├── __init__.py
│   │       └── user.py
│   └── uwsgi.ini
└── Dockerfile
```

* Make sure you follow [the offical docs while importing your modules](https://docs.python.org/3/tutorial/modules.html#intra-package-references):

* For example, if you are in `app/app/main.py` and want to import the module in `app/app/core/app_setup.py` you would wirte it like:

```python
from .core import app_setup
```

or 

```python
from app.core import app_setup
```


* And if you are in `app/app/api/endpoints/user.py` and you want to import the `users` object from `app/app/core/database.py` you would write it like:

```python
from ...core.database import users
```

or

```python
from app.core.database import users
```

## Advanced instructions

You can customize several things using environment variables.

### Max upload file size

You can set a custom maximum upload file size using an environment variable `NGINX_MAX_UPLOAD`, by default it has a value of `0`, that allows unlimited upload file sizes. This differs from Nginx's default value of 1 MB. It's configured this way because that's the simplest experience a developer that is not expert in Nginx would expect.

For example, to have a maximum upload file size of 1 MB (Nginx's default) add a line in your `Dockerfile` with:

```Dockerfile
ENV NGINX_MAX_UPLOAD 1m
```

### Custom `uwsgi.ini` file

You can override where the image should look for the app `uwsgi.ini` file using the envirnoment variable `UWSGI_INI`.

With that you could change the default directory for your app from `/app` to something else, like `/application`.

For example, to make the image use the file in `/application/uwsgi.ini`, you could add this to your `Dockerfile`:

```Dockerfile
ENV UWSGI_INI /application/uwsgi.ini

COPY ./application /application
WORKDIR /application
```

**Note**: the `WORKDIR` is important, otherwhise uWSGI will try to run the app in `/app`.

**Note**: you would also have to configure the `static` files path, read below.

### Custom `/app/prestart.sh`

If you need to run anything before starting the app, you can add a file `prestart.sh` to the directory `/app`. The image will automatically detect and run it before starting everything. 

For example, if you want to add Alembic SQL migrations (with SQLALchemy), you could create a `./app/prestart.sh` file in your code directory (that will be copied by your `Dockerfile`) with:

```bash
#! /usr/bin/env bash

# Let the DB start
sleep 10;
# Run migrations
alembic upgrade head
```

and it would wait 10 seconds to give the database some time to start and then run that `alembic` command.

If you need to run a Python script before starting the app, you could make the `/app/prestart.sh` file run your Python script, with something like:

```bash
#! /usr/bin/env bash

# Run custom Python script before starting
python /app/my_custom_prestart_script.y
```

**Note**: The image uses `source` to run the script, so for example, environment variables would persist. If you don't understand the previous sentence, you probably don't need it.

## Custom Nginx processes number

By default, Nginx will start one "worker process".

If you want to set a different number of Nginx worker processes you can use the environment variable `NGINX_WORKER_PROCESSES`.

You can use a specific single number, e.g.:

```Dockerfile
ENV NGINX_WORKER_PROCESSES 2
```

or you can set it to the keyword `auto` and it will try to autodetect the number of CPUs available and use that for the number of workers.

For example, using `auto`, your Dockerfile could look like:

```Dockerfile
FROM chuckamus-prime/uwsgi-nginx-flask:python3.6-alpine3.7

ENV NGINX_WORKER_PROCESSES auto

COPY ./app /app
```

## Custom Nginx maximum connections per worker

By default, Nginx will start with a maximum limit of 1024 connections per worker.

If you want to set a different number you can use the environment variable `NGINX_WORKER_CONNECTIONS`, e.g:

```Dockerfile
ENV NGINX_WORKER_CONNECTIONS 2048
```

It cannot exceed the current limit on the maximum number of open files. See how to configure it in the next section.

## Custom Nginx maximum open files

The number connections per Nginx worker cannot exceed the limit on the maximum number of open files.

You can change the limit of open files with the environment variable `NGINX_WORKER_OPEN_FILES`, e.g.:

```Dockerfile
ENV NGINX_WORKER_OPEN_FILES 2048
```

## Customizing Nginx configurations

If you need to configure Nginx further, you can add `*.conf` files to `/etc/nginx/conf.d/` in your Dockerfile.

Just have in mind that the default configurations are created during startup in a file in `/etc/nginx/conf.d/nginx.conf` and `/etc/nginx/conf.d/upload.conf`. So you shouldn't overwrite them. You should name your `*.conf` file with something different than `nginx.conf` or `upload.conf`.

## Technical details

One of the best ways to deploy a Python web application is with uWSGI and Nginx, as seen in the [benchmarks](http://nichol.as/benchmark-of-python-web-servers).

Roughly:

* **Nginx** is a web server, it takes care of the HTTP connections and also can serve static files directly and more efficiently.

* **uWSGI** is an application server, that's what runs your Python code and it talks with Nginx.

* **Your Python code** has the actual **Flask** web application, and is run by uWSGI.

The image uses the official Python Docker image, installs Nginx, uWSGI and flask.

And it controls all these processes with Supervisord.

If you follow the instructions and keep the root directory `/app` in your container, with a file named `main.py` and a Flask object named `app` in it, it should "just work".

There's already a `uwsgi.ini` file in the `/app` directory with the uWSGI configurations for it to "just work". And all the other required parameters are in another `uwsgi.ini` file in the image, inside `/etc/uwsgi/`.

If you need to change the main file name or the main Flask object, you would have to provide your own `uwsgi.ini` file. You may use the one in this repo as a template to start with (and you only would have to change the 2 corresponding lines).

You can have a `/app/static` directory and those files will be efficiently served by Nginx directly (without going through your Flask code or even uWSGI), it's already configured for you. But you can configure it further using environment variables (read above).

Supervisord takes care of running uWSGI with the `uwsgi.ini` file in `/app` file (including also the file in `/etc/uwsgi/uwsgi.ini`) and starting Nginx.

---

There's the rule of thumb that you should have "one process per container".

That helps, for example, isolating an app and its database in different containers.

But if you want to have a "micro-services" approach you may want to [have more than one process in one container](https://valdhaus.co/writings/docker-misconceptions/) if they are all related to the same "service", and you may want to include your Flask code, uWSGI and Nginx in the same container (and maybe run another container with your database).

That's the approach taken in this image.

---

This image (and tags) have some default files, so if you run it by itself (not as the base image of your own project) you will see a default "Hello World" web app.

When you build a `Dockerfile` with a `COPY ./app /app` you replace those default files with your app code.

The main default file is only in `/app/main.py`. And in the case of the tags with `-index`, also in `/app/static/index.html`.

But those files render a "(default)" text in the served web page, so that you can check if you are seeing the default code or your own code overriding the default.

Your app code should be in the container's `/app` directory, it should have a `main.py` file and that `main.py` file should have a Flask object `app`.

If you follow the instructions above or use one of the downloadable example templates, you should be OK.

There is also a `/app/uwsgi.ini` file inside the images with the default parameters for uWSGI.

The downloadable examples include a copy of the same `uwsgi.ini` file for debugging purposes. To learn more, read the "**Advanced development instructions**" below.

## Advanced development instructions

While developing, you might want to make your code directory a volume in your Docker container.

With that you would have your files (temporarily) updated every time you modify them, without needing to build your container again.

To do this, you can use the command `pwd` (print working directory) inside your `docker run` and the flag `-v` for volumes.

With that you could map your `./app` directory to your container's `/app` directory.

But first, as you will be completely replacing the directory `/app` in your container (and all of its contents) you will need to have a `uwsgi.ini` file in your `./app` directory with:

```ini
[uwsgi]
module = main
callable = app
```

and then you can do the Docker volume mapping.

**Note**: A `uwsgi.ini` file is included in the downloadable examples.

* To try it, go to your project directory (the one with your `Dockerfile` and your `./app` directory)
* Make sure you have a `uwsgi.ini` file in your `./app` directory
* Build your Docker image:

```bash
docker build -t myimage .
```

* Run a container based on your image, mapping your code directory (`./app`) to your container's `/app` directory:
bash
```
docker run -d --name mycontainer -p 443:443 -v $(pwd)/app:/app myimage
```

If you go to your Docker container URL you should see your app, and you should be able to modify files in `./app/static/` and see those changes reflected in your browser just by reloading.

...but, as uWSGI loads your whole Python Flask web application once it starts, you won't be able to edit your Python Flask code and see the changes reflected.

To be able to (temporarily) debug your Python Flask code live, you can run your container overriding the default command (that starts Supervisord which in turn starts uWSGI and Nginx) and run your application directly with `python`, in debug mode, using the `flask` command with its environment variables.

So, with all the modifications above and making your app run directly with `flask`, the final Docker command would be:

 ```bash
docker run -d --name mycontainer -p 443:443 -v $(pwd)/app:/app -e FLASK_APP=main.py -e FLASK_DEBUG=1 myimage flask run --host=0.0.0.0 --port=9000
```

Or in the case of a package project, you would set `FLASK_APP=main/main.py`:

```bash
docker run -d --name mycontainer -p 443:443 -v $(pwd)/app:/app -e FLASK_APP=main/main.py -e FLASK_DEBUG=1 myimage flask run --host=0.0.0.0 --port=9000
```

Now you can edit your Flask code in your local machine and once you refresh your browser, you will see the changes live.

Remember that you should use this only for debugging and development, for deployment in production you shouldn't mount volumes and you should let Supervisord start and let it start uWSGI and Nginx (which is what happens by default).

An alternative for these last steps to work when you don't have a package but just a flat structure with single files (modules), your Python Flask code could have that section with:

```python
if __name__ == "__main__":
   # Only for debugging while developing
   app.run(host='0.0.0.0', debug=True, port=9000)
```

...and you could run it with `python main.py`. But that will only work when you are not using a package structure and don't plan to do it later. In that specific case, if you didn't add the code block above, your app would only listen to `localhost` (inside the container), in another port (5000) and not in debug mode.

**Note**: The example project **example-flask-python3.6** includes a `docker-compose.yml` and `docker-compose.override.yml` with all these configurations, if you are using Docker Compose.

---


## More advanced development instructions

If you follow the instructions above, it's probable that at some point, you will write code that will break your Flask debugging server and it will crash.

And since the only process running was your debugging server, that now is stopped, your container will stop.

Then you will have to start your container again after fixing your code and you won't see very easily what is the error that is crashing your server.

So, while developing, you could do the following (that's what I normally do, although I do it with Docker Compose, as in the example projects):

* Make your container run and keep it alive in an infinite loop (without running any server):

```bash
docker run -d --name mycontainer -p 443:443 -v $(pwd)/app:/app -e FLASK_APP=main.py -e FLASK_DEBUG=1 myimage bash -c "while true ; do sleep 10 ; done"
```

* Or, if your project is a package, set `FLASK_APP=main/main.py`:

```bash
docker run -d --name mycontainer -p 443:443 -v $(pwd)/app:/app -e FLASK_APP=main/main.py -e FLASK_DEBUG=1 myimage bash -c "while true ; do sleep 10 ; done"
```

* Connect to your container with a new interactive session:

```bash
docker exec -it mycontainer bash
```

You will now be inside your container in the `/app` directory.

* Now, from inside the container, run your Flask debugging server:

```bash
flask run --host=0.0.0.0 --port=9001
```

You will see your Flask debugging server start, you will see how it sends responses to every request, you will see the errors thrown when you break your code and how they stop your server and you will be able to re-start your server very fast, by just running the command above again.

## What's new
2018-06-28:
* Removed references to static content serving. 
* Changed ports in documentation from 80 to 443
* Removed depricated code/examples
* Consolodated to the python 3.6 version using Alpine Linux
* Specified the version of Flask for pip
* merged Sebastián Ramírez's base container and its neccesary files <https://github.com/tiangolo/uwsgi-nginx-docker> into one base image with more control in one base image and prescribing flask


2018-06-27:
* Forked from <https://github.com/tiangolo/uwsgi-nginx-flask-docker>.
* (refer to that repo for prior hisory)

## License

This project is licensed under the terms of the Apache license.
