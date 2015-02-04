var start = Date.now();
var loadCount = 0;

function getData() {
  // generate some dummy data
  var data = {
    start_at: new Date().getTime() / 1000,
    databases: {}
  };

  for (var i = 1; i <= ENV.rows; i++) {
    data.databases["cluster" + i] = {
      queries: []
    };

    data.databases["cluster" + i + "slave"] = {
      queries: []
    };
  }

  Object.keys(data.databases).forEach(function(dbname) {
    var info = data.databases[dbname];

    var r = Math.floor((Math.random() * 10) + 1);
    for (var i = 0; i < r; i++) {
      var q = {
        canvas_action: null,
        canvas_context_id: null,
        canvas_controller: null,
        canvas_hostname: null,
        canvas_job_tag: null,
        canvas_pid: null,
        elapsed: Math.random() * 15,
        query: "SELECT blah FROM something",
        waiting: Math.random() < 0.5
      };

      if (Math.random() < 0.2) {
        q.query = "<IDLE> in transaction";
      }

      if (Math.random() < 0.1) {
        q.query = "vacuum";
      }

      info.queries.push(q);
    }

    info.queries = info.queries.sort(function(a, b) {
      return b.elapsed - a.elapsed;
    });
  });

  return data;
}

var _base;

(_base = String.prototype).lpad || (_base.lpad = function(padding, toLength) {
  return padding.repeat((toLength - this.length) / padding.length).concat(this);
});

Template.query.helpers({
  className: function () {
    var className = "elapsed short";
    if (this.elapsed >= 10.0) {
      className = "elapsed warn_long";
    }
    else if (this.elapsed >= 1.0) {
      className = "elapsed warn";
    }
    return className;
  },

  formatElapsed: function (value) {
    var str = parseFloat(value).toFixed(2);
    if (value > 60) {
      var minutes = Math.floor(value / 60);
      var comps = (value % 60).toFixed(2).split('.');
      var seconds = comps[0].lpad('0', 2);
      var ms = comps[1];
      str = minutes + ":" + seconds + "." + ms;
    }
    return str;
  }
});

Template.sample.helpers({
  countClassName: function () {
    var countClassName = "label";
    if (this.queries.length >= 20) {
      countClassName += " label-important";
    }
    else if (this.queries.length >= 10) {
      countClassName += " label-warning";
    }
    else {
      countClassName += " label-success";
    }
    return countClassName;
  },

  topFiveQueries: function () {
    var topFiveQueries = this.queries.slice(0, 5);
    while (topFiveQueries.length < 5) {
      topFiveQueries.push({ query: "" });
    }
    return topFiveQueries;
  }
});

Template.database.helpers({
  lastSample: function () {
    return this.samples[this.samples.length - 1];
  }
});

Template.dbmon.created = function () {
  this._databases = new ReactiveVar({});

  this._loadSamples = function () {
    var databases = this._databases.get();

    loadCount++;
    var newData = getData();

    Object.keys(newData.databases).forEach(function(dbname) {
      var sampleInfo = newData.databases[dbname];

      if (!databases[dbname]) {
        databases[dbname] = {
          name: dbname,
          samples: []
        }
      }

      var samples = databases[dbname].samples;
      samples.push({
        time: newData.start_at,
        queries: sampleInfo.queries
      });
      if (samples.length > 5) {
        samples.splice(0, samples.length - 5);
      }
    }.bind(this));

    this._databases.set(databases);

    Meteor.setTimeout(this._loadSamples, ENV.timeout);
  }.bind(this);
};

Template.dbmon.rendered = function () {
  this._loadSamples();
};

Template.dbmon.helpers({
  databases: function () {
    var databasesArray = [];
    var databases = Template.instance()._databases.get();
    Object.keys(databases).forEach(function(dbname) {
      databasesArray.push({
        dbname: dbname,
        samples: databases[dbname].samples
      });
    });
    return databasesArray;
  }
});
