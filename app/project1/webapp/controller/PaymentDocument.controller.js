sap.ui.define([
  "sap/ui/core/mvc/Controller"
], function (Controller) {
  "use strict";

  return Controller.extend("project1.controller.PaymentDocument", {
    onInit: function () {
      // nothing needed for table binding if you used items="{pay>/PaymentDocument}"
    },

    onNavBack: function () {
      this.getOwnerComponent().getRouter().navTo("home");
    }
  });
});
