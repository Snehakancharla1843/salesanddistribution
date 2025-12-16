sap.ui.define([
  "sap/ui/core/UIComponent",
  "project1/model/models"
], function (UIComponent, models) {
  "use strict";

  return UIComponent.extend("project1.Component", {
    metadata: {
      manifest: "json"
    },

    init: function () {
      UIComponent.prototype.init.apply(this, arguments);

      this.setModel(models.createDeviceModel(), "device");

      // ✅ router init only
      this.getRouter().initialize();
    }
  });
});
