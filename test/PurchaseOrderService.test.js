const cds = require('@sap/cds')

const { GET, POST, expect, axios } = cds.test (__dirname+'/..')
axios.defaults.auth = { username: 'alice', password: '' }

describe('PurchaseOrderService OData APIs', () => {

  it('serves PurchaseOrderService.PurchaseOrderHeader', async () => {
    const { data } = await GET `/odata/v4/purchase-orders/PurchaseOrderHeader ${{ params: { $select: 'ID,poNumber' } }}`
    expect(data.value).to.containSubset([
      {"ID":"PurchaseOrderHeader-12824164","poNumber":"poNumber-12824164"},
    ])
  })

})
