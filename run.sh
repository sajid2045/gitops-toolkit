#docker build -tdevops-toolkit-sceptre .


if [ -z "$AWS_PROFILE" ]
then
      echo "must have AWS_PROFILE environment variable set"
      exit 1
else
      echo "going to switch aws profile to $AWS_PROFILE ! [$AWS_PROFILE] must be defined in your ~/.aws/config"
fi

VOL_MOUNT=$(pwd)
if [ -z "$1" ]
then
      echo "using $(pwd) as source mount"
else 
      echo "using $1 as source mount"
      VOL_MOUNT=$1
fi

docker run -it --rm -v ~/.aws/:/root/.aws   -v $VOL_MOUNT:/src/  -e AWS_PROFILE=$AWS_PROFILE  \
-e AWS_DEFAULT_REGION=ap-southeast-2  sajid2045/gitops-toolkit /bin/bash

