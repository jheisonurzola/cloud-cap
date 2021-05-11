using {sap.capire.bookshop} from '_base/db/schema';
using {sap.capire.orders}   from '_base/db/schema';
using from '_base/db/capire_common';

using {
    cuid, managed, Country, sap.common.CodeList
} from '@sap/cds/common';



namespace Z_bookshop.extension;

// extend existing entity 
extend orders.Orders with { 
  Z_Customer    : Association to one Z_Customers;  
  Z_SalesRegion : Association to one Z_SalesRegion; 
  Z_priority    : String @assert.range enum {high; medium; low} default 'medium';
  Z_Remarks     : Composition of many Z_Remarks on Z_Remarks.Z_parent = $self;
}  

// new entity - as association target
entity Z_Customers // : cuid, managed 
{
  key Z_ID       : UUID;     // workaround
  Z_email        : String;
  Z_firstName    : String;
  Z_lastName     : String; 
  Z_creditCardNo : String;
  Z_dateOfBirth  : Date;
  Z_status       : String   @assert.range enum {platinum; gold; silver; bronze} default 'bronze';
  Z_creditScore  : Decimal  @assert.range: [ 1.0, 100.0 ] default 50.0;
  Z_PostalAddresses : Composition of many Z_CustomerPostalAddresses on Z_PostalAddresses.Z_Customer = $self;
}

// new unique constraint (secondary index)
annotate Z_Customers with @assert.unique: { Z_email: [ Z_email ] }   
{
   Z_email @mandatory;    // mandatory check
}

// new entity - as composition target
entity Z_CustomerPostalAddresses  // :  
{
  key Z_ID         : UUID; // workaround
  Z_Customer       : Association to one Z_Customers;
  Z_description    : String;
  Z_street         : String;
  Z_town           : String;
  Z_country        : Country;
};

// new entity - as code list
entity Z_SalesRegion: CodeList {
  key Z_regionCode : String(11);
}


// new entity - as composition target
entity Z_Remarks // : cuid, managed
{  
  key Z_ID      : UUID; // workaround
  Z_parent      : Association to one orders.Orders;  
  // number        : Integer;  // try without Z_
  Z_number        : Integer;  
  Z_remarksLine : String; 
}
