TAG="chaudhryfaisal/alpine-minikube"
docker build -t $TAG . && docker run -P -ti --privileged $TAG bash && docker push $TAG
