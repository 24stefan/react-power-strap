#!/bin/bash

# Users can now choose name of their project
read -p "Enter your project name (default: front-end): " USER_INPUT
PROJECT_NAME=${USER_INPUT:-front-end}

# Users can now choose their template
read -p "Enter ts (react + ts) or js (react + js) - default: ts: " TEMPLATE_INPUT
TEMPLATE_CHOSEN=${TEMPLATE_INPUT:-ts}

if [ "$TEMPLATE_CHOSEN" = "js" ]; then
  VITE_TEMPLATE="react"
else
  VITE_TEMPLATE="react-ts"
fi


if [ ! -d "$PROJECT_NAME" ]; then
  echo "Creating new Vite React project with template '$VITE_TEMPLATE'..."
  npm create vite@latest "$PROJECT_NAME" -- --template "$VITE_TEMPLATE"
else
  echo "Project '$PROJECT_NAME' already exists."
fi

cd "$PROJECT_NAME"

echo "Installing dependencies..."
npm install

# Use different required files based on template
if [ "$TEMPLATE_CHOSEN" = "js" ]; then
  REQUIRED_FILES=("package.json" "vite.config.js" "src/App.jsx")
else
  REQUIRED_FILES=("package.json" "vite.config.ts" "tsconfig.json" "src/App.tsx")
fi

for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing $file. Something went wrong. Reinstalling..."
    rm -rf node_modules package-lock.json
    npm install
    break
  fi
done

# Reset appropriate files
if [ "$TEMPLATE_CHOSEN" = "js" ]; then
  > src/App.jsx
else
  > src/App.tsx
fi

> src/App.css
> src/index.css

echo "Creating src/pages and src/components directories..."
mkdir -p src/pages src/components

echo "Setup complete. Yippie!"
