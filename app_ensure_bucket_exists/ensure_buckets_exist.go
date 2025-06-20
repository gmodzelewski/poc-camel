package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"strconv"

	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
)

func main() {
	// Load configuration from environment variables
	endpoint := os.Getenv("MINIO_ENDPOINT")
	accessKeyID := os.Getenv("MINIO_ACCESS_KEY")
	secretAccessKey := os.Getenv("MINIO_SECRET_KEY")
	bucketName := os.Getenv("MINIO_BUCKET_NAME")
	useSSLString := os.Getenv("USE_SSL")

	useSSL, err := strconv.ParseBool(useSSLString)
	if err != nil {
		useSSL = true
	}

	if endpoint == "" {
		endpoint = "minio-api-minio.apps.ocp.ocp-gm.de"
	}

	if accessKeyID == "" {
		accessKeyID = "minioadmin"
	}

	if secretAccessKey == "" {
		secretAccessKey = "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG"
	}

	if bucketName == "" {
		bucketName = "tempo"
	}

	// Initialize MinIO client
	minioClient, err := minio.New(endpoint, &minio.Options{
		Creds:  credentials.NewStaticV4(accessKeyID, secretAccessKey, ""),
		Secure: useSSL,
	})
	if err != nil {
		log.Fatalln(err)
	}

	// Ensure the bucket exists
	ctx := context.Background()
	exists, err := minioClient.BucketExists(ctx, bucketName)
	if err != nil {
		log.Fatalln(err)
	}
	if !exists {
		err := minioClient.MakeBucket(ctx, bucketName, minio.MakeBucketOptions{})
		if err != nil {
			log.Fatalln(err)
		}
		fmt.Printf("Bucket %s created successfully.\n", bucketName)
	} else {
		fmt.Printf("Bucket %s already exists. You are safe to start working with them, nothing to see here.\n", bucketName)
	}
}