using { managed, cuid } from '@sap/cds/common';

namespace po.ust;

aspect primary : managed, cuid {}

// TYPES

type addresses {
  vm_street  : String(30);
  vm_city    : String(30);
  vm_state   : String(30);
  vm_country : String(30);
  vm_postal  : String(10);
}

type uom : String(10);
type currency : String(3);

type payment_terms : String enum {
  days30 = '30Days';
  days45 = '45Days';
  na     = 'N/A';
}

type po_status : String enum {
  draft;
  submitted;
  approved;
  rejected;
  closed;
  cancelled;
}

type sales_status : String enum {
  open;
  inProcess;
  confirmed;
  rejected;
  completed;
  cancelled;
}

type sales_item_status : String enum {
  open;
  partiallyDelivered;
  fullyDelivered;
  billed;
  cancelled;
}

type delivery_status : String enum {
  created;
  picking;
  picked;
  giPosted;
  shipped;
  delivered;
  cancelled;
}

type billing_status : String enum {
  draft;
  verified;
  posted;
  cancelled;
}

type payment_status : String enum {
  open;
  partiallyPaid;
  paid;
  rejected;
}

type Quantity {
  order_quan : Decimal(15,3) default 0;
}

type audit_aspect : managed {
  audit      : String(10);
  auditat    : DateTime;
  verifiedby : String(10);
  verifiedat : DateTime;
  approvedby : String(10);
  approvedat : DateTime;
}

// MASTER DATA

// CustomerMaster: Stores customer master data used in sales cycle
@Core.Description : 'Customer Master'
entity CustomerMaster @(odata.draft.enabled:true)  : primary {
  @Common.Label : 'Customer ID'
  key ID        : UUID;

  @Common.Label : 'Customer Code'
  customerCode  : String(20);

  @Common.Label : 'Customer Name'
  customerName  : String(80);

  address       : addresses;
  gstNo         : String(20);
  phone         : String(20);
  email         : String(80);
  paymentTerms  : payment_terms default #days30;
  isActive      : Boolean default true;

  toSalesOrders : Composition of many SalesOrderHeader
                    on toSalesOrders.customer = $self;       // forward 1:N CustomerMaster → SalesOrderHeader (parent → child)

  toInquiries   : Composition of many SalesInquiryHeader
                    on toInquiries.customer = $self;         // forward 1:N CustomerMaster → SalesInquiryHeader (parent → child)
}

// VendorMaster: Stores vendor master data for purchasing and 3rd-party sales
@Core.Description : 'Vendor Master (for purchasing & 3rd-party sales)'
entity VendorMaster : primary {
  @Common.Label : 'Vendor ID'
  key ID        : UUID;

  @Common.Label : 'Vendor Code'
  vendorCode    : String(20);

  @Common.Label : 'Vendor Name'
  vendorName    : String(80);

  address       : addresses;
  gstNo         : String(20);
  phone         : String(20);
  email         : String(80);
  isActive      : Boolean default true;

  toPurchaseOrders : Composition of many PurchaseOrderHeader
                        on toPurchaseOrders.vendor = $self;       // forward 1:N VendorMaster → PurchaseOrderHeader (parent → child)

  toSalesOrders    : Composition of many SalesOrderHeader
                        on toSalesOrders.supplyingVendor = $self; // forward 1:N VendorMaster → SalesOrderHeader (parent → child)
}

// Material: Common material master used in both purchase and sales cycles
@Core.Description : 'Material Master (common for Purchasing and Sales)'
entity Material : primary {
  @Common.Label : 'Material ID'
  key ID              : UUID;

  @Common.Label : 'Material Code'
  materialCode        : String(30);

  @Common.Label : 'Material Description'
  materialDescription : String(120);

  uom                 : uom;
  standardPrice       : Decimal(15,2);   // base cost (for PO)
  salesPrice          : Decimal(15,2);   // base price (for SO)
  gstPercent          : Decimal(5,2);
  isActive            : Boolean default true;

  toPurchaseItems     : Composition of many PurchaseOrderItem
                          on toPurchaseItems.material = $self;     // forward 1:N Material → PurchaseOrderItem (parent → child)

  toSalesOrderItems   : Composition of many SalesOrderItem
                          on toSalesOrderItems.material = $self;   // forward 1:N Material → SalesOrderItem (parent → child)

  toInquiryItems      : Composition of many SalesInquiryItem
                          on toInquiryItems.material = $self;      // forward 1:N Material → SalesInquiryItem (parent → child)
}

// PURCHASE ORDER (REFERENCE FOR SALES)

// PurchaseOrderHeader: Represents purchase order header for procurement
@Core.Description : 'Purchase Order Header'
entity PurchaseOrderHeader @(odata.draft.enabled) : primary {
  @Common.Label : 'PO ID'
  key ID          : String;

  @Common.Label : 'PO Number'
  poNumber        : String(20);

  vendor          : Association to VendorMaster;                // back N:1 PurchaseOrderHeader → VendorMaster (child → parent)

  documentDate    : Date;
  deliveryDate    : Date;
  currency        : currency default 'INR';
  paymentTerms    : payment_terms;

  totalValue      : Decimal(15,2);
  status          : po_status default #draft;
  remarks         : String(255);

  toItems         : Composition of many PurchaseOrderItem
                      on toItems.header = $self;                // forward 1:N PurchaseOrderHeader → PurchaseOrderItem (parent → child)
}

// PurchaseOrderItem: Represents line items of a purchase order
@Core.Description : 'Purchase Order Item'
entity PurchaseOrderItem : primary {
  @Common.Label : 'PO Item ID'
  key ID          : String;

  header          : Association to PurchaseOrderHeader;         // back N:1 PurchaseOrderItem → PurchaseOrderHeader (child → parent)
  material        : Association to Material;                    // back N:1 PurchaseOrderItem → Material (child → parent)

  lineItemNo      : Integer;
  quantity        : Quantity;
  uom             : uom;

  netPrice        : Decimal(15,2);
  discountPercent : Decimal(5,2);
  gstPercent      : Decimal(5,2);

  netAmount       : Decimal(15,2);
  taxAmount       : Decimal(15,2);
  grossAmount     : Decimal(15,2);
}

// SALES ORDER CYCLE – INQUIRY

// SalesInquiryHeader: Captures customer inquiry before raising sales order
@Core.Description : 'Sales Inquiry Header'
entity SalesInquiryHeader : primary {
  @Common.Label : 'Sales Inquiry ID'
  key ID              : UUID;

  @Common.Label : 'Inquiry Number'
  inquiryNumber       : String(20);

  customer            : Association to CustomerMaster;         // back N:1 SalesInquiryHeader → CustomerMaster (child → parent)

  inquiryDate         : Date;
  validTo             : Date;

  status              : sales_status default #open;
  remarks             : String(255);

  toItems             : Composition of many SalesInquiryItem
                          on toItems.inquiry = $self;          // forward 1:N SalesInquiryHeader → SalesInquiryItem (parent → child)

  toSalesOrders       : Composition of many SalesOrderHeader
                          on toSalesOrders.inquiry = $self;    // forward 1:N SalesInquiryHeader → SalesOrderHeader (parent → child)
}

// SalesInquiryItem: Line items of a sales inquiry
@Core.Description : 'Sales Inquiry Item'
entity SalesInquiryItem : primary {
  @Common.Label : 'Sales Inquiry Item ID'
  key ID              : UUID;

  inquiry             : Association to SalesInquiryHeader;     // back N:1 SalesInquiryItem → SalesInquiryHeader (child → parent)
  material            : Association to Material;               // back N:1 SalesInquiryItem → Material (child → parent)

  lineItemNo          : Integer;
  requestedQuantity   : Quantity;
  uom                 : uom;
  targetPrice         : Decimal(15,2);

  status              : sales_item_status default #open;
  notes               : String(255);
}

// SALES ORDER CYCLE – SALES ORDER (Raising Sales Order)

// SalesOrderHeader: Represents the sales order header (raising SO)
@Core.Description : 'Sales Order Header (Raising Sales Order)'
entity SalesOrderHeader : primary {
  @Common.Label : 'Sales Order ID'
  key ID              : UUID;

  @Common.Label : 'Sales Order Number'
  salesOrderNumber    : String(20);

  customer            : Association to CustomerMaster;         // back N:1 SalesOrderHeader → CustomerMaster (child → parent)
  inquiry             : Association to SalesInquiryHeader;     // back N:1 SalesOrderHeader → SalesInquiryHeader (child → parent)
  supplyingVendor     : Association to VendorMaster;           // back N:1 SalesOrderHeader → VendorMaster (child → parent)
  purchaseOrderRef    : Association to PurchaseOrderHeader;    // back N:1 SalesOrderHeader → PurchaseOrderHeader (child → parent)

  salesOrg            : String(10);
  distributionChannel : String(10);
  documentDate        : Date;
  requestedDelivery   : Date;
  currency            : currency default 'INR';
  paymentTerms        : payment_terms;

  netValue            : Decimal(15,2);
  taxValue            : Decimal(15,2);
  grossValue          : Decimal(15,2);

  status              : sales_status default #open;
  remarks             : String(255);

  toItems             : Composition of many SalesOrderItem
                          on toItems.header = $self;           // forward 1:N SalesOrderHeader → SalesOrderItem (parent → child)

  toDeliveries        : Composition of many OutboundDeliveryHeader
                          on toDeliveries.salesOrder = $self;  // forward 1:N SalesOrderHeader → OutboundDeliveryHeader (parent → child)

  toBillings          : Composition of many BillingHeader
                          on toBillings.salesOrder = $self;    // forward 1:N SalesOrderHeader → BillingHeader (parent → child)
}

// SalesOrderItem: Line items of the sales order
@Core.Description : 'Sales Order Item'
entity SalesOrderItem : primary {
  @Common.Label : 'Sales Order Item ID'
  key ID                : UUID;

  header                : Association to SalesOrderHeader;      // back N:1 SalesOrderItem → SalesOrderHeader (child → parent)
  material              : Association to Material;              // back N:1 SalesOrderItem → Material (child → parent)
  inquiryItem           : Association to SalesInquiryItem;      // back N:1 SalesOrderItem → SalesInquiryItem (child → parent)
  purchaseOrderItemRef  : Association to PurchaseOrderItem;     // back N:1 SalesOrderItem → PurchaseOrderItem (child → parent)

  lineItemNo            : Integer;
  quantity              : Quantity;
  uom                   : uom;

  netPrice              : Decimal(15,2);
  discountPercent       : Decimal(5,2);
  gstPercent            : Decimal(5,2);

  netAmount             : Decimal(15,2);
  taxAmount             : Decimal(15,2);
  grossAmount           : Decimal(15,2);

  confirmedQuantity     : Decimal(15,3) default 0;  // from availability check
  confirmedDate         : Date;

  deliveredQuantity     : Decimal(15,3) default 0;
  billedQuantity        : Decimal(15,3) default 0;
  openQuantity          : Decimal(15,3) default 0;

  status                : sales_item_status default #open;

  toAvailabilityLogs    : Composition of many AvailabilityCheck
                            on toAvailabilityLogs.salesItem = $self;  // forward 1:N SalesOrderItem → AvailabilityCheck (parent → child)

  toDeliveryItems       : Composition of many OutboundDeliveryItem
                            on toDeliveryItems.salesItem = $self;     // forward 1:N SalesOrderItem → OutboundDeliveryItem (parent → child)

  toBillingItems        : Composition of many BillingItem
                            on toBillingItems.salesItem = $self;      // forward 1:N SalesOrderItem → BillingItem (parent → child)
}

// SALES ORDER CYCLE – CHECKING AVAILABILITY

// AvailabilityCheck: Logs availability checks for sales order items
@Core.Description : 'Availability Check Log (Checking Availability)'
entity AvailabilityCheck : primary {
  @Common.Label : 'Availability Check ID'
  key ID              : UUID;

  salesItem           : Association to SalesOrderItem;   // back N:1 AvailabilityCheck → SalesOrderItem (child → parent)
  material            : Association to Material;         // back N:1 AvailabilityCheck → Material (child → parent)

  checkDateTime       : DateTime;
  plant               : String(10);
  availableQuantity   : Decimal(15,3);
  requestedQuantity   : Decimal(15,3);
  confirmedQuantity   : Decimal(15,3);
  result              : String(20);                     // e.g. FULL / PARTIAL / NONE
  message             : String(255);
}

// SALES ORDER CYCLE – OUTBOUND DELIVERY / TRANSPORT / PICKUP / GI

// OutboundDeliveryHeader: Represents outbound delivery document
@Core.Description : 'Outbound Delivery Header'
entity OutboundDeliveryHeader : primary {
  @Common.Label : 'Outbound Delivery ID'
  key ID              : UUID;

  @Common.Label : 'Delivery Number'
  deliveryNumber      : String(20);

  salesOrder          : Association to SalesOrderHeader;        // back N:1 OutboundDeliveryHeader → SalesOrderHeader (child → parent)

  deliveryDate        : Date;
  shippingPoint       : String(20);
  status              : delivery_status default #created;

  toItems             : Composition of many OutboundDeliveryItem
                          on toItems.deliveryHeader = $self;    // forward 1:N OutboundDeliveryHeader → OutboundDeliveryItem (parent → child)

  toTransports        : Composition of many TransportationDoc
                          on toTransports.delivery = $self;     // forward 1:N OutboundDeliveryHeader → TransportationDoc (parent → child)

  toGoodsPickups      : Composition of many GoodsPickup
                          on toGoodsPickups.delivery = $self;   // forward 1:N OutboundDeliveryHeader → GoodsPickup (parent → child)

  toGoodsIssues       : Composition of many GoodsIssue
                          on toGoodsIssues.delivery = $self;    // forward 1:N OutboundDeliveryHeader → GoodsIssue (parent → child)
}

// OutboundDeliveryItem: Line items of the outbound delivery
@Core.Description : 'Outbound Delivery Item'
entity OutboundDeliveryItem : primary {
  @Common.Label : 'Outbound Delivery Item ID'
  key ID              : UUID;

  deliveryHeader      : Association to OutboundDeliveryHeader;  // back N:1 OutboundDeliveryItem → OutboundDeliveryHeader (child → parent)
  salesItem           : Association to SalesOrderItem;          // back N:1 OutboundDeliveryItem → SalesOrderItem (child → parent)
  material            : Association to Material;                // back N:1 OutboundDeliveryItem → Material (child → parent)

  lineItemNo          : Integer;
  deliveryQuantity    : Decimal(15,3);
  uom                 : uom;
  batchNumber         : String(30);
  remarks             : String(255);

  toBillingItems      : Composition of many BillingItem
                          on toBillingItems.deliveryItem = $self;  // forward 1:N OutboundDeliveryItem → BillingItem (parent → child)
}

// TransportationDoc: Captures transportation details after delivery creation
@Core.Description : 'Transportation Document (Transportation)'
entity TransportationDoc : primary {
  @Common.Label : 'Transport ID'
  key ID              : UUID;

  delivery            : Association to OutboundDeliveryHeader;  // back N:1 TransportationDoc → OutboundDeliveryHeader (child → parent)

  transportNumber     : String(20);
  carrier             : String(60);
  vehicleNo           : String(30);
  departureDateTime   : DateTime;
  arrivalDateTime     : DateTime;
  status              : String(20);   // PLANNED / INTRANSIT / ARRIVED
}

// GoodsPickup: Represents physical goods pickup event
@Core.Description : 'Goods Pickup (Goods Pick up)'
entity GoodsPickup : primary {
  @Common.Label : 'Goods Pickup ID'
  key ID              : UUID;

  delivery            : Association to OutboundDeliveryHeader;  // back N:1 GoodsPickup → OutboundDeliveryHeader (child → parent)

  pickupDateTime      : DateTime;
  pickupLocation      : String(80);
  handledBy           : String(60);
  remarks             : String(255);
}

// GoodsIssue: Represents goods issue posting (issuing goods)
@Core.Description : 'Goods Issue (Issuing Goods)'
entity GoodsIssue : primary {
  @Common.Label : 'Goods Issue ID'
  key ID              : UUID;

  delivery            : Association to OutboundDeliveryHeader;  // back N:1 GoodsIssue → OutboundDeliveryHeader (child → parent)

  giNumber            : String(20);
  giDateTime          : DateTime;
  postedBy            : String(60);
  postingStatus       : String(20);    // SUCCESS / ERROR
  remarks             : String(255);
}

// SALES ORDER CYCLE – BILLING

// BillingHeader: Represents customer invoice for delivered goods
@Core.Description : 'Billing Header (Billing)'
entity BillingHeader : primary {
  @Common.Label : 'Billing ID'
  key ID              : UUID;

  @Common.Label : 'Billing Number'
  billingNumber       : String(20);

  salesOrder          : Association to SalesOrderHeader;       // back N:1 BillingHeader → SalesOrderHeader (child → parent)
  delivery            : Association to OutboundDeliveryHeader; // back N:1 BillingHeader → OutboundDeliveryHeader (child → parent)
  customer            : Association to CustomerMaster;         // back N:1 BillingHeader → CustomerMaster (child → parent)

  billingDate         : Date;
  postingDate         : Date;
  currency            : currency default 'INR';

  netAmount           : Decimal(15,2);
  taxAmount           : Decimal(15,2);
  totalAmount         : Decimal(15,2);
  status              : billing_status default #draft;

  toItems             : Composition of many BillingItem
                          on toItems.billingHeader = $self;    // forward 1:N BillingHeader → BillingItem (parent → child)

  toPayments          : Composition of many PaymentDocument
                          on toPayments.billing = $self;       // forward 1:N BillingHeader → PaymentDocument (parent → child)
}

// BillingItem: Line items on the billing document
@Core.Description : 'Billing Item'
entity BillingItem : primary {
  @Common.Label : 'Billing Item ID'
  key ID              : UUID;

  billingHeader       : Association to BillingHeader;          // back N:1 BillingItem → BillingHeader (child → parent)
  salesItem           : Association to SalesOrderItem;         // back N:1 BillingItem → SalesOrderItem (child → parent)
  deliveryItem        : Association to OutboundDeliveryItem;   // back N:1 BillingItem → OutboundDeliveryItem (child → parent)

  quantityBilled      : Decimal(15,3);
  uom                 : uom;
  netPrice            : Decimal(15,2);
  discountPercent     : Decimal(5,2);
  gstPercent          : Decimal(5,2);

  lineNetAmount       : Decimal(15,2);
  lineTaxAmount       : Decimal(15,2);
  lineTotalAmount     : Decimal(15,2);
}

// SALES ORDER CYCLE – PROCESSING PAYMENT

// PaymentDocument: Represents payment against a billing document
@Core.Description : 'Payment Document (Processing Payment)'
entity PaymentDocument : primary {
  @Common.Label : 'Payment ID'
  key ID              : UUID;

  billing             : Association to BillingHeader;          // back N:1 PaymentDocument → BillingHeader (child → parent)
  customer            : Association to CustomerMaster;         // back N:1 PaymentDocument → CustomerMaster (child → parent)

  paymentNumber       : String(20);
  paymentDate         : Date;
  paymentMethod       : String(30);   // BANKTRANSFER / CARD / CASH
  paymentAmount       : Decimal(15,2);
  currency            : currency default 'INR';
  status              : payment_status default #open;
  referenceText       : String(255);
}

// ERROR HANDLING & AUDIT LOGS

@Core.Description : 'Sales & Purchase Error / Audit Log'
entity SDAuditLog : primary {
  @Common.Label : 'Log ID'
  key ID           : UUID;

  @Common.Label : 'Business Object'
  businessObject   : String(50);       // 'SalesOrder', 'Delivery', 'Billing', 'Payment', 'PurchaseOrder'

  @Common.Label : 'Reference Number'
  refDocumentNo    : String(30);       // SO#, DO#, BILL#, PAY#, PO#

  refEntity        : String(40);       // 'SalesOrderHeader', 'BillingItem', etc.
  messageType      : String(10);       // INFO / WARN / ERROR
  messageCode      : String(20);
  messageText      : String(255);
  status           : String(20);       // Open / Resolved / Ignored

  audit            : audit_aspect;
}
