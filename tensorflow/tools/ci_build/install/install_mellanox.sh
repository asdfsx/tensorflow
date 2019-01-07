#!/usr/bin/env bash
# Copyright 2015 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
#
# Usage:
#     ./install_deb_packages [--without_cmake]
# Pass --without_cmake to prevent cmake from being installed with apt-get

set -e
ubuntu_version=$(cat /etc/issue | grep -i ubuntu | awk '{print $2}' | \
  awk -F'.' '{print $1}')

if [[ "$1" != "" ]] && [[ "$1" != "--without_cmake" ]]; then
  echo "Unknown argument '$1'"
  exit 1
fi

# Install dependencies from ubuntu deb repository.
apt-key adv --keyserver keyserver.ubuntu.com --recv 084ECFC5828AB726
apt-get update

if [[ "$ubuntu_version" == "14" ]]; then
  # specifically for trusty linked from ffmpeg.org
  add-apt-repository -y ppa:mc3man/trusty-media
  apt-get update
  apt-get dist-upgrade -y
fi

apt-get install -y --no-install-recommends \
        perl vim \
        tcsh tcl tk pciutils make lsof \
        lsb-release \
        libnuma1 \
        ethtool iproute net-tools \
        openssh-server \
        pkg-config bison dpatch libgfortran3 \
        kmod linux-headers-generic libnl-route-3-200 \
        swig libelf1 automake libglib2.0-0 \
        autoconf graphviz chrpath flex libnl-3-200 m4 \
        debhelper autotools-dev gfortran libltdl-dev expect

MOFED_VER=4.4-1.0.0.0
OS_VER=ubuntu16.04
PLATFORM=x86_64
wget --quiet http://content.mellanox.com/ofed/MLNX_OFED-${MOFED_VER}/MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}.tgz && \
        tar -xvf MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}.tgz && \
        MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}/mlnxofedinstall --user-space-only --without-fw-update --all --force
