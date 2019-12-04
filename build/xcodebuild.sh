BUILD_DES=./build
OUTPUT_NAME=Cocos2dx
IOS_BUILD_ROOT=${BUILD_DES}/${OUTPUT_NAME}-iphoneos
SIM_BUILD_ROOT=${BUILD_DES}/${OUTPUT_NAME}-iphonesimulator
UNIVERSAL_OUTPUTFOLDER=${BUILD_DES}/${OUTPUT_NAME}-universal
TARGET_NAME=libcocos2d\ iOS

xcodebuild -project cocos2d_libs.xcodeproj -target "${TARGET_NAME}" ONLY_ACTIVE_ARCH=YES -configuration Release ENABLE_BITCODE=YES -sdk iphoneos -arch arm64 -arch arm64e CONFIGURATION_BUILD_DIR="${IOS_BUILD_ROOT}" | xcpretty
xcodebuild -project cocos2d_libs.xcodeproj -target "${TARGET_NAME}" ONLY_ACTIVE_ARCH=YES -configuration Release ENABLE_BITCODE=YES -sdk iphonesimulator -arch x86_64 CONFIGURATION_BUILD_DIR="${SIM_BUILD_ROOT}" | xcpretty
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/lib${OUTPUT_NAME}.a" "${IOS_BUILD_ROOT}/${TARGET_NAME}.a" "${SIM_BUILD_ROOT}/${TARGET_NAME}.a"
cd ../cocos/
find . -type f -name '*.h' -o -name "*.inl" -o -name "*.hpp" | cpio -p -d -v "../build/${UNIVERSAL_OUTPUTFOLDER}/include"
