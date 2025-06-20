# go mod init fill-db
# go get github.com/lib/pq
# oc new-build --name=fill-db --strategy=docker --binary

# later builds:
# go mod tidy 
oc start-build fill-db --from-dir=.

# local build
podman build --platform linux/arm64/v8 --platform linux/amd64 -t quay.io/modzelewski/fill-db .