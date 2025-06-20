# go mod init fill-bucket
# go get github.com/minio/minio-go/v7
# go get github.com/robfig/cron/v3
# oc new-build --name=fill-bucket --strategy=docker --binary 

# later builds:
# go mod tidy
# oc start-build fill-bucket --from-dir=.

# local build:
podman build --platform linux/arm64/v8 --platform linux/amd64 -t quay.io/modzelewski/fill-bucket .
podman push quay.io/modzelewski/fill-bucket