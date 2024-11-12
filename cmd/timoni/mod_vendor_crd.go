/*
Copyright 2023 Stefan Prodan

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"net/http"
	"os"
	"path"
	"sort"
	"strings"

	"cuelang.org/go/cue/cuecontext"
   "cuelang.org/go/cue/interpreter/embed"
	ssautil "github.com/fluxcd/pkg/ssa/utils"
	"github.com/hashicorp/go-cleanhttp"
	"github.com/spf13/cobra"
	"sigs.k8s.io/yaml"

	"github.com/stefanprodan/timoni/internal/engine"
	"github.com/stefanprodan/timoni/internal/logger"
)

var vendorCrdCmd = &cobra.Command{
	Use:     "crd [MODULE PATH]",
	Aliases: []string{"crds"},
	Short:   "Vendor Kubernetes CRD CUE schemas",
	Example: `  # Vendor CUE schemas generated from Kubernetes CRDs included in a local YAML file
  timoni mod vendor crd -f crds.yaml

  # Vendor CUE schemas generated from Kubernetes CRDs included in a remote YAML file
  timoni mod vendor crd -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml
`,
	RunE: runVendorCrdCmd,
}

type vendorCrdFlags struct {
	modRoot string
	crdFile string
}

var vendorCrdArgs vendorCrdFlags

func init() {
	vendorCrdCmd.Flags().StringVarP(&vendorCrdArgs.crdFile, "file", "f", "",
		"The path to Kubernetes CRD YAML.")

	modVendorCmd.AddCommand(vendorCrdCmd)
}

const header = `// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f `

func runVendorCrdCmd(cmd *cobra.Command, args []string) error {
	if len(args) > 0 {
		vendorCrdArgs.modRoot = args[0]
	}

	log := LoggerFrom(cmd.Context())
	cuectx := cuecontext.New(cuecontext.Interpreter(embed.New()))

	// Make sure we're importing into a CUE module.
	cueModDir := path.Join(vendorCrdArgs.modRoot, "cue.mod")
	if fs, err := os.Stat(cueModDir); err != nil || !fs.IsDir() {
		return fmt.Errorf("cue.mod not found in the module path %s", vendorCrdArgs.modRoot)
	}

	spin := logger.StartSpinner("importing schemas")
	defer spin.Stop()

	// Load the YAML manifest into memory either from disk or by fetching the file over HTTPS.
	var crdData []byte
	if strings.HasPrefix(vendorCrdArgs.crdFile, "https://") {
		req, err := http.NewRequest("GET", vendorCrdArgs.crdFile, nil)
		if err != nil {
			return fmt.Errorf("failed to create HTTP request for %s, error: %w", vendorCrdArgs.crdFile, err)
		}

		hctx, cancel := context.WithTimeout(context.Background(), rootArgs.timeout)
		defer cancel()

		resp, err := cleanhttp.DefaultClient().Do(req.WithContext(hctx))
		if err != nil {
			return fmt.Errorf("failed to download manifest from %s, error: %w", vendorCrdArgs.crdFile, err)
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			return fmt.Errorf("failed to download manifest from %s, status: %s", vendorCrdArgs.crdFile, resp.Status)
		}

		crdData, err = io.ReadAll(resp.Body)
		if err != nil {
			return fmt.Errorf("failed to download manifest from %s, error: %w", vendorCrdArgs.crdFile, err)
		}
	} else {
		if fs, err := os.Stat(vendorCrdArgs.crdFile); err != nil || !fs.Mode().IsRegular() {
			return fmt.Errorf("path not found: %s", vendorCrdArgs.crdFile)
		}

		f, err := os.Open(vendorCrdArgs.crdFile)
		if err != nil {
			return err
		}

		crdData, err = io.ReadAll(f)
		if err != nil {
			return err
		}
	}

	// Extract the Kubernetes CRDs from the multi-doc YAML.
	var builder strings.Builder
	objects, err := ssautil.ReadObjects(bytes.NewReader(crdData))
	if err != nil {
		return fmt.Errorf("parsing CRDs failed: %w", err)
	}
	for _, object := range objects {
		if object.GetKind() == "CustomResourceDefinition" {
			builder.WriteString("---\n")
			data, err := yaml.Marshal(object)
			if err != nil {
				return fmt.Errorf("marshaling CRD failed: %w", err)
			}
			builder.Write(data)
		}
	}

	// Generate the CUE definitions from the given CRD YAML.
	imp := engine.NewImporter(cuectx, fmt.Sprintf("%s%s", header, vendorCrdArgs.crdFile))
	crds, err := imp.Generate([]byte(builder.String()))
	if err != nil {
		return err
	}

	// Sort the resulting definitions based on file names.
	keys := make([]string, 0, len(crds))
	for k := range crds {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	spin.Stop()

	// Write the definitions to the module's 'cue.mod/gen' dir.
	for _, k := range keys {
		log.Info(fmt.Sprintf("schemas vendored: %s", logger.ColorizeSubject(k)))

		dstDir := path.Join(cueModDir, "gen", k)
		if err := os.MkdirAll(dstDir, os.ModePerm); err != nil {
			return err
		}

		if err := os.WriteFile(path.Join(dstDir, "types_gen.cue"), crds[k], 0644); err != nil {
			return err
		}
	}

	return nil
}
