#!/bin/sh

# MIT License

# Copyright (c) 2021 Ybrid®, a Hybrid Dynamic Live Audio Technology
# Modified 2021 by Johannes Kreutz

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# 
# Generates fat libopus.a for iOS and for macOS.
# 
# Preconditions: 
# - clang installed
# - git clone of https://github.com/xiph/opus in directory ../opus
# - checked iosSDKVersion and osxSDKVersion 

set -e

iosSDKVersion="15.4"
osxSDKVersion="12.3"
opusVersion="1.3.1"
opusDownload="https://github.com/xiph/opus/archive/refs/tags/v$opusVersion.tar.gz"
here=$(pwd)

rm -f `basename $opusDownload`
wget $opusDownload

libopusDir="opus-$opusVersion" 
rm -rf $libopusDir
tar -xvzf `basename $opusDownload`
echo "opus sources ready in $libopusDir" 
echo "\n==========================="


opuspath="$here/$libopusDir"
opusArtifact=.libs/libopus.a
opusHeaders="$opuspath/include"

tmp=./prepare
fatLibsDest=opus-swift/libs/

generateLibopus()
{
    host=$1
    arch=$2
    sdk=$3

    sdkname=`basename $sdk | sed "s/[0-9\.]*\.sdk$//"` # stripping path, version and '.sdk'
    product="libopus_${host}_${arch}_$sdkname.a"
    echo "\n----------------------------"
    echo "generating $tmp/$product ...\n"

    logfile="$here/$tmp/generate_${host}_${arch}_$sdkname.log"

    cd $opuspath
    
    if [[ $sdkname =~ "iPhone" ]]; then 
        minversion="-miphoneos-version-min=12.4"
    else # contains "Mac"
        minversion="-mmacosx-version-min=10.15"
    fi
    #cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CFLAGS=" -arch $arch -Ofast -flto -g -fPIE $minversion -isysroot $sdk" -DCMAKE_LDFLAGS=" -flto -fPIE $minversion" -DCMAKE_SYSTEM_NAME=$host .
    ./autogen.sh
    ./configure CC=clang --enable-float-approx --disable-shared --enable-static --with-pic \
        --disable-extra-programs --disable-doc --host=$host \
        CFLAGS=" -arch $arch -Ofast -flto -g -fPIE $minversion -isysroot $sdk" \
        LDFLAGS=" -flto -fPIE $minversion" >> $logfile

    make -j >> $logfile

    cd $here
    cp "$opuspath/$opusArtifact" "$tmp/$product"
    echo "generated $product, see $logfile\n"
    lipo -i "$tmp/$product"
}

xcodePlatforms="/Applications/Xcode.app/Contents/Developer/Platforms"
sdkSimulator="$xcodePlatforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator$iosSDKVersion.sdk"
sdkPhone="/$xcodePlatforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS$iosSDKVersion.sdk"
sdkMac="/$xcodePlatforms/MacOSX.platform/Developer/SDKs/MacOSX$osxSDKVersion.sdk"

cd $opuspath
cd $here
rm -rf $tmp
mkdir -p $tmp


fatProductIos="libopus_ios.a"
echo "\n==========================="
echo "generate $fatProductIos ..."
generateLibopus "x86_64-apple-darwin" "x86_64" $sdkSimulator
generateLibopus "arm-apple-darwin" "arm64" $sdkPhone
cd $tmp
products=`ls | grep libopus | grep iPhone`
echo "generating $fatProductIos from ${products} ..." 
lipo -create ${products} -output $fatProductIos
cd $here
cp -v $tmp/$fatProductIos $fatLibsDest
lipo -info $fatLibsDest/$fatProductIos
echo "$fatLibsDest/$fatProductIos generated."
echo "\n==========================="


fatProductMac="libopus_osx.a"
echo "\n==========================="
echo "generate $fatProductMac ..."
generateLibopus "x86_64-apple-darwin" "x86_64" $sdkMac
generateLibopus "aarch64-apple-darwin" "arm64" $sdkMac
cd $tmp
products=`ls | grep libopus | grep Mac`
echo "generating $fatProductMac from ${products} ..." 
lipo -create ${products} -output $fatProductMac
cd $here
cp -v $tmp/$fatProductMac $fatLibsDest
lipo -info $fatLibsDest/$fatProductMac
echo "$fatLibsDest/$fatProductMac ready."
echo "\n==========================="


fatProductCatalyst="libopus_catalyst.a"
echo "\n==========================="
echo "generate $fatProductCatalyst ..."
generateLibopus "x86_64-apple-darwin" "x86_64h" $sdkMac
#generateLibopus "aarch64-apple-darwin" "arm64e" $sdkMac
cd $tmp
products=`ls | grep libopus | grep Mac | grep -e arm64e -e x86_64h`
echo "generating $fatProductCatalyst from ${products} ..." 
lipo -create ${products} -output $fatProductCatalyst
cd $here
cp -v $tmp/$fatProductCatalyst $fatLibsDest
lipo -info $fatLibsDest/$fatProductCatalyst
echo "$fatLibsDest/$fatProductCatalyst ready."
echo "\n==========================="
echo "generating libraries done."

echo "\n==========================="
cd $here
echo "copy headers into opus-swift.xcodeproj"
for f in $opusHeaders/*.h; do
    file=`basename $f`
    cp -v $f ./opus-swift/include/
done
echo "opus-swift.xcodeproj is ready"
echo "done."

