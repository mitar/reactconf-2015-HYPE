Meteor.startup(function () {
  var stats = new MemoryStats();
  stats.domElement.style.position = 'fixed';
  stats.domElement.style.right    = '0px';
  stats.domElement.style.bottom   = '0px';
  document.body.appendChild( stats.domElement );
  requestAnimationFrame(function rAFloop(){
    stats.update();
    requestAnimationFrame(rAFloop);
  })
});
