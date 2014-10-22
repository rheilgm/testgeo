#!/bin/bash
docker stop tests-accumulo; docker start tests-accumulo
docker attach tests-accumulo
