#!/bin/bash
set -e
input=$1
server_version=$2
tag=$3
driver_version=$4

if [ -z "$1" -o -z "$2" -o -z "$3" ]; then
    echo 'Usage: automate_firefox.sh <browser_version|package_file> <selenium_version|selenoid_version> <tag_version> [<geckodriver_version>]'
    exit 1
fi
set -x

browser_version=$input
method="firefox/apt"
runner="selenoid"
requires_java="false"
numeric_version=$(echo "$browser_version" | awk -F '.' '{print $1}' )
if [ $numeric_version -lt 48 ]; then
    runner="selenium"
    requires_java="true"
elif [ -z "$driver_version" ]; then
    echo 'Driver version is required for Firefox 48 and above'
    exit 1
fi

if [ -f "$input" ]; then
    filename=$(echo "$input" | awk -F '/' '{print $NF}')
    arch=$(echo "$filename" | awk -F '_' '{print $NF}' | sed -e 's|.deb||g')
    rm -f firefox/local/firefox*.deb
    cp "$input" firefox/local/firefox_$arch.deb
    browser_version=$(echo $filename | awk -F '_' '{print $2$3}' | awk -F '+' '{print $1}' | awk -F '~hg' '{print $1}' | sed -e 's/~//g')
    browser_release_version=$browser_version
    method="firefox/local"
else
    browser_release_version=$(echo $browser_version | awk -F '+' '{print $1}' | awk -F '~hg' '{print $1}' | sed -e 's/~//g')
fi

if [ "$tag" == "beta" -o "$tag" == "dev" ]; then
    method_channel="$method/$tag"
else
    method_channel="$method/stable"
fi

if [ "$tag" == "stable" -o "$tag" == "beta" -o "$tag" == "dev" ]; then
    dev_tag=$browser_release_version
else
    dev_tag=$tag
fi

./build-dev.sh $method_channel $browser_version true $requires_java $dev_tag
if [ "$method" == "firefox/apt" ]; then
    ./build-dev.sh $method_channel $browser_version false $requires_java $dev_tag
fi
pushd firefox/$runner
../../build.sh $runner $dev_tag $server_version selenoid/firefox:$tag "$driver_version"
popd

test_image(){
    docker rm -f selenium || true
    docker run -d --name selenium -p 4445:4444 $1
    tests_dir=../../selenoid-container-tests/
    if [ -d "$tests_dir" ]; then
        pushd "$tests_dir"
        mvn clean test -Dgrid.connection.url="http://localhost:4445/wd/hub" -Dgrid.browser.name=firefox -Dgrid.browser.version=$2
        popd
    else
        echo "Skipping tests as $tests_dir does not exist."
    fi
}

test_image "selenoid/firefox:$tag" $dev_tag
docker tag "selenoid/firefox:$tag" "selenoid/vnc_firefox:$tag"
docker tag "selenoid/firefox:$tag" "selenoid/vnc:firefox_$tag"

read -p "Push?" yn
if [ "$yn" == "y" ]; then
	docker push "selenoid/dev_firefox:"$dev_tag
	if [ "$method" == "firefox/apt" ]; then
	    docker push "selenoid/dev_firefox_full:"$dev_tag
    fi
	docker push "selenoid/firefox:$tag"
    docker tag "selenoid/firefox:$tag" "selenoid/firefox:latest"
    docker push "selenoid/firefox:latest"
    docker push "selenoid/vnc:firefox_"$tag
    docker push "selenoid/vnc_firefox:"$tag
fi
