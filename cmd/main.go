package main

import (
	"log"

	"github.com/SimilarEgs/L0-orders/config"
	"github.com/SimilarEgs/L0-orders/internal/server"
	"github.com/SimilarEgs/L0-orders/nats"
	"github.com/SimilarEgs/L0-orders/pkg/cache"
	"github.com/SimilarEgs/L0-orders/pkg/postgresql"
	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
)

func main() {

	cfg, err := config.ParseConfig()
	if err != nil {
		log.Fatal(err)
	}

	runDBmigration(cfg.MigrationURL, cfg.PostgresSQL.PostgreSource)

	cache.Init()

	var db postgresql.DB
	if err := db.Recover(cfg); err != nil {
		log.Fatalf("[Error] occured while dumping db data to memory cache: %v", err)
	}
	log.Println("[Info] cache was successfully loaded from db")

	sub, err := nats.Subscriber(cfg)
	if err != nil {
		log.Println(err)
	}

	defer sub.Unsubscribe()
	defer sub.Close()

	srv := new(server.Server)

	if err := srv.RunServer(cfg); err != nil {
		log.Fatalf("[Error] failed to start server: %s", err.Error())
	}

}

func runDBmigration(migrationURL string, dbSource string) {
	migration, err := migrate.New(migrationURL, dbSource)
	if err != nil {
		log.Fatalf("[Error] occurred during migration: %v\n", err.Error())
	}

	if err := migration.Up(); err != nil && err != migrate.ErrNoChange {
		log.Fatalf("[Error] occurred during migration up: %v\n", err.Error())
	}

	log.Println("[Info] db migration was successfully done")
}
