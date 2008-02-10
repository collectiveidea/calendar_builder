// Date methods from 
// http://delete.me.uk/2005/03/iso8601.html
// http://mikewest.org/projects/files/PerfectTime/PerfectTime.js
//

// Parse ISO 8601 type times (e.g. hCalendar)
//     based on Paul Sowden's method, tweaked to match up 
//     with 'real world' hCalendar usage:
//
//         http://delete.me.uk/2005/03/iso8601.html
//
Object.extend(Date, {
  ISO8601Regex: /(\d{4})(?:-?(\d{2})(?:-?(\d{2})(?:T(\d{2}):?(\d{2})(?::?(\d{2})(?:[.]?(\d+))?)?(?:Z|(?:([+-])(\d{2}):?(\d{2}))?)?)?)?)?/,
  
  parseISO8601: function(string) {
    var match = string.match(Date.ISO8601Regex);
    
    var date = new Date(
      match[1],             // year
      (match[2] || 1) - 1,  // month - 1:  Because JS months are 0-11
      match[3] || 1,        // day
      match[4] || null,     // hour
      match[5] || null,     // minute
      match[6] || null,     // second
      // Must be between 0 and 999
      match[7] ? Number("0." + match[7]) * 1000 : null // millisecond
    );

    var offset = 0;
    if (match[8]) {
      offset = (Number(match[9]) * 60 + Number(match[10]));
      if (match[8] == "+") { offset *= -1; }
    }

    date.adjustTimezoneOffset(offset - date.getTimezoneOffset());
    return date;
  }
});

Object.extend(Date.prototype, {
  minutesSinceMidnight: function() {
    return this.getHours() * 60 + this.getMinutes();
  },
  
  adjustTimezoneOffset: function(offset) {
    this.setTime(Number(this) + (offset * 60 * 1000));
    return this
  },
  
  adjustCurrentTimezoneOffset: function() {
    return this.adjustTimezoneOffset(-this.getTimezoneOffset());
  },
  
  /* Returns a new Time where one or more of the elements have been changed according
   * to the +options+ parameter. The time options (hour, minute, sec, usec) reset
   * cascadingly, so if only the hour is passed, then minute, sec, and usec is set to 0.
   * If the hour and minute is passed, then sec and usec is set to 0.
   */
  change: function(options) {
    return new Date(
      options.year  || this.getFullYear(),
      (options.month ? options.month - 1 : this.getMonth()),
      options.day   || this.getDay(),
      options.hour  || this.getHours(),
      options.min   || (options.hour ? 0 : this.getMinutes()),
      options.sec   || ((options.hour || options.min) ? 0 : this.getSeconds()),
      options.usec  || ((options.hour || options.min || options.sec) ? 0 : this.getMilliseconds())
    )
  }
});