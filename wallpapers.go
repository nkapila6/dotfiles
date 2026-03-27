package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"sync"
)

const (
	BaseURL        = "https://archimg.cc"
	AssetsManifest = BaseURL + "/image-manifest.txt"
	AssetsBaseURL  = BaseURL + "/assets/"
)

var LocalPath = "~/wallpapers"

func expandTilde(path string) (string, error) {
	if !strings.HasPrefix(path, "~") {
		return path, nil
	}

	home, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}

	if path == "~" {
		return home, nil
	}

	// Handle ~/something
	return filepath.Join(home, path[2:]), nil
}

func init() {
	var err error
	// expand the tilde to the home directory
	LocalPath, err = expandTilde(LocalPath)
	if err != nil {
		log.Fatal(err)
	}

	// create the directory if it doesn't exist
	err = os.MkdirAll(LocalPath, 0o755)
	if err != nil {
		log.Fatal(err)
	}
}

func fetchAssets() {
	resp, err := http.Get(AssetsManifest)
	if err != nil {
		log.Fatal(err)
	}
	defer func() {
		err := resp.Body.Close()
		if err != nil {
			log.Fatal(err)
		}
	}()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}

	// create the directory if it doesn't exist
	err = os.MkdirAll(LocalPath, 0o755)
	if err != nil {
		log.Fatal(err)
	}

	wg := new(sync.WaitGroup)

	// loop through the lines of the manifest file
	for line := range strings.SplitSeq(string(body), "\n") {
		line = strings.TrimSpace(line)
		if line == "" || (!strings.HasSuffix(line, ".png") && !strings.HasSuffix(line, ".jpg")) {
			continue
		}
		wg.Add(1)
		go func(line string) {
			defer wg.Done()
			fmt.Printf("Saving %s to disk\n", line)
			err := downloadAsset(line)
			if err != nil {
				log.Fatal(err)
			}
			fmt.Printf("Saved %s\n", line)
		}(line)
	}
	wg.Wait()
}

func downloadAsset(line string) error {
	resp, err := http.Get(AssetsBaseURL + line)
	if err != nil {
		return err
	}

	defer func() {
		err := resp.Body.Close()
		if err != nil {
			log.Fatal(err)
		}
	}()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return err
	}

	// write the file to disk
	err = os.WriteFile(LocalPath+"/"+line, body, 0o644)
	if err != nil {
		return err
	}

	return nil
}

func main() {
	fetchAssets()
}
