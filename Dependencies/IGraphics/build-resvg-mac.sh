#!/bin/sh

cd ../Build/src/resvg

SKIA_DIR=/Users/oli/Dev/MyPlugins/Dependencies/Build/src/skia/ SKIA_LIB_DIR=/Users/oli/Dev/MyPlugins/Dependencies/Build/mac/lib cargo build --release --features "skia-backend cairo-backend"

cd capi

if [ -d .cargo ]; then
  rm -r .cargo
fi

echo ---------------------------------
mkdir .cargo
echo [build] > .cargo/config
echo rustflags = [\"-L/Users/oli/Dev/MyPlugins/Dependencies/Build/mac/lib\", \"-ldylib=pixman-1\", \"-lframework=Metal\", \"-lframework=Foundation\"] >> .cargo/config
export MACOSX_DEPLOYMENT_TARGET=10.9
SKIA_DIR=/Users/oli/Dev/MyPlugins/Dependencies/Build/src/skia/ SKIA_LIB_DIR=/Users/oli/Dev/MyPlugins/Dependencies/Build/mac/lib cargo build --verbose --release --features "skia-backend cairo-backend"
cd ..
sed -i.bak s/"#include <cairo.h>"/"#include <cairo\/cairo.h>"/g capi/include/resvg.h
cp capi/include/resvg.h ../../mac/include/resvg.h 
mv target/release/libresvg.a ../../mac/lib