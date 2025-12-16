sap.ui.define(["sap/ui/core/mvc/Controller"], function (Controller) {
  "use strict";
  return Controller.extend("project1.controller.SalesInquiryItem", {
    onNavBack: function () {
      this.getOwnerComponent().getRouter().navTo("home");
    }
  });
});
