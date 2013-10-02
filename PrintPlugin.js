cordova.define("cordova/plugin/PrintPlugin",

    function (require, exports, module) {
        var exec = require("cordova/exec"),
            PrintPlugin = function (){};

        /**
         * print      - html string or DOM node (if latter, innerHTML is used to get the contents). REQUIRED.
         * success    - callback function called if print successful.     {success: true}
         * fail       - callback function called if print unsuccessful.  If print fails, {error: reason}. If printing not available: {available: false}
         * options    -  {dialogOffset:{left: 0, right: 0}}. Position of popup dialog (iPad only).
         */
        PrintPlugin.prototype.print = function(printHTML, successCallback, errorCallback, options) {
            var dialogLeftPos = 0,
                dialogTopPos = 0;

            if (typeof printHTML != 'string'){
                console.log("Print function requires an HTML string. Not an object");
                return;
            }

            if (options) {
                if (options.dialogOffset){
                    if (options.dialogOffset.left){
                        dialogLeftPos = options.dialogOffset.left;
                        if (isNaN(dialogLeftPos)){
                            dialogLeftPos = 0;
                        }
                    }
                    if (options.dialogOffset.top){
                        dialogTopPos = options.dialogOffset.top;
                        if (isNaN(dialogTopPos)){
                            dialogTopPos = 0;
                        }
                    }
                }
            }

            exec(successCallback, errorCallback, 'PrintPlugin', 'print', [
                printHTML,
                dialogLeftPos,
                dialogTopPos
            ]);
        };

        /**
         * Callback function returns {available: true/false}
         */
        PrintPlugin.prototype.isPrintingAvailable = function(successCallback, errorCallback) {
            if (errorCallback == null) errorCallback = function () {}
            exec(successCallback, errorCallback, 'PrintPlugin', 'isPrintingAvailable', []);
        };

        var printPlugin = new PrintPlugin();
        module.exports = printPlugin;
    });
