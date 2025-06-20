# go mod init ensure-bucket-exists
# go get github.com/minio/minio-go/v7
# go get github.com/robfig/cron/v3
# oc new-build --name=ensure-bucket-exists --strategy=docker --binary 

# later builds:
# go mod tidy
# oc start-build ensure-bucket-exists --from-dir=.

# local build:
podman build --platform linux/arm64/v8 --platform linux/amd64 -t quay.io/modzelewski/ensure-bucket-exists .
podman push quay.io/modzelewski/ensure-bucket-exists