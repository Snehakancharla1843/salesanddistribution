const cds = require('@sap/cds')

module.exports = cds.service.impl(function () {
  const Header = this.entities?.PurchaseOrderHeader
  const Item   = this.entities?.PurchaseOrderItem

  if (!Header || !Item) {
    console.warn('PurchaseOrder entities not found – check service CDS')
    return
  }

  /**
  
   * PURCHASE ORDER HEADER
  
   */

  // Validate Header CREATE
  this.before('CREATE', Header, req => {
    if (!req.data.poNumber) {
      req.error(400, 'poNumber is mandatory')
    }

    if (!req.data.currency) {
      req.error(400, 'currency is mandatory')
    }
  })

  // Validate Header UPDATE
  this.before('UPDATE', Header, req => {
    if (req.data.status === 'CLOSED') {
      req.error(400, 'Closed PO cannot be updated')
    }
  })

  /**
  
   * PURCHASE ORDER ITEM
  
   */

  // Validate Item CREATE & UPDATE
  this.before(['CREATE', 'UPDATE'], Item, req => {

    // Quantity check
    const qty = req.data?.quantity?.order_quan
    if (!qty || qty <= 0) {
      req.error(400, 'quantity.order_quan must be greater than 0')
    }

    // Price check
    if (req.data.netPrice !== undefined && req.data.netPrice <= 0) {
      req.error(400, 'netPrice must be greater than 0')
    }

    // Discount check
    if (req.data.discountPercent > 100) {
      req.error(400, 'discountPercent cannot exceed 100')
    }
  })


  
  
  
   
  this.after('CREATE', Header, data => {
    console.log('PO Header created:', data.ID)
  })

  this.after('CREATE', Item, data => {
    console.log('PO Item created:', data.ID)
  })
})
