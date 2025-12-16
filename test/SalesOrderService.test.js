const cds = require('@sap/cds')

const { GET, POST, expect, axios } = cds.test (__dirname+'/..')
axios.defaults.auth = { username: 'alice', password: '' }

describe('SalesOrderService OData APIs', () => {

  it('serves SalesOrderService.SalesOrderHeader', async () => {
    const { data } = await GET `/odata/v4/sales-orders/SalesOrderHeader ${{ params: { $select: 'ID,salesOrderNumber' } }}`
    expect(data.value).to.containSubset([
      {"ID":"39277384-51e3-4858-86d8-5be4480b78d9","salesOrderNumber":"sOrderNumber-3927738"},
    ])
  })

})
