const cds = require ('@sap/cds'); require('./workarounds')

class BoxService extends cds.ApplicationService {
init() {

  /**
   * Reflect definitions from the service's CDS model
   */
  const { Box, Geraete } = this.entities


  /**
   * Fill in virtual elements to control status of UI elements.
   */
  const _calculateButtonAvailability = any => {
    const status = any.BoxStatus && any.BoxStatus.code || any.BoxStatus_code
    any.acceptEnabled = status !== 'R'
    any.rejectEnabled = status !== 'X'
    any.availableEnabled = status !== 'O'
    //any.deductDiscountEnabled = status === 'O'
  }
  this.after ('each', 'Box', _calculateButtonAvailability)
  this.after ('EDIT', 'Box', _calculateButtonAvailability)


  /**
   * Fill in primary keys for new Boxs.
   * Note: In contrast to Bookings and BookingSupplements that has to happen
   * upon SAVE, as multiple users could create new Boxs concurrently.
   */
  this.before ('CREATE', 'Box', async req => {
    const { maxID } = await SELECT.one `max(BoxID) as maxID` .from (Box)
    req.data.BoxID = maxID + 1
  })


  /**
   * Fill in defaults for new Bookings when editing Boxs.
   */
  this.before ('NEW', 'Geraete', async (req) => {
    const { to_Box_BoxUUID } = req.data
    const { status } = await SELECT `BoxStatus_code as status` .from (Box.drafts, to_Box_BoxUUID)
    if (status === 'X') throw req.reject (400, 'Cannot add new bookings to rejected Boxs.')
    const { maxID } = await SELECT.one `max(GeraeteID) as maxID` .from (Geraete.drafts) .where ({to_Box_BoxUUID})
    req.data.GeraeteID = maxID + 1
    req.data.GeraeteStatus_code = 'N'
   // req.data.BookingDate = (new Date).toISOString().slice(0,10) // today
  })


  /**
   * Fill in defaults for new BookingSupplements when editing Boxs.
   */
/*  this.before ('NEW', 'BookingSupplement', async (req) => {
    const { to_Booking_BookingUUID } = req.data
    const { maxID } = await SELECT.one `max(BookingSupplementID) as maxID` .from (BookingSupplement.drafts) .where ({to_Booking_BookingUUID})
    req.data.BookingSupplementID = maxID + 1
  })*/


  /**
   * Changing Booking Fees is only allowed for not yet accapted Travels.
   */
 /* this.before ('PATCH', 'Travel', async (req) => { if ('BookingFee' in req.data) {
    const { status } = await SELECT `TravelStatus_code as status` .from (req._target)
    if (status === 'A') req.reject(400, 'Booking fee can not be updated for accepted travels.', 'BookingFee')
  }})*/


  /**
   * Update the Travel's TotalPrice when its BookingFee is modified.
   */
/*  this.after ('PATCH', 'Travel', (_,req) => { if ('BookingFee' in req.data) {
    return this._update_totals4 (req.data.TravelUUID)
  }})*/


  /**
   * Update the Travel's TotalPrice when a Booking's FlightPrice is modified.
   */
  /*this.after ('PATCH', 'Booking', async (_,req) => { if ('FlightPrice' in req.data) {
    // We need to fetch the Travel's UUID for the given Booking target
    const { travel } = await SELECT.one `to_Travel_TravelUUID as travel` .from (req._target)
    return this._update_totals4 (travel)
  }})*/


  /**
   * Update the Travel's TotalPrice when a Supplement's Price is modified.
   */
 /* this.after ('PATCH', 'BookingSupplement', async (_,req) => { if ('Price' in req.data) {
    // We need to fetch the Travel's UUID for the given Supplement target
    const { travel } = await SELECT.one `to_Travel_TravelUUID as travel` .from (Booking.drafts)
      .where `BookingUUID = ${ SELECT.one `to_Booking_BookingUUID` .from (BookingSupplement.drafts).where({BookSupplUUID:req.data.BookSupplUUID}) }`
      // .where `BookingUUID = ${ SELECT.one `to_Booking_BookingUUID` .from (req._target) }`
      //> REVISIT: req._target not supported for subselects -> see tests
    return this._update_totals4 (travel)
  }})*/


  /**
   * Helper to re-calculate a Travel's TotalPrice from BookingFees, FlightPrices and Supplement Prices.
   */
  /*this._update_totals4 = function (travel) {
    return UPDATE (Travel.drafts, travel) .with ({ TotalPrice: CXL `coalesce (BookingFee, 0) + ${
      SELECT `coalesce (sum (FlightPrice + ${
        SELECT `coalesce (sum (Price),0)` .from (BookingSupplement.drafts) .where `to_Booking_BookingUUID = BookingUUID`
      }),0)` .from (Booking.drafts) .where `to_Travel_TravelUUID = TravelUUID`
    }` })
  }*/


  /**
   * Validate a Travel's edited data before save.
   */
  this.before ('SAVE', 'Box', req => {
    const { BeginDateAusleihe, EndDateAusleihe } = req.data, today = (new Date).toISOString().slice(0,10)
    if (BeginDateAusleihe < today) req.error (400, `Begin Date ${BeginDateAusleihe} must not be before today ${today}.`, 'in/BeginDateAusleihe')
    if (BeginDateAusleihe > EndDateAusleihe) req.error (400, `Begin Date ${BeginDateAusleihe} must be before End Date ${EndDateAusleihe}.`, 'in/BeginDateAusleihe')
  })


  //
  // Action Implementations...
  //

  this.on ('acceptBox', req => UPDATE (req._target) .with ({BoxStatus_code:'R'}))
  this.on ('rejectBox', req => UPDATE (req._target) .with ({BoxStatus_code:'X'}))
  this.on ('availableBox', req => UPDATE (req._target) .with ({BoxStatus_code:'O'}))
 /* this.on ('deductDiscount', async req => {
    let discount = req.data.percent / 100
    let succeeded = await UPDATE (req._target)
      .where `TravelStatus_code != 'A'`
      .and `BookingFee is not null`
      .with (`
        TotalPrice = round (TotalPrice - BookingFee * ${discount}, 3),
        BookingFee = round (BookingFee - BookingFee * ${discount}, 3)
      `)
    if (!succeeded) { //> let's find out why...
      let travel = await SELECT.one `TravelID as ID, TravelStatus_code as status, BookingFee` .from (req._target)
      if (!travel) throw req.reject (404, `Travel "${travel.ID}" does not exist; may have been deleted meanwhile.`)
      if (travel.status === 'A') req.reject (400, `Travel "${travel.ID}" has been approved already.`)
      if (travel.BookingFee == null) throw req.reject (404, `No discount possible, as travel "${travel.ID}" does not yet have a booking fee added.`)
    } else {
      // Note: it is important to read from this, not db to include draft handling
      // REVISIT: through req._target workaround, IsActiveEntity is non-enumerable, which breaks this.read(Travel, req.params[0])
      const [{ TravelUUID, IsActiveEntity }] = req.params
      return this.read(Travel, { TravelUUID, IsActiveEntity })
    }
  })*/


  // Add base class's handlers. Handlers registered above go first.
  return super.init()

}}
module.exports = {BoxService}