# Specify colors utilized in the terminal
red='\033[0;31m'             #  red
grn='\033[0;32m'             #  green
ylw='\033[0;33m'             #  yellow
blu='\033[0;34m'             #  blue
ppl='\033[0;35m'             #  purple
cya='\033[0;36m'             #  cyan
rom_zip=$(ls -tr "$OUT"/ProjectCiRCLE-*.zip | tail -1)

echo "# GENERATING OTA JSON #" 1>&2
echo "{"
echo '  "response": ['
echo "    {"
echo '      "datetime":' "\"$(grep ro\.build\.date\.utc $OUT/system/build.prop | cut -d= -f2)\","
echo '      "filename":' "\"$(basename $rom_zip)\","
echo '      "id":' "\"$((md5sum $rom_zip) | cut -d ' ' -f1)\","
echo '      "romtype":'"\"$(get_build_var CIRCLE_BUILDTYPE)\","
echo '      "size":' "$(stat -c%s $rom_zip),"
echo '      "support":' "false,"
echo '      "url":' "\"https://sourceforge.net/projects/project-circle/files/$(get_build_var CIRCLE_BUILD)/$(get_build_var CIRCLE_EXTRAVERSION | sed 's/-//')/$(basename $rom_zip)/download\","
echo '      "version":' "\"$(get_build_var PRODUCT_VERSION_MAJOR).$(get_build_var PRODUCT_VERSION_MINOR).$(get_build_var PRODUCT_VERSION_PATCH)\","
echo '      "updater":' "true,"
echo '      "maintainer":' "\"$(get_build_var CIRCLE_MAINTAINER | sed 's/ .*//')\""
echo "    }"
echo "  ]"
echo "}"
echo " "
echo -e ${grn}"DONE!" 1>&2
