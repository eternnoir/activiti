# Table of Contents
- [Introduction](#introduction)
    - [Version](#version)
    - [Changelog](Changelog.md)
- [Configuration](#configuration)
  - [Available Configuration Parameters](#available-configuration-parameters)

# Introduction

Dockerfile to build an Activiti BPM container image.

## Version

Current Version: **latest**


# Quickstart

A Docker image with activiti BPM Platform.

Get Image

```
$ docker pull eternnoir/activiti
$ docker run -t -i -p 8080:8080 eternnoir/activiti
```
Browser open http://YOURIP:8080/activiti-explorer/ and enjoy it

# Configuration

### Available Configuration Parameters

*Please refer the docker run command options for the `--env-file` flag where you can specify all required environment variables in a single file. This will save you from writing a potentially long docker run command.*

Below is the complete list of available options that can be used to customize your activiti installation.

- **TOMCAT_ADMIN_USER**: Tomcat admin user name. Defaults to `admin`
- **TOMCAT_ADMIN_PASSWORD**: Tomcat admin user password. Defaults to `admin`

