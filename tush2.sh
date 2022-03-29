#!/bin/sh

# retrieve branch name
BRANCH_NAME=$(git branch | sed -n '/\* /s///p')

# remove prefix release
REGEXP_RELEASE="release\/"
VERSION_BRANCH=$(echo "$BRANCH_NAME" | sed "s/$REGEXP_RELEASE//") 

echo "Current version branch is $VERSION_BRANCH"

# retrieve the last commit on the branch
VERSION=$(git describe --tags --match=$VERSION_BRANCH* --abbrev=0)

# split into array
VERSION_BITS=(${VERSION//./ })

#get number parts and increase last one by 1
VNUM1=${VERSION_BITS[0]}
VNUM2=${VERSION_BITS[1]}
VNUM3=${VERSION_BITS[2]}
VNUM3=$((VNUM3+1))

#create new tag
NEW_TAG="$VNUM1.$VNUM2.$VNUM3"

echo "Updating $VERSION to $NEW_TAG"

#get current hash and see if it already has a tag
GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GIT_COMMIT`

#only tag if no tag already (would be better if the git describe command above could have a silent option)
if [ -z "$NEEDS_TAG" ]; then
    echo "Tagged with $NEW_TAG (Ignoring fatal:cannot describe - this means commit is untagged) "
    git tag $NEW_TAG
    git push --tags
else
    echo "Already a tag on this commit"

fi    
