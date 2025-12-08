sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"salesorderdistribution/test/integration/pages/CustomerMasterList",
	"salesorderdistribution/test/integration/pages/CustomerMasterObjectPage",
	"salesorderdistribution/test/integration/pages/SalesOrderHeaderObjectPage"
], function (JourneyRunner, CustomerMasterList, CustomerMasterObjectPage, SalesOrderHeaderObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('salesorderdistribution') + '/test/flp.html#app-preview',
        pages: {
			onTheCustomerMasterList: CustomerMasterList,
			onTheCustomerMasterObjectPage: CustomerMasterObjectPage,
			onTheSalesOrderHeaderObjectPage: SalesOrderHeaderObjectPage
        },
        async: true
    });

    return runner;
});

