const cds = require("@sap/cds");

module.exports = cds.service.impl(async function () {

  const { PurchaseOrderHeader } = this.entities;

  this.on("getPOInfo", async (req) => {

    const result = await SELECT.one
      .from(PurchaseOrderHeader)
      .columns(['ID', 'poNumber'])
      .where({ ID: req.data.ID });

    // store in normal variables
    let poId = result.ID;
    let poNum = result.poNumber;

    return {
      ID: poId,
      poNumber: poNum
    };
  });

});
