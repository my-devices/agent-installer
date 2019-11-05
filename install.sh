#! /bin/bash
#
# This script will download, build and install the
# macchina.io Remote Manager SDK executables from
# <https://github.com/my-devices/sdk>.
#

function unsupportedPlatform {
  echo "Sorry, your platform is not supported by this script."
  echo "Please install manually by following the instructions"
  echo "at <https://github.com/my-devices/sdk>."
  exit 1
}

echo "Welcome to the macchina.io Remote Manager SDK installer."
echo ""
echo "This script will download, build and install the"
echo "macchina.io Remote Manager SDK executables from"
echo "<https://github.com/my-devices/sdk>."
echo ""

os=`uname`
repo="https://github.com/my-devices/sdk.git"
builddir=/tmp/my-devices-sdk-build.$$
installdir=/usr/local/bin

if [ "$os" = "Darwin" ] ; then
	cmakeOptions="-DOPENSSL_ROOT_DIR=/usr/local/opt/openssl -DOPENSSL_USE_STATIC_LIBS=TRUE"
fi

curlpath=`which curl`
if [ "$curlpath" = "" ] ; then
  echo "curl is required to run this script."
  exit 2
fi

if [ "$os" = "Linux" ] ; then
  if [ -x /usr/bin/apt-get ] ; then
    cmd="apt-get install git g++ cmake libssl-dev"
  elif [ -x /bin/yum ] ; then
    cmd="yum install git gcc-c++ cmake openssl-devel"
  fi
  if [ "$cmd" != "" ] ; then
    echo "Installing dependencies (git, g++, cmake, openssl)."
    echo "About to run $cmd"
    echo "Please provide your sudo password when prompted."
  else
    unsupportedPlatform
  fi
elif [ "$os" = Darwin ] ; then
  if [ -x /usr/local/bin/brew ] ; then
    if [ -x /usr/bin/clang ] ; then
      echo "Installing dependencies (cmake, openssl) using Homebrew."
      brew install cmake openssl
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
cmake .. $cmakeOptions
if [ $? -ne 0 ] ; then
	echo "Failed to configure CMake build. Exiting."
	exit 5
fi
cmake --build . --config Release
if [ $? -ne 0 ] ; then
	echo "Failed to build project. Exiting."
	exit 5
fi

echo "Copying executables to $installdir..."
echo "Please provide your sudo password when prompted."
find . -name 'WebTunnel*' -type f -perm 755 -exec sudo cp {} $installdir \;
if [ $? -ne 0 ] ; then
	echo "Failed to install agent executable. Exiting."
	exit 6
fi

cd $basedir
echo "Executables successfully installed. Removing build directory $builddir..."
rm -rf $builddir
echo ""
echo "Completed."

