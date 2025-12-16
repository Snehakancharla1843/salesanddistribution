sap.ui.define([
  "sap/ui/core/mvc/Controller",
  "sap/m/MessageBox"
], function (Controller, MessageBox) {
  "use strict";

  return Controller.extend("project1.controller.PurchaseOrderItem", {

    onInit: function () {
      this.getOwnerComponent()
        .getRouter()
        .getRoute("PurchaseOrderItem")
        .attachPatternMatched(this._onRouteMatched, this);
    },

    _onRouteMatched: function (oEvent) {
      const sHeaderId = oEvent.getParameter("arguments").headerId; // e.g. POH001

      if (!sHeaderId) {
        MessageBox.error("Missing headerId in route.");
        return;
      }

      // show header id in toolbar
      const oTxt = this.byId("txtHeader");
      if (oTxt) oTxt.setText("Header: " + sHeaderId);

      const oTable = this.byId("tblPOI");
      const oTemplate = this.byId("poItemTemplate");

      // ✅ Correct binding to CAP navigation property:
      // /PurchaseOrderHeader('POH001')/toItems
      oTable.bindItems({
        path: `po>/PurchaseOrderHeader('${sHeaderId}')/toItems`,
        template: oTemplate,
        templateShareable: true
      });
    },

    onNavBack: function () {
      this.getOwnerComponent().getRouter().navTo("PurchaseOrderHeader");
    }

  });
});
