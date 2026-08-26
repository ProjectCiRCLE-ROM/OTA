# Specify colors utilized in the terminal
red='\033[0;31m'             #  red
grn='\033[0;32m'             #  green
ylw='\033[0;33m'             #  yellow
blu='\033[0;34m'             #  blue
ppl='\033[0;35m'             #  purple
cya='\033[0;36m'             #  cyan
res='\033[0m'                #  reset
rom_zip=$(ls -tr "$OUT"/ProjectCiRCLE-*.zip | tail -1)

echo "# GENERATING OTA JSON #" 1>&2
cat <<EOF
[
  {
    "datetime": "$(grep ro\.build\.date\.utc $OUT/system/build.prop | cut -d= -f2)",
    "files": [
      {
        "filename": "$(basename $rom_zip)",
        "os_patch_level": "$(get_build_var RELEASE_PLATFORM_SECURITY_PATCH)",
        "os_sdk_level": $(get_build_var RELEASE_PLATFORM_SDK_VERSION),
        "ota_property_files": "$(unzip -p $rom_zip META-INF/com/android/metadata | grep '^ota-property-files=' | tail -1 | cut -d= -f2)",
        "sha256": "$(sed 's/ .*//' ${rom_zip}.sha256sum | tr -d '\n')",
        "size": $(stat -c%s $rom_zip),
        "url": "https://sourceforge.net/projects/project-circle/files/$(get_build_var CIRCLE_BUILD)/$(get_build_var CIRCLE_EXTRAVERSION | sed 's/-//')/$(basename $rom_zip)/download",
      }
    ],
    "type": "$(get_build_var CIRCLE_BUILDTYPE | tr '[:upper:]' '[:lower:]')",
    "version": "$(get_build_var PRODUCT_VERSION_MAJOR).$(get_build_var PRODUCT_VERSION_MINOR).$(get_build_var PRODUCT_VERSION_PATCH)"
  }
]
EOF
echo -e ${grn}"DONE!${res}" 1>&2
echo "" 1>&2
echo -e "${red}The extra space at the end of ota_property_files is NECESSARY and MUST NOT BE DELETED!${res}" 1>&2
