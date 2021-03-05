#!/bin/sh
PROJECT_DIR="${PWD}/b03-ios"
GOOGLE_INFO="${PROJECT_DIR}/GoogleService-Info.plist"
PROJECT_INFO="${PROJECT_DIR}/Info.plist"

## Get BundleId from GoogleInfo and copy to project Info
BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "print :BUNDLE_ID" "${GOOGLE_INFO}")
PROJECT_ID=$(/usr/libexec/PlistBuddy -c "print :PROJECT_ID" "${GOOGLE_INFO}")

echo "1/2 Copy BundleID '${BUNDLE_ID}' to project.."
/usr/libexec/PlistBuddy -c "set :CFBundleIdentifier ${BUNDLE_ID}" "${PROJECT_INFO}"

echo "2/2 Update URL schemes"

## Delete Urls and add Google Scheme
GOOGLE_URL=$(/usr/libexec/PlistBuddy -c "print :REVERSED_CLIENT_ID" "${GOOGLE_INFO}")

# clear
/usr/libexec/PlistBuddy -c "delete CFBundleURLTypes" "${PROJECT_INFO}"
# generate new list
/usr/libexec/PlistBuddy -c "add CFBundleURLTypes array" "${PROJECT_INFO}"

/usr/libexec/PlistBuddy -c "add CFBundleURLTypes:0:CFBundleURLSchemes array" "${PROJECT_INFO}"
/usr/libexec/PlistBuddy -c "add CFBundleURLTypes:0:CFBundleURLSchemes:0 string ${GOOGLE_URL}" "${PROJECT_INFO}"

FACEBOOK_ID=$(/usr/libexec/PlistBuddy -c "print :FacebookAppID" "${PROJECT_INFO}" 2>/dev/null || printf '0')

if [ "$FACEBOOK_ID" == 0 ]; then
echo "warning: FacebookAppID not found"
else
/usr/libexec/PlistBuddy -c "add CFBundleURLTypes:1:CFBundleURLSchemes array" "${PROJECT_INFO}"
/usr/libexec/PlistBuddy -c "add CFBundleURLTypes:1:CFBundleURLSchemes:0 string fb${FACEBOOK_ID}" "${PROJECT_INFO}"
fi

echo "Synced succesfully"

## End
