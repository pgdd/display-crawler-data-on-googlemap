Template.dataTable.helpers({
  searchs: function() {
    return Searchs.find();
  }
});

Template.dataTable.helpers({
  settings: function() {
    return Settings.find();
  }
});