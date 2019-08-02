#!/bin/bash
set -e
source ./common.sh
input=$1
driver_version=$2
tag=$3

if [ -z "$1" -o -z "$2" -o -z "$3" ]; then
    echo 'Usage: ./automate_chrome.sh <browser_version|package_file> <chromedriver_version> <tag_version>'
    exit 1
fi
set -x

browser_version=$input
method="chrome/apt"
if [ -f "$input" ]; then
    cp "$input" chrome/local/google-chrome-stable.deb
    filename=$(echo "$input" | awk -F '/' '{print $NF}')
    browser_version=$(echo $filename | awk -F '_' '{print $2}' | awk -F '-' '{print $1}')
    method="chrome/local"
fi

if [ "$tag" == "beta" -o "$tag" == "dev" ]; then
    method_channel="$method/$tag"
else
    method_channel="$method/stable"
fi

if [ "$tag" == "stable" -o "$tag" == "beta" -o "$tag" == "dev" ]; then
    version_for_build=$browser_version
    browser_binary_version=$(get_browser_version chrome $browser_version)
else
    version_for_build=$tag
    browser_binary_version=$tag
fi

./build-dev.sh $method_channel $browser_version true false $tag
if [ "$method" == "chrome/apt" ]; then
    ./build-dev.sh $method_channel $browser_version false false $tag
fi
pushd chrome
../build.sh chromedriver $version_for_build $driver_version selenoid/chrome:$tag
popd

test_image(){
    docker rm -f selenium || true
    docker run -d --name selenium -p 4445:4444 $1
    tests_dir=../../selenoid-container-tests/
    if [ -d "$tests_dir" ]; then
        pushd "$tests_dir"
        mvn clean test -Dgrid.connection.url="http://localhost:4445/" -Dgrid.browser.name=chrome -Dgrid.browser.version=$2
        popd
    else
        echo "Skipping tests as $tests_dir does not exist."
    fi
}

test_image "selenoid/chrome:$tag" $browser_binary_version
docker tag "selenoid/chrome:$tag" "selenoid/vnc_chrome:$tag"
docker tag "selenoid/chrome:$tag" "selenoid/vnc:chrome_$tag"

read -p "Push?" yn
if [ "$yn" == "y" ]; then
	docker push "selenoid/dev_chrome:"$tag
	if [ "$method" == "chrome/apt" ]; then
    	docker push "selenoid/dev_chrome_full:"$tag
    fi
	docker push "selenoid/chrome:$tag"
    docker tag "selenoid/chrome:$tag" "selenoid/chrome:latest"
    docker push "selenoid/chrome:latest"
    docker push "selenoid/vnc:chrome_"$tag
    docker push "selenoid/vnc_chrome:"$tag
fi
