using { po.ust as db } from '../db/schema';

// Master data service
@path : 'master-data'
service MasterDataService {

 
  entity CustomerMaster as projection on db.CustomerMaster;
  entity VendorMaster   as projection on db.VendorMaster;
  entity Material       as projection on db.Material;
}

// Purchase order service
@path : 'purchase-orders'
service PurchaseOrderService {

  entity PurchaseOrderHeader as projection on db.PurchaseOrderHeader;
  entity PurchaseOrderItem   as projection on db.PurchaseOrderItem;
}

// Sales inquiry service
@path : 'sales-inquiry'
service SalesInquiryService {

  entity SalesInquiryHeader as projection on db.SalesInquiryHeader;
  entity SalesInquiryItem   as projection on db.SalesInquiryItem;
}

// Sales order service
@path : 'sales-orders'
service SalesOrderService {

  entity SalesOrderHeader as projection on db.SalesOrderHeader;
  entity SalesOrderItem   as projection on db.SalesOrderItem;
  entity AvailabilityCheck as projection on db.AvailabilityCheck;
}

// Logistics service (delivery / transport / pickup / GI)
@path : 'logistics'
service LogisticsService {

  entity OutboundDeliveryHeader as projection on db.OutboundDeliveryHeader;
  entity OutboundDeliveryItem   as projection on db.OutboundDeliveryItem;
  entity TransportationDoc      as projection on db.TransportationDoc;
  entity GoodsPickup            as projection on db.GoodsPickup;
  entity GoodsIssue             as projection on db.GoodsIssue;
}

// Billing service
@path : 'billing'
service BillingService {

  entity BillingHeader   as projection on db.BillingHeader;
  entity BillingItem     as projection on db.BillingItem;
}

// Payment service
@path : 'payments'
service PaymentService {

  entity PaymentDocument as projection on db.PaymentDocument;
}

// Monitoring / error & audit service
@path : 'monitoring'
service MonitoringService {

  entity SDAuditLog as projection on db.SDAuditLog;
}
