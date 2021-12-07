using { slah.db as schema } from '../../db/schema';

//
// annotations that control rendering of fields and labels
//

annotate schema.Box with @title: '{i18n>Travel}' {
  BoxUUID   @UI.Hidden;
  BoxID     @title: '{i18n>TravelID}';
  BeginDateAusleihe    @title: '{i18n>BeginDate}';
  EndDateAusleihe      @title: '{i18n>EndDate}';
  Boxname  @title: '{i18n>Description}';
  BoxStatus @title: '{i18n>TravelStatus}'  @Common.Text: BoxStatus.name     @Common.TextArrangement: #TextOnly;
  to_Patient  @title: '{i18n>CustomerID}'    @Common.Text: to_Patient.Nachname  @Common.TextArrangement: #TextFirst;
}

annotate schema.BoxStatus with {
  code @Common.Text: name @Common.TextArrangement: #TextOnly
}

annotate schema.Geraete with @title: '{i18n>Booking}' {
  GeraeteUUID   @UI.Hidden;
  to_Box     @UI.Hidden;
  GeraeteID     @title: '{i18n>BookingID}';
  ConnectionID  @title: '{i18n>ConnectionID}';
  GeraeteStatus @title: '{i18n>BookingStatus}'  @Common.Text: GeraeteStatus.name    @Common.TextArrangement: #TextOnly;
  to_Geraetetyp    @title: '{i18n>AirlineID}'      @Common.Text: to_Geraetetyp.Bezeichnung       @Common.TextArrangement: #TextFirst;
  to_Patient   @title: '{i18n>CustomerID}'     @Common.Text: to_Patient.Nachname  @Common.TextArrangement: #TextFirst;
}

annotate schema.GeraeteStatus with {
  code @Common.Text : name @Common.TextArrangement: #TextOnly
}

/*annotate schema.BookingSupplement with @title: '{i18n>BookingSupplement}' {
  BookSupplUUID        @UI.Hidden;
  to_Booking           @UI.Hidden;
  to_Travel            @UI.Hidden;
  to_Supplement        @title: '{i18n>SupplementID}'  @Common.Text: to_Supplement.Description @Common.TextArrangement: #TextFirst;
  Price                @title: '{i18n>Price}'         @Measures.ISOCurrency: CurrencyCode_code;
  BookingSupplementID  @title: '{i18n>BookingSupplementID}';
  CurrencyCode         @title: '{i18n>CurrencyCode}';
}*/

/*annotate schema.TravelAgency with @title: '{i18n>TravelAgency}' {
  AgencyID     @title: '{i18n>AgencyID}'      @Common.Text: Name @Common.TextArrangement: #TextFirst;
  Name         @title: '{i18n>AgencyName}';
  Street       @title: '{i18n>Street}';
  PostalCode   @title: '{i18n>PostalCode}';
  City         @title: '{i18n>City}';
  CountryCode  @title: '{i18n>CountryCode}';
  PhoneNumber  @title: '{i18n>PhoneNumber}';
  EMailAddress @title: '{i18n>EMailAddress}';
  WebAddress   @title: '{i18n>WebAddress}';
}*/

annotate schema.Patient with @title: '{i18n>Passenger}' {
  PatientID   @title: '{i18n>CustomerID}'    @Common.Text: Nachname @Common.TextArrangement: #TextFirst;
  Vorname    @title: '{i18n>FirstName}';
  Nachname     @title: '{i18n>LastName}';
  Anrede        @title: '{i18n>Title}';
  Strasse       @title: '{i18n>Street}';
  Plz   @title: '{i18n>PostalCode}';
  Stadt         @title: '{i18n>City}';
  CountryCode  @title: '{i18n>CountryCode}';
  Telefonnr  @title: '{i18n>PhoneNumber}';
  EMail @title: '{i18n>EMailAddress}';
}

annotate schema.Geraetetyp with @title: '{i18n>Airline}' {
  GeraetetypID    @title: '{i18n>AirlineID}'     @Common.Text: Bezeichnung @Common.TextArrangement: #TextFirst;
  Bezeichnung         @title: '{i18n>Name}';
}

annotate schema.GVerbindung with @title: '{i18n>Flight}' {
  GeraetetypID     @title: '{i18n>AirlineID}';
  ConnectionID  @title: '{i18n>ConnectionID}';
}


