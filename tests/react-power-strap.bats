#!/usr/bin/env bats

# Constants
PROJECT_NAME="test-project"

setup() {
  rm -rf "$PROJECT_NAME"
}

teardown() {
  rm -rf "$PROJECT_NAME"
}

# Helper to run the script with the desired project name
run_script() {
  PROJECT_NAME="$PROJECT_NAME" bash react-power-strap.sh
}

@test "creates a new Vite project directory" {
  run run_script
  [ -d "$PROJECT_NAME" ]
}

@test "installs node_modules and required files" {
  run run_script
  [ -d "$PROJECT_NAME/node_modules" ]
  [ -f "$PROJECT_NAME/package.json" ]
  [ -f "$PROJECT_NAME/vite.config.ts" ]
  [ -f "$PROJECT_NAME/tsconfig.json" ]
}

@test "clears content of App.tsx, App.css, and index.css" {
  run run_script
  [ -f "$PROJECT_NAME/src/App.tsx" ] && [ ! -s "$PROJECT_NAME/src/App.tsx" ]
  [ -f "$PROJECT_NAME/src/App.css" ] && [ ! -s "$PROJECT_NAME/src/App.css" ]
  [ -f "$PROJECT_NAME/src/index.css" ] && [ ! -s "$PROJECT_NAME/src/index.css" ]
}

@test "creates src/pages and src/components directories" {
  run run_script
  [ -d "$PROJECT_NAME/src/pages" ]
  [ -d "$PROJECT_NAME/src/components" ]
}

