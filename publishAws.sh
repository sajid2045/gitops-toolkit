docker build -f Dockerfile-ccloud -t sajid2045/ccloud .

docker tag sajid2045/ccloud  711866164579.dkr.ecr.ap-southeast-2.amazonaws.com/foxsports/gitops-toolkit:latest

docker push 711866164579.dkr.ecr.ap-southeast-2.amazonaws.com/foxsports/gitops-toolkit:latest


