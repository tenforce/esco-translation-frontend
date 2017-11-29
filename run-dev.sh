#!/bin/bash
exec docker run -it --rm \
	-v "$PWD/dist":/src/dist \
	-v "$PWD/app":/src/app  \
	-v "$PWD/package.json":/src/package.json \
	-v "$PWD/config":/src/config \
	-v "$PWD/tests":/src/tests \
	translation-frontend-dev bash -c "npm install -q && ember build --watch"
