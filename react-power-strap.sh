#!/bin/bash

set -e

PROJECT_NAME=${PROJECT_NAME:-front-end}
if [ ! -d "$PROJECT_NAME" ]; then
  echo "Creating new Vite React TypeScript project..."
  npm create vite@latest "$PROJECT_NAME" -- --template react-ts
else
  echo "Project '$PROJECT_NAME' already exists."
fi


cd "$PROJECT_NAME"
echo "Installing dependencies..."
npm install

REQUIRED_FILES=("package.json" "vite.config.ts" "tsconfig.json" "src/App.tsx")
for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing $file. Something went wrong. Reinstalling..."
    rm -rf node_modules package-lock.json
    npm install
    break
  fi
done


echo "Resetting contents of App.tsx, App.css, and index.css..."
> src/App.tsx
> src/App.css
> src/index.css


echo "Creating src/pages and src/components directories..."
mkdir -p src/pages src/components

echo "Project setup complete."
