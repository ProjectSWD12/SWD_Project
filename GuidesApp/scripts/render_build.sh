set -euo pipefail

if [ ! -d flutter ]; then
  git clone --depth 1 https://github.com/flutter/flutter.git -b stable
fi

export PATH="$PATH:$(pwd)/flutter/bin"

flutter pub get
flutter build web