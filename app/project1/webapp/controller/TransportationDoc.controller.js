sap.ui.define(["sap/ui/core/mvc/Controller"], function (Controller) {
  "use strict";
  return Controller.extend("project1.controller.TransportationDoc", {
    onNavBack: function () {
      this.getOwnerComponent().getRouter().navTo("home");
    }
  });
});
