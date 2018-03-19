docker-liquidfeedback
=====================

Docker image to run an instance of the liquidfeedback software

How to build:

	$ docker build -t liquid-feedback .

How to run:

	$ docker run --sig-proxy=false -p 8080:8080 liquid-feedback

Open the browser (on the same machine):

	http://localhost:8080
