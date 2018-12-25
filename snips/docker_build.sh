#!/bin/bash
set +x 
set +v 

echo -e "#####################"
echo -e "# Updating Git Repo #"
echo -e "#####################\n"

git add .
git commit -a -m 'updated version'
git push

UNAME=$(uname -p)
echo "UNAME=$UNAME"
if [ "$UNAME" == "x86_64" ]; then
    ARCH="amd64"
else
    ARCH="armhf"
fi

VERSION=$(grep version config.json  | grep -o '[0-9\.\-]*')
BUILD_FROM=$(jq --raw-output ".build_from.${ARCH}" build.json)
jq --raw-output ".build_from.$ARCH" build.json

echo -e "\n#####################"
echo -e "# Building image    #"
echo -e "#####################\n"

echo "Building version $VERSION from $BUILD_FROM for $ARCH"
docker build --build-arg BUILD_FROM=$BUILD_FROM .
if [ "$?" -ne 0 ]; then
    echo "ERROR: Could not build image"
    exit 1
fi

IMAGE=$(docker images | awk '{print $3}' | awk 'NR==2')

echo -e "\n#####################"
echo -e "# Tagging image     #"
echo -e "#####################\n"

echo "IMAGE: $IMAGE"
echo "Built $IMAGE"

docker tag $IMAGE tschmidty/$ARCH-addon-snips:$VERSION
docker push tschmidty/$ARCH-addon-snips:$VERSION

docker tag $IMAGE tschmidty/armhf-addon-snips:latest
docker push tschmidty/$ARCH-addon-snips:latest

date

