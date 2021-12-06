using BoxService from '../../srv/boxservice';

//
// annotatios that control the fiori layout
//

annotate BoxService.Box with @UI : {

  Identification : [
    { $Type  : 'UI.DataFieldForAction', Action : 'BoxService.acceptBox',   Label  : '{i18n>AcceptTravel}'   },
    { $Type  : 'UI.DataFieldForAction', Action : 'BoxService.rejectBox',   Label  : '{i18n>RejectTravel}'   },
   // { $Type  : 'UI.DataFieldForAction', Action : 'BoxService.deductDiscount', Label  : '{i18n>DeductDiscount}' }
  ],
  HeaderInfo : {
    TypeName       : '{i18n>Travel}',
    TypeNamePlural : '{i18n>Travels}',
    Title          : {
      $Type : 'UI.DataField',
      Value : BoxID
    },
    Description    : {
      $Type : 'UI.DataField',
      Value : '{i18n>TravelID}'
    }
  },
  PresentationVariant : {
    Text           : 'Default',
    Visualizations : ['@UI.LineItem'],
    SortOrder      : [{
      $Type      : 'Common.SortOrderType',
      Property   : BoxID,
      Descending : true
    }]
  },
  SelectionFields : [
    BoxID,
    to_Patient_PatientID,
    BoxStatus_code
  ],
  LineItem : [
    { $Type  : 'UI.DataFieldForAction', Action : 'BoxService.acceptBox',   Label  : '{i18n>AcceptTravel}'   },
    { $Type  : 'UI.DataFieldForAction', Action : 'BoxService.rejectBox',   Label  : '{i18n>RejectTravel}'   },
   // { $Type  : 'UI.DataFieldForAction', Action : 'BoxService.deductDiscount', Label  : '{i18n>DeductDiscount}' },
    { Value : BoxID               },
    { Value : to_Patient_PatientID },
    { Value : BeginDateAusleihe              },
    { Value : EndDateAusleihe                },
    { Value : Boxname           },
    { $Type : 'UI.DataField', Value : BoxStatus_code, Criticality : BoxStatus.criticality }
  ],
  Facets : [{
    $Type  : 'UI.CollectionFacet',
    Label  : '{i18n>Travel}',
    ID     : 'Box',
    Facets : [
      {  // travel details
        $Type  : 'UI.ReferenceFacet',
        ID     : 'BoxData',
        Target : '@UI.FieldGroup#BoxData',
        Label  : '{i18n>Travel}'
      },
      {  // date information
        $Type  : 'UI.ReferenceFacet',
        ID     : 'DateData',
        Target : '@UI.FieldGroup#DateData',
        Label  : '{i18n>Dates}'
      }
      ]
  }, {  // booking list
    $Type  : 'UI.ReferenceFacet',
    Target : 'to_Geraete/@UI.PresentationVariant',
    Label  : '{i18n>Booking}'
  }],
  FieldGroup#BoxData : { Data : [
    { Value : BoxID               },
    { Value : to_Patient_PatientID },
    { Value : Boxname            },
    {
      $Type       : 'UI.DataField',
      Value       : BoxStatus_code,
      Criticality : BoxStatus.criticality,
      Label : '{i18n>Status}' // label only necessary if differs from title of element
    }
  ]},
  FieldGroup #DateData : {Data : [
    { $Type : 'UI.DataField', Value : BeginDateAusleihe },
    { $Type : 'UI.DataField', Value : EndDateAusleihe }
  ]},
};

/*annotate BoxService.Geraete with @UI : {
  Identification : [
    { Value : GeraeteID },
  ],
  HeaderInfo : {
    TypeName       : '{i18n>Bookings}',
    TypeNamePlural : '{i18n>Bookings}',
    Title          : { Value : GeraeteID },
    Description    : {
      $Type : 'UI.DataField',
      Value : '{i18n>BookingID}'
    }
  },
  PresentationVariant : {
    Visualizations : ['@UI.LineItem'],
    SortOrder      : [{
      $Type      : 'Common.SortOrderType',
      Property   : GeraeteID,
      Descending : false
    }]
  },
  SelectionFields : [],
  LineItem : [
    { Value : to_Geraetetyp.AnleitungURL,  Label : '  '},
    { Value : GeraeteID,             Label : '{i18n>BookingNumber}' },
    { Value : to_Patient_PatientID },
    { Value : to_Geraetetyp_GeraetetypID   },
    { Value : ConnectionID,          Label : '{i18n>FlightNumber}' },
    { Value : GeraeteStatus_code     }
  ],
  Facets : [{
    $Type  : 'UI.CollectionFacet',
    Label  : '{i18n>Booking}',
    ID     : 'Geraete',
  }],
  FieldGroup #GeraeteData : { Data : [
    { Value : GeraeteID              },
    { Value : to_Patient_PatientID },
    { Value : to_Geraetetyp_GeraetetypID   },
    { Value : ConnectionID           },
    { Value : GeraeteStatus_code     }
  ]},
};*/


annotate BoxService.Geraete with @UI : {
  Identification : [
    { Value : GeraeteID },
  ],
  HeaderInfo : {
    TypeName       : '{i18n>Bookings}',
    TypeNamePlural : '{i18n>Bookings}',
    Title          : { Value : GeraeteID },
    Description    : {
      $Type : 'UI.DataField',
      Value : '{i18n>BookingID}'
    }
  },
  PresentationVariant : {
    Visualizations : ['@UI.LineItem'],
    SortOrder      : [{
      $Type      : 'Common.SortOrderType',
      Property   : GeraeteID,
      Descending : false
    }]
  },
  SelectionFields : [],
  LineItem : [
    { Value : to_Geraetetyp.AnleitungURL,  Label : '  '},
    { Value : GeraeteID,             Label : '{i18n>BookingNumber}' },
    { Value : to_Patient_PatientID },
    { Value : to_Geraetetyp_GeraetetypID   },
    { Value : ConnectionID,          Label : '{i18n>FlightNumber}' },
    { Value : GeraeteStatus_code     }
  ],
  Facets : [{
    $Type  : 'UI.CollectionFacet',
    Label  : '{i18n>Booking}',
    ID     : 'Geraete',
    Facets : [{  // booking details
      $Type  : 'UI.ReferenceFacet',
      ID     : 'GeraeteData',
      Target : '@UI.FieldGroup#GeraeteData',
      Label  : 'Geraete'
    }]
  }, ],
  FieldGroup #GeraeteData : { Data : [
    { Value : GeraeteID              },
    { Value : to_Patient_PatientID },
    { Value : to_Geraetetyp_GeraetetypID   },
    { Value : ConnectionID           },
    { Value : GeraeteStatus_code     }
  ]},
};


