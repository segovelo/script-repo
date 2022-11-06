#! /bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/../git_credentials.sh"
repoName=$1

while [ -z "$repoName" ]
do
   echo 'Provide a repository name'
   read -r -p $'Repository name:' repoName
done

if [ ! -d "$repoName" ]
then
    echo "Repository doesn't exist. Creating now"
    mkdir $repoName
    cd $repoName

    echo "# $repoName" >> README.md
    echo "Repository created remotely using Bash script https://github.com/segovelo/script-repo.  This script creates README.md file, initialize a .git repository, commit create remote repo and push to https://www.github.com" >> README.md

    git init
    git add .
    git commit -am "Initial commit"
    curl -u $user:$password https://api.github.com/user/repos -d '{"name": "'"$repoName"'", "private":false}'

    GIT_URL=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/"$user/$repoName" | jq -r '.clone_url')

    git branch -M main
    git remote add origin $GIT_URL
    git push -u origin main
    echo "Repository $repoName created, finished..."
else
    echo "Repository already exists, finished..."
fi