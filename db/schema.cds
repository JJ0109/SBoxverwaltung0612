using { Country, managed, sap.common.CodeList } from '@sap/cds/common';


namespace slah.db;

entity Box : managed {
  key BoxUUID : UUID;
  BoxID       : Integer @readonly default 0;
  BeginDateAusleihe      : Date;
  EndDateAusleihe        : Date;
  Boxname    : String(1024);
  BoxStatus   : Association to BoxStatus @readonly;
  to_Patient    : Association to Patient;
  to_Geraete     : Composition of many Geraete on to_Geraete.to_Box = $self;
};

entity Geraete : managed {
  key GeraeteUUID   : UUID;
  GeraeteID         : Integer @Core.Computed;
  ConnectionID      : String(4);
  GeraeteStatus     : Association to GeraeteStatus;
  to_Geraetetyp        : Association to Geraetetyp;
  to_Patient       : Association to Patient;
  to_Box         : Association to Box;
  to_GVerbindung         : Association to GVerbindung on  to_GVerbindung.GeraetetypID = to_Geraetetyp.GeraetetypID
                                            and to_GVerbindung.ConnectionID = ConnectionID;
};


entity Geraetetyp : managed {
  key GeraetetypID : String(3);
  Bezeichnung          : String(40);
  AnleitungURL : String      @UI : {IsImageURL : true};
};


entity GVerbindung : managed {
  key GeraetetypID    : String(3);
  key ConnectionID : String(4);
  to_Geraetetyp       : Association to Geraetetyp on to_Geraetetyp.GeraetetypID = GeraetetypID;
};


entity Patient : managed {
  key PatientID : String(6);
  Vorname      : String(40);
  Nachname       : String(40);
  Anrede          : String(10);
  Strasse         : String(60);
  Plz     : String(10);
  Stadt           : String(40);
  CountryCode    : Country;
  Telefonnr    : String(30);
  EMail   : String(256);
};


//
//  Code Lists
//

entity GeraeteStatus : CodeList {
  key code : String enum {
    New      = 'N';
    Booked   = 'B';
    Canceled = 'X';
  };
};

entity BoxStatus : CodeList {
  key code : String enum {
    Open     = 'O';
    Accepted = 'A';
    Canceled = 'X';
  } default 'O'; //> will be used for foreign keys as well
  criticality : Integer; //  2: yellow colour,  3: green colour, 0: unknown
  fieldControl: Integer @odata.Type:'Edm.Byte'; // 1: #ReadOnly, 7: #Mandatory
  createDeleteHidden: Boolean;
}
