const cds = require('@sap/cds')

const { GET, POST, expect, axios } = cds.test (__dirname+'/..')
axios.defaults.auth = { username: 'alice', password: '' }

describe('PaymentService OData APIs', () => {

  it('serves PaymentService.PaymentDocument', async () => {
    const { data } = await GET `/odata/v4/payments/PaymentDocument ${{ params: { $select: 'ID,paymentNumber' } }}`
    expect(data.value).to.containSubset([
      {"ID":"28638036-3524-42c2-8064-f3d1088bae62","paymentNumber":"ymentNumber-28638036"},
    ])
  })

})
