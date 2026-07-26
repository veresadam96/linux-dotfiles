#!/usr/bin/env sh
nvim_java="$HOME/.local/share/nvim/java";

mkdir -p "$nvim_java/workspaces";

cp -r "$HOME/work/.meta/nvim/java"/lombok*.jar "$nvim_java";

tar -xvf "$HOME/work/.meta/nvim/java"/jdtls-*.tar.gz -C "$nvim_java" --one-top-level;
tar -xvf "$HOME/work/.meta/nvim/java"/java-debug-*.tar.gz -C "$nvim_java";

pwd="$(pwd)";
cd "$nvim_java"/java-debug-* || exit;
JAVA_HOME=/usr/lib/jvm/java-21-openjdk ./mvnw clean install;
cd "$pwd" || exit;
