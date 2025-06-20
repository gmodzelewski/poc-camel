package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
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
	localFilesPath := os.Getenv("SOURCE_DIRECTORY")
	useSSLString := os.Getenv("USE_SSL")

	if localFilesPath == "" {
		localFilesPath = "localfiles" // Default path if not set
	}

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
		bucketName = "usecase5"
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
	}

	// Upload files to S3
	uploadFiles(minioClient, bucketName, localFilesPath)
}

// uploadFiles uploads all files from the specified local directory to the given S3 bucket.
func uploadFiles(minioClient *minio.Client, bucketName, localFilesPath string) {
	err := filepath.Walk(localFilesPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if !info.IsDir() {
			uploadFile(minioClient, bucketName, path)
		}

		return nil
	})
	if err != nil {
		log.Println("Error walking local files:", err)
	}
}

// uploadFile uploads a single file from the local filesystem to the given S3 bucket.
func uploadFile(minioClient *minio.Client, bucketName, filePath string) {
	ctx := context.Background()

	file, err := os.Open(filePath)
	if err != nil {
		log.Println("Error opening file:", err)
		return
	}
	defer file.Close()

	// Get file info
	info, err := file.Stat()
	if err != nil {
		log.Println("Error getting file info:", err)
		return
	}

	// Use the relative file path as the key for S3
	key := filepath.Base(filePath)

	// Upload the file
	_, err = minioClient.PutObject(ctx, bucketName, key, file, info.Size(), minio.PutObjectOptions{})
	if err != nil {
		fmt.Println("Error uploading file to S3:", err)
		return
	}
	fmt.Printf("Successfully uploaded %s to bucket %s\n", key, bucketName)
}
