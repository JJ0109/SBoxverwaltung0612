using { Country, managed, sap.common.CodeList } from '@sap/cds/common';


namespace sap.fe.cap.travel;

entity Travel : managed {
  key TravelUUID : UUID;
  TravelID       : Integer @readonly default 0;
  BeginDate      : Date;
  EndDate        : Date;
  BookingFee     : Decimal(16, 3);
  TotalPrice     : Decimal(16, 3) @readonly;
  Description    : String(1024);
  TravelStatus   : Association to TravelStatus @readonly;
  to_Customer    : Association to Passenger;
  to_Booking     : Composition of many Booking on to_Booking.to_Travel = $self;
};

entity Booking : managed {
  key BookingUUID   : UUID;
  BookingID         : Integer @Core.Computed;
  ConnectionID      : String(4);
  BookingStatus     : Association to BookingStatus;
  to_Carrier        : Association to Airline;
  to_Customer       : Association to Passenger;
  to_Travel         : Association to Travel;
  to_Flight         : Association to Flight on  to_Flight.AirlineID = to_Carrier.AirlineID
                                            and to_Flight.ConnectionID = ConnectionID;
};


entity Airline : managed {
  key AirlineID : String(3);
  Name          : String(40);
  AirlinePicURL : String      @UI : {IsImageURL : true};
};


entity Flight : managed {
  key AirlineID    : String(3);
  key ConnectionID : String(4);
  to_Airline       : Association to Airline on to_Airline.AirlineID = AirlineID;
};


entity Passenger : managed {
  key CustomerID : String(6);
  FirstName      : String(40);
  LastName       : String(40);
  Title          : String(10);
  Street         : String(60);
  PostalCode     : String(10);
  City           : String(40);
  CountryCode    : Country;
  PhoneNumber    : String(30);
  EMailAddress   : String(256);
};


//
//  Code Lists
//

entity BookingStatus : CodeList {
  key code : String enum {
    New      = 'N';
    Booked   = 'B';
    Canceled = 'X';
  };
};

entity TravelStatus : CodeList {
  key code : String enum {
    Open     = 'O';
    Accepted = 'A';
    Canceled = 'X';
  } default 'O'; //> will be used for foreign keys as well
  criticality : Integer; //  2: yellow colour,  3: green colour, 0: unknown
  fieldControl: Integer @odata.Type:'Edm.Byte'; // 1: #ReadOnly, 7: #Mandatory
  createDeleteHidden: Boolean;
}
