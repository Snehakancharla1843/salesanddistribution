const cds = require('@sap/cds')

const { GET, POST, expect, axios } = cds.test (__dirname+'/..')
axios.defaults.auth = { username: 'alice', password: '' }

describe('MonitoringService OData APIs', () => {

  it('serves MonitoringService.SDAuditLog', async () => {
    const { data } = await GET `/odata/v4/monitoring/SDAuditLog ${{ params: { $select: 'ID,businessObject' } }}`
    expect(data.value).to.containSubset([
      {"ID":"25124477-4f72-42d8-92a8-1e8eb6b0fbe6","businessObject":"businessObject-25124477"},
    ])
  })

})
