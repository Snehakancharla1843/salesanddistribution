const cds = require('@sap/cds')

const { GET, POST, expect, axios } = cds.test (__dirname+'/..')
axios.defaults.auth = { username: 'alice', password: '' }

describe('MasterDataService OData APIs', () => {

  it('serves MasterDataService.CustomerMaster', async () => {
    const { data } = await GET `/odata/v4/master-data/CustomerMaster ${{ params: { $select: 'ID,customerCode' } }}`
    expect(data.value).to.containSubset([
      {"ID":"349874bb-c8e2-4454-89ee-e729aec4e611","customerCode":"customerCode-349874"},
    ])
  })

})
