#!/bin/bash
set -e
browser_name=$1
browser_channel=$2
publish=${3:-"false"}

if [ -z "$browser_name" -o -z "$browser_channel" ]; then
    echo 'Usage: ./build_image.sh <browser_name> <browser_channel> [<publish>]'
    exit 1
elif [ "$browser_name" != "chrome" ]; then
    echo 'Usage: ./build_image.sh chrome <browser_channel> [<publish>]'
    exit 1
elif [ "$browser_channel" != "stable" -a "$browser_channel" != "beta" -a "$browser_channel" != "dev" ]; then
    echo 'Usage: ./build_image.sh <browser_name> {stable|beta|dev} [<publish>]'
    exit 1
elif [ "$publish" != "true" -a "$publish" != "false" ]; then
    echo 'Usage: ./build_image.sh <browser_name> <browser_channel> [{true|false}]'
    exit 1
fi
set -x

get_chrome_version(){
    echo "$(curl -s https://omahaproxy.appspot.com/history | awk -F',' '/linux,'$1'/{print $3; exit}')"
}

get_chromedriver_version(){
    driver_latest_releases_baseurl="https://chromedriver.storage.googleapis.com"
    if [ "$2" == "dev" ]; then
        browser_version_major=$(echo "$1" | cut -d. -f1)
        status_code=$(curl -LI  $driver_latest_releases_baseurl/LATEST_RELEASE_$browser_version_major -o /dev/null -w '%{http_code}\n' -s)
        if [ "$status_code" == "404" ]; then
            let browser_version_major--
        fi
        echo "$(curl -s $driver_latest_releases_baseurl/LATEST_RELEASE_$browser_version_major)"
    else
        browser_version_build=$(echo "$1" | cut -d. -f1-3)
        echo "$(curl -s $driver_latest_releases_baseurl/LATEST_RELEASE_$browser_version_build)"
    fi
}

publish_image(){
    if [ "$3" == "true" ] ; then
        docker tag selenoid/$1:$2 twilio/selenoid:$1_$2
        docker push twilio/selenoid:$1_$2
    fi
}

case $browser_name in
        chrome)
            browser_version=$(get_chrome_version $browser_channel)
            driver_version=$(get_chromedriver_version $browser_version $browser_channel)
            echo "n" | ./automate_chrome.sh $browser_version-1 $driver_version $browser_channel
            publish_image $browser_name $browser_channel $publish
            ;;
esac




