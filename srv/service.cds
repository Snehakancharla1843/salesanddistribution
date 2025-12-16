using { po.ust as db } from '../db/schema';

@path : 'master-data'
service MasterDataService {
  entity CustomerMaster as projection on db.CustomerMaster;
  entity VendorMaster   as projection on db.VendorMaster;
  entity Material       as projection on db.Material;
}

@path : 'purchase-orders'
service PurchaseOrderService {
  @(odata.draft.enabled: true)
  entity PurchaseOrderHeader as projection on db.PurchaseOrderHeader;

  entity PurchaseOrderItem   as projection on db.PurchaseOrderItem;
}

@path : 'sales-inquiry'
service SalesInquiryService {
  entity SalesInquiryHeader as projection on db.SalesInquiryHeader;
  entity SalesInquiryItem   as projection on db.SalesInquiryItem;
}

@path : 'sales-orders'
service SalesOrderService {
  @(odata.draft.enabled: true)
  entity SalesOrderHeader as projection on db.SalesOrderHeader;

  entity SalesOrderItem   as projection on db.SalesOrderItem;
  entity AvailabilityCheck as projection on db.AvailabilityCheck;
}

@path : 'billing'
service BillingService {
  @(odata.draft.enabled: true)
  entity BillingHeader as projection on db.BillingHeader;

  entity BillingItem   as projection on db.BillingItem;
}

@path : 'payments'
service PaymentService {
  @(odata.draft.enabled: true)
  entity PaymentDocument as projection on db.PaymentDocument;
}

@path : 'monitoring'
service MonitoringService {
  entity SDAuditLog as projection on db.SDAuditLog;
}
