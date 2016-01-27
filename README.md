# Table of Contents
- [Introduction](#introduction)
    - [Version](#version)
    - [Changelog](Changelog.md)
- [Installation](#installation)
- [Quickstart](#quickstart)
- [Configuration](#configuration)
  - [Database](#database)
  - [Available Configuration Parameters](#available-configuration-parameters)

# Introduction

Dockerfile to build an [Activiti BPM](#http://www.activiti.org/) container image.

## Version

Current Version: 5.19.0

# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull eternnoir/activiti:latest
```

Since version `latest`, the image builds are being tagged. You can now pull a particular version of activiti by specifying the version number. For example,

```bash
docker pull eternnoir/activiti:5.16.4
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/eternnoir/activiti.git
cd activiti
docker build --tag="$USER/activiti" .
```

# Quickstart

Run the activiti image

```bash
docker run --name='activiti' -it --rm \
-p 8080:8080 \
-v /var/run/docker.sock:/run/docker.sock \
-v $(which docker):/bin/docker \
eternnoir/activiti:latest
```

Point your browser to `http://localhost:8080` and login using the default username and password:

* username: **kermit**
* password: **kermit**

You should now have the Activiti application up and ready for testing. If you want to use this image in production the please read on.


# Configuration

## Database

Activiti uses a database backend to store its data. You can configure this image to use MySQL.

### MySQL

#### External MySQL Server

The image can be configured to use an external MySQL database instead of starting a MySQL server internally. The database configuration should be specified using environment variables while starting the Activiti image.

Before you start the Activiti image create user and database for activiti.

```sql
CREATE USER 'activiti'@'%.%.%.%' IDENTIFIED BY 'password';
CREATE DATABASE IF NOT EXISTS `activiti_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
GRANT ALL PRIVILEGES ON `activiti_production`.* TO 'activiti'@'%.%.%.%';
```

We are now ready to start the Activiti application.

*Assuming that the mysql server host is 192.0.2.1*

```bash
docker run --name=activiti -d \
  -e 'DB_HOST=192.0.2.1’ -e 'DB_NAME=activiti_production' -e 'DB_USER=activiti’ -e 'DB_PASS=password' \
eternnoir/activiti:latest
```

#### Linking to MySQL Container

You can link this image with a mysql container for the database requirements. The alias of the mysql server container should be set to **mysql** while linking with the activiti image.

If a mysql container is linked, only the `DB_TYPE`, `DB_HOST` and `DB_PORT` settings are automatically retrieved using the linkage. You may still need to set other database connection parameters such as the `DB_NAME`, `DB_USER`, `DB_PASS` and so on.

To illustrate linking with a mysql container, we will use the [sameersbn/mysql](https://github.com/sameersbn/docker-mysql) image. When using docker-mysql in production you should mount a volume for the mysql data store. Please refer the [README](https://github.com/sameersbn/docker-mysql/blob/master/README.md) of docker-mysql for details.

First, lets pull the mysql image from the docker index.

```bash
docker pull sameersbn/mysql:latest
```

For data persistence lets create a store for the mysql and start the container.

SELinux users are also required to change the security context of the mount point so that it plays nicely with selinux.

```bash
mkdir -p /opt/mysql/data
sudo chcon -Rt svirt_sandbox_file_t /opt/mysql/data
```

The run command looks like this.

```bash
docker run --name=mysql -d \
  -e 'DB_NAME=activiti_production' -e 'DB_USER=activiti' -e 'DB_PASS=password' \
	-v /opt/mysql/data:/var/lib/mysql \
	sameersbn/mysql:latest
```

The above command will create a database named `activiti_production` and also create a user named `activiti` with the password `activiti` with full/remote access to the `activiti_production` database.

We are now ready to start the Activiti application.

```bash
docker run --name=activiti -d --link mysql:mysql \
  eternnoir/activiti:latest
```

The image will automatically fetch the `DB_NAME`, `DB_USER` and `DB_PASS` variables from the mysql container using the magic of docker links and works with the following images:
 - [sameersbn/mysql](https://registry.hub.docker.com/u/sameersbn/mysql/)

### Available Configuration Parameters

*Please refer the docker run command options for the `--env-file` flag where you can specify all required environment variables in a single file. This will save you from writing a potentially long docker run command.*

Below is the complete list of available options that can be used to customize your activiti installation.

- **TOMCAT_ADMIN_USER**: Tomcat admin user name. Defaults to `admin`.
- **TOMCAT_ADMIN_PASSWORD**: Tomcat admin user password. Defaults to `admin`.
- **DB_HOST**: The database server hostname. Defaults to ``.
- **DB_PORT**: The database server port. Defaults to `3306`.
- **DB_NAME**: The database database name. Defaults to ``.
- **DB_USER**: The database database user. Defaults to ``.
- **DB_PASS**: The database database password. Defaults to ``.

# Maintenance

## Shell Access

For debugging and maintenance purposes you may want access the container shell. Since the container does not allow interactive login over the SSH protocol, you can use the [nsenter](http://man7.org/linux/man-pages/man1/nsenter.1.html) linux tool (part of the util-linux package) to access the container shell.

Some linux distros (e.g. ubuntu) use older versions of the util-linux which do not include the `nsenter` tool. To get around this @jpetazzo has created a nice docker image that allows you to install the `nsenter` utility and a helper script named `docker-enter` on these distros.

To install the nsenter tool on your host execute the following command.

```bash
docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
```

Now you can access the container shell using the command

```bash
sudo docker-enter activiti
```

For more information refer https://github.com/jpetazzo/nsenter

Another tool named `nsinit` can also be used for the same purpose. Please refer https://jpetazzo.github.io/2014/03/23/lxc-attach-nsinit-nsenter-docker-0-9/ for more information.

# Upgrading

TODO

# References

* http://activiti.org/
* http://github.com/Activiti/Activiti
* http://tomcat.apache.org/
* http://dev.mysql.com/downloads/connector/j/5.1.html
* https://github.com/jpetazzo/nsenter
* https://jpetazzo.github.io/2014/03/23/lxc-attach-nsinit-nsenter-docker-0-9/
