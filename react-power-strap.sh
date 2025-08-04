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




read -p "Would you like to install Tailwind in your project? y(yes) or n(no): " TAILWIND_USER_INPUT
TAILWIND_OPTION=${TAILWIND_USER_INPUT:-n}

if [ "$TAILWIND_OPTION" = "y" ]; then
  echo "Installing TailwindCSS..."
  npm install tailwindcss @tailwindcss/vite

  VITE_CONFIG="vite.config.ts"
  if [ "$TEMPLATE_CHOSEN" = "js" ]; then
    VITE_CONFIG="vite.config.js"
  fi

  # Add import to the top of vite config if not already present
  if ! grep -q "@tailwindcss/vite" "$VITE_CONFIG"; then
    sed -i '1i import tailwindcss from "@tailwindcss/vite"' "$VITE_CONFIG"
  fi

  # Replace plugins array with tailwindcss() if not already configured
  if grep -q "plugins:" "$VITE_CONFIG"; then
    sed -i '/plugins:/,/]/s/plugins: \[.*\]/plugins: [\n    tailwindcss(), react()\n  ]/' "$VITE_CONFIG"
  else
    echo "WARNING: No plugins array found in $VITE_CONFIG. You may need to add tailwindcss() manually."
  fi

  echo "Adding Tailwind import to index.css..."
  INDEX_CSS="src/index.css"

  if [ -f "$INDEX_CSS" ]; then
    echo "index.css found at $INDEX_CSS"
  else
    echo "index.css NOT FOUND at $INDEX_CSS"
    exit 1
  fi

  if ! grep -q '@import "tailwindcss";' "$INDEX_CSS"; then
    echo "Injecting Tailwind import at top of $INDEX_CSS..."
    awk 'BEGIN { print "@import \"tailwindcss\";" } { print }' "$INDEX_CSS" > "$INDEX_CSS.tmp" && mv "$INDEX_CSS.tmp" "$INDEX_CSS"
  else
    echo "Tailwind import already exists in $INDEX_CSS"
  fi

  if [ "$TEMPLATE_CHOSEN" = "js" ]; then
    APP_FILE="src/App.jsx"
  else
    APP_FILE="src/App.tsx"
  fi

  echo "Adding minimal App component to $APP_FILE"
  cat <<EOF > "$APP_FILE"
function App() {
  return (
    <>
    <h1 class="text-3xl font-bold underline">
    Hello world!
  </h1>
    </>
  );
}

export default App;
EOF

  echo "Starting development server..."
  npm run dev
else
  echo "Tailwind installation skipped."
fi
