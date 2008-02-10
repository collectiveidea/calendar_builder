// calendar.js
// Requires iso6801.js, prototype.js

var Calendar = Class.create({

  initialize: function(id, options) {
    this.element = $(id);
    this.loading();
    
    this.events = this.findEventElements().collect(function(vevent) {
      vevent.hide();
      return new CalendarEvent(this, vevent);
    }.bind(this)).sortBy(function(event) { return event.startMinutes(); });

    this.options = Object.extend({ 
      hourMultiplier: 5.0,
      offsetPercent: 3.0,
      showLabels: true,
      beginHour: this.events.size() > 0 ? this.events.first().begin.getHours() : 8,
      endHour: this.events.size() > 0 ? this.latestEvent().end.getHours() : 18
    }, options || {});
    
    // Set begin
    this.begin = (this.events.size() > 0 ? this.events[0].begin : new Date()).change({hour: this.options.beginHour});
    // Set end
    this.end = (this.events.size() > 0 ? this.events[0].begin : new Date()).change({hour: this.options.endHour});
    
    this.draw();
    this.loaded();
  },
  
  loading: function() {
    id = this.element.id + '-loading-calendar'
    this.element.insert('<div id="' + id + '">Loading...</div>', {position: 'after'});
  },
  
  loaded: function() {
    $(this.element.id + '-loading-calendar').remove();
    this.events.each(function(event) { event.element.show(); });
  },
  
  unload: function() {
    this.events.invoke('unload');
  },
  
  findEventElements: function() {
    return this.element.getElementsByClassName('vevent').select(function(element) {
      return element.visible();
    });
  },
  
  latestEvent: function() {
    return this.events.sortBy(function(event) { return event.endMinutes(); }).last();
  },
  
  buildLabels: function() {
    $$('#' + this.element.id + ' .labels').invoke('remove');
    time = new Date(this.begin.valueOf());
    labels = $(document.createElement('div'));
    labels.addClassName('labels');
    while (time.valueOf() <= this.end.valueOf()) {
      var hours = time.getHours();
      ampm = (hours >= 12 && hours != 24) ? 'pm' : 'am'
      if(hours > 12) { hours = hours - 12; }

      label = $(document.createElement('div'));
      label.addClassName(time.getHours() % 2 ? 'even' : 'odd');
      label.innerHTML = '<p>' + hours + ' ' + ampm + '</p>';
      label.style.top = (time.minutesSinceMidnight()/60.0 - this.options.beginHour) * this.options.hourMultiplier + 'em';
      label.style.height = this.options.hourMultiplier + 'em';
      labels.appendChild(label);
      time.setHours(time.getHours() + 1);
    }
    this.element.insertBefore(labels, this.element.firstChild);
  },
  
  height: function() {
    return (this.options.endHour - this.options.beginHour + 1) * this.options.hourMultiplier + 'em';
  },
  
  draw: function() {
    this.element.style.height = this.height();
    if(this.options.showLabels) {
      this.buildLabels();
    }
    // this.events.invoke('draw');
    for(var i = 0; i < this.events.length; i++) {
      this.events[i].draw();
    }
  },
  
  inspect: function() {
    return "<Calendar: " + this.events.inspect() + ">"
  }
  
});

var CalendarEvent = Class.create({
    
  initialize: function(calendar, element) {
    this.calendar = calendar;
    this.element = element;
    this.begin = Date.parseISO8601(element.select('abbr.dtstart')[0].title);
    dtend = Element.getElementsBySelector(element, 'abbr.dtend')[0];
    if (dtend) {
      this.end = Date.parseISO8601(dtend.title);
    }
    else {
      this.end = this.begin.change({hour: this.begin.getHours() + 1});
    }
    this.mouseoverListener = this.mouseover.bindAsEventListener(this);
    this.mouseoutListener = this.mouseout.bindAsEventListener(this);
    this.element.observe('mouseover', this.mouseoverListener);
    this.element.observe('mouseout', this.mouseoutListener);
  },
  
  unload: function() {
    Event.stopObserving(this.element, 'mouseover', this.mouseoverListener);
    Event.stopObserving(this.element, 'mouseout', this.mouseoutListener);
  },
  
  mouseover: function(event) {
    this.element.addClassName('active');
    this.element.style.minHeight = this.height() + 'em';
    this.element.style.height = 'auto';
    this.element.style.zIndex = 1000;
  },
  
  mouseout: function(event) {
    element = Event.element(event);
    var related = (event.relatedTarget) ? event.relatedTarget : event.toElement;
    while (related && related != element && related.nodeName != 'BODY') {
      related = related.parentNode
    }
    if (related == element) return;

    this.element.removeClassName('active');
    this.draw();
  },
  
  startMinutes: function() {
    return this.begin.minutesSinceMidnight();
  },
  
  endMinutes: function() {
    return this.end.minutesSinceMidnight();
  },
  
  duration: function() {
    return (this.end.valueOf() - this.begin.valueOf()) / 60000
  },
  
  // Other Events
  sameTimeEvents: function() {
    return this._sameTimeEvents = this._sameTimeEvents || this.calendar.events.select(function(e) {
      return e.begin.valueOf() == this.begin.valueOf();
    }.bind(this)).sortBy(function(e) { 1/e.endMinutes() });
  },
  
  // Does this event overlap the start time of another event?
  overlaps: function() {
    return this._overlaps = this._overlaps || this.calendar.events.any(function(e) {
      return e.begin.valueOf() > this.begin.valueOf() && e.begin.valueOf() < this.end.valueOf() && 
        e.end.valueOf() > this.end.valueOf();
    }.bind(this));
  },
  
  // Does this event get overlapped by the end time of another event?
  overlapped: function() {
    return this._overlapped = this._overlapped || this.calendar.events.any(function(e) {
      return e.begin.valueOf() < this.begin.valueOf() && e.end.valueOf() > this.begin.valueOf() && 
        e.end.valueOf() < this.end.valueOf();
    }.bind(this));
  },
  
  // Display methods
  width: function() {
    var events = this.sameTimeEvents();
    var width = 100/events.size();
    if (this.overlaps() || this.overlapped()) {
      width -= this.calendar.options.offsetPercent/events.size();
    }
    return width;
  },
  
  top: function() {
    return (this.startMinutes()/60.0 - this.calendar.options.beginHour) * this.calendar.options.hourMultiplier;
  },
  
  left: function() {
    var events = this.sameTimeEvents();
    var left = this.width() * events.indexOf(this);
    if (this.overlapped()) {
      left += this.calendar.options.offsetPercent/events.size();
    }
    return left;
  },
  
  height: function() {
    return this.duration()/60.0 * this.calendar.options.hourMultiplier;
  },
  
  draw: function() {
    this.element.style.width   = this.width() + '%';
    this.element.style.left    = this.left() + '%';
    this.element.style.top     = this.top() + 'em';
    this.element.style.height  = this.height() + 'em';
    this.element.style.zIndex  = this.calendar.events.indexOf(this) + 1;
  },
  
  inspect: function() {
    return "#<CalendarEvent: element='" + this.element.inspect() + "'>"
  }
});
