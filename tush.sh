#!/bin/bash

#get highest tag number
VERSION=`git describe --abbrev=0 --tags` 

#replace . with space so can split into an array
VERSION_SPLIT=(${VERSION//./ })

#get number parts and increase last one by 1
VNUM1=${VERSION_SPLIT[0]}
VNUM2=${VERSION_SPLIT[1]}
VNUM1=`echo $VNUM1 | sed 's/v//'`

# Check for major or minor in commit message and increment the relevant version number
MAJOR=`git log --format=%B -n 1 HEAD | grep 'major'` 
MINOR=`git log --format=%B -n 1 HEAD | grep 'minor'` 



if [ "$MAJOR" ]; then
    echo "Update major version"
    VNUM1=$((VNUM1+1))
    VNUM2=0
elif [ "$MINOR" ]; then
    echo "Update minor version"
    VNUM2=$((VNUM2+1))
else
    clear	
    echo "ERROR: Mention the version of commit - [major/minor]"
    exit
fi

#create new tag
NEW_TAG="v$VNUM1.$VNUM2"

echo "Updating $VERSION to $NEW_TAG"

#get latest commit and see if it already has a tag
GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GIT_COMMIT`

#tag only if there is no tag already 
if [ -z "$NEEDS_TAG" ]; then
    echo "Tagged with $NEW_TAG (Ignoring fatal:cannot describe)"

git tag $NEW_TAG
git push --tags origin master

else
echo "Tag is alreday given to the latest commit."

fi
