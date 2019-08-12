#!/bin/#!/usr/bin/env bash

## MONGO DB CLUSTER INSTALATION ##

# SOURCES:
# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/

# Definimos algunas variables
OSV=$(cat /etc/os-release)
GPGKey='https://www.mongodb.org/static/pgp/server-3.2.asc'
read IPHost

# Agregamos la Key GPG
wget -qO - $GPGKey | sudo apt-key add -

# Agregamos el repo a la lista de apt
echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# Actualizamos los repos e instalamos Mongo
# Reload local package database
apt-get update && apt-get install -y mongodb-org
