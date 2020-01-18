#!/usr/bin/env bash
set -ex

OPENCV_VERSION=4.2.0
pushd ~/opencv/opencv-$OPENCV_VERSION
mkdir -p build
pushd build
MEM="$(free -m | awk /Mem:/'{print $2}')"  # Total memory in MB
NUM_JOBS=4

# -D ENABLE_PRECOMPILED_HEADERS=OFF
# is a fix for https://github.com/opencv/opencv/issues/14868

# -D OPENCV_EXTRA_EXE_LINKER_FLAGS=-latomic
# is a fix for https://github.com/opencv/opencv/issues/15192

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-$OPENCV_VERSION/modules \
      -D OPENCV_ENABLE_NONFREE=ON \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_DOCS=ON \
      -D BUILD_EXAMPLES=OFF \
      -D ENABLE_PRECOMPILED_HEADERS=OFF \
      -D WITH_TBB=ON \
      -D WITH_OPENMP=ON \
      -D OPENCV_EXTRA_EXE_LINKER_FLAGS=-latomic \
      -D PYTHON3_EXECUTABLE=$(which python3) \
      -D PYTHON_EXECUTABLE=$(which python2) \
      -D BUILD_SHARED_LIBS=ON \
      ..
make -j "$NUM_JOBS"
popd; popd
