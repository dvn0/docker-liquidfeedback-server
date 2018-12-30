docker-liquidfeedback
=====================

Docker image to run an instance of the liquidfeedback software

How to build:

	$ docker build -t liquid-feedback .

How to run:

	$ docker run --sig-proxy=false -p 8080:8080 liquid-feedback

Open the browser (on the same machine):

	http://localhost:8080


Notes:

For debugging purposes it can be useful to know where postgres is storing its data:

        $ psql -c "show data_directory;"
