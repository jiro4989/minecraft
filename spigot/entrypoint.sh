#!/bin/bash

# spigotコンテナ内から実行する

set -eu

mkdir /work
cd $_
wget -q https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
java -jar BuildTools.jar --rev latest
cp -p spigot-*.jar /opt/minecraft/bin/server.jar
