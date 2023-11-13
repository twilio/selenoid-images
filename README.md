# Browser Images
[![Build Status](https://github.com/aerokube/images/workflows/build/badge.svg)](https://github.com/aerokube/images/actions?query=workflow%3Abuild)
[![Release](https://img.shields.io/github/release/aerokube/images.svg)](https://github.com/aerokube/images/releases/latest)

This repository contains [Docker](http://docker.com/) build files to be used for [Selenoid](http://github.com/aerokube/selenoid) and [Moon](http://github.com/aerokube/moon) projects. You can find prebuilt images [here](https://hub.docker.com/u/selenoid/).

## Download Statistics

### Firefox: [![Firefox Docker Pulls](https://img.shields.io/docker/pulls/selenoid/firefox.svg)](https://hub.docker.com/r/selenoid/firefox)

### Chrome: [![Chrome Docker Pulls](https://img.shields.io/docker/pulls/selenoid/chrome.svg)](https://hub.docker.com/r/selenoid/chrome)

### Opera: [![Opera Docker Pulls](https://img.shields.io/docker/pulls/selenoid/opera.svg)](https://hub.docker.com/r/selenoid/opera)

### Android: [![Android Docker Pulls](https://img.shields.io/docker/pulls/selenoid/android.svg)](https://hub.docker.com/r/selenoid/android)

## Build the binary

### MacOS
1. Install go environment via homebrew or direct download from https://go.dev/doc/install. 
Check with go.mod and CI scripts to align the go version.
Setup go path:
```
export GOPATH=/Users/<<USER>>/go
export PATH=$GOPATH/bin:$PATH
```

2. Install and run the packager for static Dockerfiles (required if Dockerfiles are modified):
```
go install github.com/markbates/pkger/cmd/pkger@latest
go install github.com/mitchellh/gox@latest # cross compile
go generate github.com/aerokube/images
```
3. Build the image builder binary:
```
go clean
go build
```
Build artifacts will be present in /dist directory.

## Image information
Moved to: http://aerokube.com/images/latest/#_browser_image_information
