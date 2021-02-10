# Personal Alias
alias pc='cd ~/workspace/pchoi'
alias d='docker'
alias dc='docker-compose'

# Github Token
# export GITHUB_TOKEN=

# AWS
# STAGING_AWS_ACCESS_KEY_ID=
# STAGING_AWS_SECRET_ACCESS_KEY=
# alias aws-staging='
#  export AWS_ACCESS_KEY_ID=$STAGING_AWS_ACCESS_KEY_ID;
#  export AWS_SECRET_ACCESS_KEY=$STAGING_AWS_SECRET_ACCESS_KEY;
#  export AWS_ACCESS_KEY=$STAGING_AWS_ACCESS_KEY_ID;
#  export AWS_ACCESS_SECRET=$STAGING_AWS_SECRET_ACCESS_KEY;
#  export AMAZON_ACCESS_KEY_ID=$STAGING_AWS_ACCESS_KEY_ID;
#  export AMAZON_SECRET_ACCESS_KEY=$STAGING_AWS_SECRET_ACCESS_KEY;
#'

# Go environment
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

function git-tag-next {
    if [ `git rev-parse --abbrev-ref HEAD` != "master" ]; then
      echo "Checkout master branch before tagging";
      return 1;
    fi
    PREV_TAG=`git describe | cut -d '-' -f 1`;
    TAG_PREFIX=`echo $PREV_TAG | sed -e 's/[0-9][0-9]*$//'`;
    CURR_TAG=`echo $PREV_TAG | sed -e 's/^[^0-9]*//'`;
    if [ -z $CURR_TAG ]; then
        echo "Can not parse tag!";
        return 1;
    fi;
    NEW_TAG=$(( $CURR_TAG + 1 ));
    NEW_TAG="${TAG_PREFIX}${NEW_TAG}";
    echo "Bumping tag from ${PREV_TAG} -> ${NEW_TAG}";
    MSG="$1";
    if [ -z "$MSG" ]; then
        MSG=$NEW_TAG;
    fi;
    git tag -a $NEW_TAG -m "${MSG}";
    # git push origin ${NEW_TAG}
}

function git-sweep-remote {
  git remote prune origin
  git branch --remotes --merged master | sed "s/  origin\///" | \
    grep --color=auto -v 'master' | xargs -n 1 -I '{}' -t git push origin :{}
}
