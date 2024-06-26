#! /bin/bash
#
# This script will download, build and install the
# macchina.io REMOTE SDK executables from
# <https://github.com/my-devices/sdk>.
#

function unsupportedPlatform {
  echo "Sorry, your platform is not supported by this script."
  echo "Please install manually by following the instructions"
  echo "at <https://github.com/my-devices/sdk>."
  exit 1
}

function main {
  echo ""
  echo "##"
  echo "##"
  echo "##  Welcome to the macchina.io REMOTE Device Agent and Client Utilities Installer."
  echo "##"
  echo "##"
  echo ""
  echo "This script will download, build and install the macchina.io REMOTE device agent"
  echo "(WebTunnelAgent) and client command-line tools (remote-client, remote-ssh,"
  echo "remote-scp, remote-sftp, remote-rdp, remote-vnc)"
  echo "from <https://github.com/my-devices/sdk>."
  echo ""
  
  os=`uname`
  repo="https://github.com/my-devices/sdk.git"
  builddir=/tmp/my-devices-sdk-build.$$
  agent_installdir=/usr/local/sbin
  client_installdir=/usr/local/bin
  CMAKE=cmake
  
  if [ "$os" = "Darwin" ] ; then
  	cmakeOptions="-DOPENSSL_ROOT_DIR=/usr/local/opt/openssl@3 -DOPENSSL_USE_STATIC_LIBS=TRUE"
  fi
  
  curlpath=`which curl`
  if [ "$curlpath" = "" ] ; then
    echo "curl is required to run this script."
    exit 2
  fi
  
  if [ "$os" = "Linux" ] ; then
    if [ -x /usr/bin/apt-get ] ; then
      cmd="sudo apt-get -y update && sudo apt-get -y install git g++ make cmake libssl-dev libz-dev"
    elif [ -x /bin/yum ] ; then
      cmd="sudo yum install -y git gcc-c++ make cmake3 openssl-devel"
      CMAKE=cmake3
    fi
    if [ "$cmd" != "" ] ; then
      echo "Installing dependencies (git, g++, make, cmake, openssl)."
      echo "About to run $cmd"
      echo "Please provide your sudo password when prompted."
      sh -c "$cmd"
    else
      unsupportedPlatform
    fi
  elif [ "$os" = Darwin ] ; then
    if [ -x "`which brew`" ] ; then
      if [ -x /usr/bin/clang ] ; then
        echo "Installing dependencies (cmake, openssl) using Homebrew."
        brew install cmake openssl@3
      else
        echo "Please install the Xcode command-line tools before"
        echo "running this script."
        exit 1
      fi
    else
      echo "Please install Homebrew before running this script."
      echo "See <https://brew.sh> for more information."
      exit 1
    fi
  else
    unsupportedPlatform
  fi
  
  echo "Done installing dependencies."
  echo ""
  echo "Downloading sources from GitHub to $builddir..."
  
  if [ -d $builddir ] ; then
    echo "Directory $builddir already exists."
    echo "Please manually remove the directory and try again."
    exit 2
  fi
  
  mkdir -p $builddir
  if [ $? -ne 0 ] ; then
    echo "Failed to create directory $builddir. Exiting."
    exit 3
  fi
  
  basedir=`pwd`
  cd $builddir
  git clone https://github.com/my-devices/sdk.git
  if [ $? -ne 0 ] ; then
  	echo "Failed to clone GitHub repository. Exiting."
  	exit 4
  fi
  
  echo "Configuring and building SDK..."
  cd sdk
  mkdir cmake-build
  if [ $? -ne 0 ] ; then
  	echo "Failed to create cmake-build directory. Exiting."
  	exit 4
  fi
  cd cmake-build
  $CMAKE .. $cmakeOptions
  if [ $? -ne 0 ] ; then
  	echo "Failed to configure CMake build. Exiting."
  	exit 5
  fi
  $CMAKE --build . --config Release -- -j2
  if [ $? -ne 0 ] ; then
  	echo "Failed to build project. Exiting."
  	exit 5
  fi
  
  echo "Build completed."
  echo ""
  echo "Copying device agent executable to $agent_installdir..."
  echo "Copying client executables to $client_installdir..."
  echo "Please provide your sudo password when prompted."
  sudo install -d $agent_installdir
  find ./bin -name 'WebTunnelAgent' -type f -perm -755 -exec strip {} \; -exec sudo install -c {} $agent_installdir \;
  if [ $? -ne 0 ] ; then
  	echo "Failed to install agent executable. Exiting."
  	exit 6
  fi
  sudo install -d $client_installdir
  find ./bin -name 'remote-*' -type f -perm -755 -exec strip {} \; -exec sudo install -c {} $client_installdir \;
  if [ $? -ne 0 ] ; then
  	echo "Failed to install client executables. Exiting."
  	exit 6
  fi
  
  cd $basedir
  echo "Executables successfully installed. Removing build directory $builddir..."
  rm -rf $builddir
  
  echo ""
  echo "Completed."
  echo "Thank you for installing the macchina.io REMOTE Device Agent and Client Utilities."
}

main
