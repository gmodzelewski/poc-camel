package main

import (
	"database/sql"
	"fmt"
	"log"
	"math/rand"  // Import the rand package
	"os"
	"time"

	_ "github.com/lib/pq" // PostgreSQL driver
)

func main() {
	// Get environment variables for DB connection
	dbHost := os.Getenv("DB_HOST")
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME") 
    dbTable := os.Getenv("DB_TABLE") 

	// Connection string without specifying a database to check and create the database if it doesn't exist
	connStr := fmt.Sprintf("host=%s user=%s password=%s sslmode=disable", dbHost, dbUser, dbPassword)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Create the database if it doesn't exist
	createDatabaseIfNotExists(db, dbName)

	// Now connect to the newly ensured database
	connStr = fmt.Sprintf("host=%s dbname=%s user=%s password=%s sslmode=disable", dbHost, dbName, dbUser, dbPassword)
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Ensure the table exists
	createTableIfNotExists(db, dbTable)

	// Insert random data into the database
	insertRandomData(db, dbTable)
}

// createDatabaseIfNotExists checks if the database exists and creates it if it doesn't
func createDatabaseIfNotExists(db *sql.DB, dbName string) {
	// Check if the database exists
	var exists bool
	query := fmt.Sprintf("SELECT EXISTS(SELECT datname FROM pg_catalog.pg_database WHERE datname = '%s')", dbName)
	err := db.QueryRow(query).Scan(&exists)
	if err != nil {
		log.Fatalf("Failed to check if database exists: %v", err)
	}

	if !exists {
		// Create the database
		_, err := db.Exec(fmt.Sprintf("CREATE DATABASE %s", dbName))
		if err != nil {
			log.Fatalf("Failed to create database: %v", err)
		}
		fmt.Printf("Database %s created successfully.\n", dbName)
	} else {
		fmt.Printf("Database %s already exists.\n", dbName)
	}
}

// createTableIfNotExists checks if the table exists and creates it if it doesn't
func createTableIfNotExists(db *sql.DB, tableName string) {
	query := fmt.Sprintf(`
        CREATE TABLE IF NOT EXISTS %s (
            id SERIAL NOT NULL,
            timestamp TIMESTAMPTZ NOT NULL,
            accountnumber VARCHAR(20) NOT NULL,
            amount NUMERIC(10, 2) NOT NULL,
            CONSTRAINT transactions_pk PRIMARY KEY (id)
        );`, tableName)

	_, err := db.Exec(query)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}
	fmt.Printf("Ensured table %s exists.\n", tableName)
}

// insertRandomData inserts random data into the specified table
func insertRandomData(db *sql.DB, tableName string) {
	for i := 0; i < 100; i++ { // Insert 100 random entries
		// Generate random timestamp within the last year
		now := time.Now()
		randomTime := now.Add(time.Duration(-rand.Intn(365*24)) * time.Hour) // Random time within the last year

		// Generate random account number (example: a 10-digit number)
		accountNumber := fmt.Sprintf("%010d", rand.Intn(10000000000))

		// Generate random amount (example: a random float between 1 and 1000)
		amount := rand.Float64()*999 + 1

		query := fmt.Sprintf("INSERT INTO %s (timestamp, accountnumber, amount) VALUES ($1, $2, $3)", tableName)
		_, err := db.Exec(query, randomTime, accountNumber, amount)
		if err != nil {
			log.Println("Error inserting data:", err)
		}
	}

	fmt.Println("100 random entries inserted into the database.")
}