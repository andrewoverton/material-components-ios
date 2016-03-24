# This file was automatically generated by running scripts/sync_icons.sh
# Do not modify directly.
def registerIcons(s)

  s.subspec "Icons" do |iss|
    iss.public_header_files = "components/private/Icons/src/*.h"
    iss.source_files = "components/private/Icons/src/*.{h,m}", "components/private/Icons/src/private/*.{h,m}"
    iss.header_mappings_dir = "components/private/Icons/src/*"


    iss.subspec "ic_arrow_back" do |ss|
      ss.public_header_files = "components/private/Icons/icons/ic_arrow_back/src/*.h"
      ss.source_files = "components/private/Icons/icons/ic_arrow_back/src/*.{h,m}"
      ss.header_mappings_dir = "components/private/Icons/icons/ic_arrow_back/src/*"
      ss.resource_bundles = {
        "MaterialIcon_ic_arrow_back" => [
          "components/private/Icons/icons/ic_arrow_back/src/MaterialIcon+ic_arrow_back.bundle/**/*.png",
          "components/private/Icons/icons/ic_arrow_back/src/MaterialIcon+ic_arrow_back.bundle/*.xcassets"
        ]
      }
    end
  end
end
