const cds = require("@sap/cds");
const { SELECT } = cds.ql;

module.exports = cds.service.impl(function () {

  // ✅ use entity name as STRING to avoid undefined entity reference
  const ENTITY = "PurchaseOrderHeader";

  this.before(["CREATE", "UPDATE"], ENTITY, (req) => {
    const d = req.data;

    if (!d.poNumber || String(d.poNumber).trim() === "") req.error(400, "PO Number is mandatory");
    if (!d.documentDate) req.error(400, "Document Date is mandatory");
    if (!d.deliveryDate) req.error(400, "Delivery Date is mandatory");

    if (d.documentDate && d.deliveryDate && String(d.deliveryDate) < String(d.documentDate)) {
      req.error(400, "Delivery Date cannot be before Document Date");
    }

    const allowed = ["draft", "submitted", "approved", "rejected", "closed", "cancelled"];
    if (d.status && !allowed.includes(String(d.status))) {
      req.error(400, `Status must be one of: ${allowed.join(", ")}`);
    }
  });

  this.on("CREATE", ENTITY, async (req, next) => {
    const { poNumber } = req.data;

    const exists = await SELECT.one.from(ENTITY).where({ poNumber });
    if (exists) req.error(409, `PO Number '${poNumber}' already exists`);

    return next();
  });

  this.after("CREATE", ENTITY, (data, req) => {
    req.info(`PO created successfully (${data.poNumber || data.ID})`);
  });
});
