sap.ui.define([
    "sap/ui/core/mvc/Controller"
], function (Controller) {
  "use strict";

  return Controller.extend("project1.controller.View1", {
    onInit: function () {},

    onTilePress: function (oEvent) {
      const aCustomData = oEvent.getSource().getCustomData();
      const oEntityCD = aCustomData.find(cd => cd.getKey() === "entity");
      const sEntity = oEntityCD ? oEntityCD.getValue() : "";

      if (!sEntity) {
        console.error("No entity found in CustomData");
        return;
      }

      // ✅ navigate to route with same name (CustomerMaster, VendorMaster, ...)
      this.getOwnerComponent().getRouter().navTo(sEntity);
    }
  });
});