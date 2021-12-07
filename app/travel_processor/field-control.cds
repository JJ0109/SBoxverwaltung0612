using BoxService from '../../srv/boxservice';

//
// annotations that control the behavior of fields and actions
//

// Workarounds for overly strict OData libs and clients
annotate cds.UUID with @Core.Computed  @odata.Type : 'Edm.String';

// Add fields to control enablement of action buttons on UI
extend projection BoxService.Box with {
  // REVISIT: shall be improved by omitting "null as"
  virtual null as acceptEnabled         : Boolean @UI.Hidden,
  virtual null as rejectEnabled         : Boolean @UI.Hidden,
  virtual null as availableEnabled         : Boolean @UI.Hidden,
//  virtual null as deductDiscountEnabled : Boolean @UI.Hidden,
}

annotate BoxService.Box with /* @(Common.SideEffects: {
  SourceProperties: [BookingFee],
  TargetProperties: ['TotalPrice']
})*/{
//  BookingFee  @Common.FieldControl  : BoxStatus.fieldControl;
  BeginDateAusleihe   @Common.FieldControl  : BoxStatus.fieldControl;
  EndDateAusleihe     @Common.FieldControl  : BoxStatus.fieldControl;
//  to_Agency   @Common.FieldControl  : BoxStatus.fieldControl;
  to_Patient @Common.FieldControl  : BoxStatus.fieldControl;

} actions {
  rejectBox @(
    Core.OperationAvailable : in.rejectEnabled,
    Common.SideEffects.TargetProperties : [
      'in/BoxStatus_code',
      'in/acceptEnabled',
      'in/rejectEnabled',
      'in/availableEnabled',
    ],
  );
  acceptBox @(
    Core.OperationAvailable : in.acceptEnabled,
    Common.SideEffects.TargetProperties : [
      'in/BoxStatus_code',
      'in/acceptEnabled',
      'in/rejectEnabled',
      'in/availableEnabled'
    ],
  );
  availableBox @(
    Core.OperationAvailable : in.availableEnabled,
    Common.SideEffects.TargetProperties : [
      'in/BoxStatus_code',
      'in/acceptEnabled',
      'in/rejectEnabled',
      'in/availableEnabled'
    ],
  );  
/*  deductDiscount @(
    Core.OperationAvailable : in.deductDiscountEnabled,
    Common.SideEffects.TargetProperties : ['in/deductDiscountEnabled'],
  );*/
}

annotate BoxService.Geraete with @UI.CreateHidden : to_Box.BoxStatus.createDeleteHidden;

annotate BoxService.Geraete {
 ConnectionID  @Common.FieldControl  : to_Box.BoxStatus.fieldControl;
 // FlightDate    @Common.FieldControl  : to_Box.BoxStatus.fieldControl;
 // FlightPrice   @Common.FieldControl  : to_Box.BoxStatus.fieldControl;
  GeraeteStatus @Common.FieldControl  : to_Box.BoxStatus.fieldControl;
  to_Geraetetyp    @Common.FieldControl  : to_Box.BoxStatus.fieldControl;
  to_Patient   @Common.FieldControl  : to_Box.BoxStatus.fieldControl;
};

/*annotate BoxService.GeraeteSupplement {
  Price         @Common.FieldControl  : to_Box.BoxStatus.fieldControl;
  to_Supplement @Common.FieldControl  : to_Box.BoxStatus.fieldControl;
  to_Booking    @Common.FieldControl  : to_Box.BoxStatus.fieldControl;
  to_Box     @Common.FieldControl  : to_Box.BoxStatus.fieldControl;

};*/

//annotate Currency with @Common.UnitSpecificScale : Decimals;
