const cds = require('@sap/cds')

const { GET, POST, expect, axios } = cds.test (__dirname+'/..')
axios.defaults.auth = { username: 'alice', password: '' }

describe('SalesInquiryService OData APIs', () => {

  it('serves SalesInquiryService.SalesInquiryHeader', async () => {
    const { data } = await GET `/odata/v4/sales-inquiry/SalesInquiryHeader ${{ params: { $select: 'ID,inquiryNumber' } }}`
    expect(data.value).to.containSubset([
      {"ID":"11688931-193f-4578-81b6-fc995d79767a","inquiryNumber":"quiryNumber-11688931"},
    ])
  })

})
