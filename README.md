PDFPrintPlugin
==============

1. Add PrintPlugin.h and PrintPlugin.m in ProjectName/Plugins
2. Add the next code in config.xml

```
<feature name="PrintPlugin">
    <param name="ios-package" value="PrintPlugin"/>
</feature>
```

3. Add the next code in Project-info.plist

```
<key>printPlugin</key>
<string>PrintPlugin</string>
```

4. Include PrintPlugin.js in your index.html

```javascript
var printPlugin = cordova.require("cordova/plugin/PrintPlugin");

printPlugin.print(
    url,
    function(result) {
        console.log("Printing successful ", result);
    },
    function(result) {
        if (!result.available) {
            console.log("Printing is not available");
        }
        else {
            console.log(result.error);
        }
    }
);
```

PDF Print Plugin for PhoneGap Cordova 2.9
