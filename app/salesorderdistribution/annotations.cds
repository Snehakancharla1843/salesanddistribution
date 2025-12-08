using MasterDataService as service from '../../srv/service';
annotate service.CustomerMaster with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : customerCode,
            },
            {
                $Type : 'UI.DataField',
                Value : customerName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'address_vm_street',
                Value : address_vm_street,
            },
            {
                $Type : 'UI.DataField',
                Label : 'address_vm_city',
                Value : address_vm_city,
            },
            {
                $Type : 'UI.DataField',
                Label : 'address_vm_state',
                Value : address_vm_state,
            },
            {
                $Type : 'UI.DataField',
                Label : 'address_vm_country',
                Value : address_vm_country,
            },
            {
                $Type : 'UI.DataField',
                Label : 'address_vm_postal',
                Value : address_vm_postal,
            },
            {
                $Type : 'UI.DataField',
                Label : 'gstNo',
                Value : gstNo,
            },
            {
                $Type : 'UI.DataField',
                Label : 'phone',
                Value : phone,
            },
            {
                $Type : 'UI.DataField',
                Label : 'email',
                Value : email,
            },
            {
                $Type : 'UI.DataField',
                Label : 'paymentTerms',
                Value : paymentTerms,
            },
            {
                $Type : 'UI.DataField',
                Label : 'isActive',
                Value : isActive,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : customerCode,
        },
        {
            $Type : 'UI.DataField',
            Value : customerName,
        },
        {
            $Type : 'UI.DataField',
            Label : 'address_vm_street',
            Value : address_vm_street,
        },
        {
            $Type : 'UI.DataField',
            Label : 'address_vm_city',
            Value : address_vm_city,
        },
        {
            $Type : 'UI.DataField',
            Label : 'address_vm_state',
            Value : address_vm_state,
        },
    ],
);

