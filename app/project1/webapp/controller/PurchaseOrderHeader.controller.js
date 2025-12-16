sap.ui.define([
  "sap/ui/core/mvc/Controller",
  "sap/m/MessageBox",
  "sap/m/MessageToast"
], function (Controller, MessageBox, MessageToast) {
  "use strict";

  return Controller.extend("project1.controller.PurchaseOrderHeader", {

    onNavBack() {
      this.getOwnerComponent().getRouter().navTo("home");
    },

    onCreate() {
      const oTable = this.byId("tblPOH");
      const oBinding = oTable.getBinding("items");

      oBinding.create({
        poNumber: "",
        documentDate: null,
        deliveryDate: null,
        status: "draft"
      });

      MessageToast.show("New PO row added. Fill values and press Save.");
    },

    onSave() {
      const oModel = this.getView().getModel("po");
      oModel.submitBatch("$auto")
        .then(() => MessageToast.show("Saved successfully"))
        .catch((e) => MessageBox.error(e.message || "Save failed"));
    },

    onCancel() {
      const oModel = this.getView().getModel("po");
      oModel.resetChanges("$auto");
      MessageToast.show("Changes discarded");
    },

    onDelete() {
      const oTable = this.byId("tblPOH");
      const oItem = oTable.getSelectedItem();
      if (!oItem) return MessageBox.warning("Select a row to delete");

      const oCtx = oItem.getBindingContext("po");

      MessageBox.confirm("Delete selected PO?", {
        onClose: (sAction) => {
          if (sAction === "OK") {
            oCtx.delete("$auto")
              .then(() => MessageToast.show("Deleted"))
              .catch((e) => MessageBox.error(e.message || "Delete failed"));
          }
        }
      });
    }
  });
});
