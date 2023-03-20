EXE=$(find ./Executables -perm +111 -type f -or -type l)

ENTITLEMENT_TEMPLATE='<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>com.apple.security.app-sandbox</key>
        <true/>
        <key>com.apple.security.inherit</key>
        <true/>
    </dict>
</plist>'

echo "Signing executables"

for exe in $EXE ;do
  touch "$exe.entitlements"
  echo "$ENTITLEMENT_TEMPLATE" > "$exe.entitlements"
  codesign -f -s "stef.kors@gmail.com" --entitlements "$exe.entitlements" "$exe"
done

echo "Finshed signing executables"