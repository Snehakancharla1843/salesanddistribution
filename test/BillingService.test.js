const cds = require('@sap/cds')

const { GET, POST, expect, axios } = cds.test (__dirname+'/..')
axios.defaults.auth = { username: 'alice', password: '' }

describe('BillingService OData APIs', () => {

  it('serves BillingService.BillingHeader', async () => {
    const { data } = await GET `/odata/v4/billing/BillingHeader ${{ params: { $select: 'ID,billingNumber' } }}`
    expect(data.value).to.containSubset([
      {"ID":"22953872-2230-48df-ac22-ff2e2e0a6976","billingNumber":"llingNumber-22953872"},
    ])
  })

})
