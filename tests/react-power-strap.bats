#!/usr/bin/env bats

# Constants
PROJECT_NAME="test-project"

setup() {
  rm -rf "$PROJECT_NAME"
}

teardown() {
  rm -rf "$PROJECT_NAME"
}

# Helper to simulate script input
run_script_with_input() {
  local input="$1"
  echo -e "$PROJECT_NAME\n$input" | bash react-power-strap.sh
}

@test "creates a new Vite project directory (TS template)" {
  run run_script_with_input "ts"
  [ -d "$PROJECT_NAME" ]
}

@test "installs node_modules and required files (TS template)" {
  run run_script_with_input "ts"
  [ -d "$PROJECT_NAME/node_modules" ]
  [ -f "$PROJECT_NAME/package.json" ]
  [ -f "$PROJECT_NAME/vite.config.ts" ]
  [ -f "$PROJECT_NAME/tsconfig.json" ]
}

@test "clears content of App.tsx, App.css, and index.css (TS template)" {
  run run_script_with_input "ts"
  [ -f "$PROJECT_NAME/src/App.tsx" ] && [ ! -s "$PROJECT_NAME/src/App.tsx" ]
  [ -f "$PROJECT_NAME/src/App.css" ] && [ ! -s "$PROJECT_NAME/src/App.css" ]
  [ -f "$PROJECT_NAME/src/index.css" ] && [ ! -s "$PROJECT_NAME/src/index.css" ]
}

@test "creates src/pages and src/components directories (TS template)" {
  run run_script_with_input "ts"
  [ -d "$PROJECT_NAME/src/pages" ]
  [ -d "$PROJECT_NAME/src/components" ]
}

@test "creates a new Vite project directory (JS template)" {
  run run_script_with_input "js"
  [ -d "$PROJECT_NAME" ]
}

@test "installs node_modules and required files (JS template)" {
  run run_script_with_input "js"
  [ -d "$PROJECT_NAME/node_modules" ]
  [ -f "$PROJECT_NAME/package.json" ]
  [ -f "$PROJECT_NAME/vite.config.js" ]
  [ -f "$PROJECT_NAME/src/App.jsx" ]
}

@test "clears content of App.jsx, App.css, and index.css (JS template)" {
  run run_script_with_input "js"
  [ -f "$PROJECT_NAME/src/App.jsx" ] && [ ! -s "$PROJECT_NAME/src/App.jsx" ]
  [ -f "$PROJECT_NAME/src/App.css" ] && [ ! -s "$PROJECT_NAME/src/App.css" ]
  [ -f "$PROJECT_NAME/src/index.css" ] && [ ! -s "$PROJECT_NAME/src/index.css" ]
}

@test "creates src/pages and src/components directories (JS template)" {
  run run_script_with_input "js"
  [ -d "$PROJECT_NAME/src/pages" ]
  [ -d "$PROJECT_NAME/src/components" ]
}
