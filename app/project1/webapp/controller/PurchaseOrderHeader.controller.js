sap.ui.define([
  "sap/ui/core/mvc/Controller",
  "sap/m/MessageBox"
], function (Controller, MessageBox) {
  "use strict";

  return Controller.extend("project1.controller.PurchaseOrderHeader", {

    onNavBack: function () {
      this.getOwnerComponent().getRouter().navTo("home");
    },

    // ✅ Only navigate to items
    onOpenItems: function (oEvent) {
      const oCtx = oEvent.getSource().getBindingContext("po");
      const sHeaderId = oCtx && oCtx.getProperty("ID");

      if (!sHeaderId) {
        return MessageBox.warning("No Header ID found");
      }

      this.getOwnerComponent().getRouter().navTo("PurchaseOrderItem", {
        headerId: sHeaderId
      });
    }

  });
});
