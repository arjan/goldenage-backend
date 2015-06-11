angular.module('ga-historical-person', [])

  .config(function($interpolateProvider) {
    $interpolateProvider.startSymbol('[[').endSymbol(']]');
  })

  .controller("main", function($scope) {
    
    $scope.add = function(e) {
      $scope.rows.push({key: "", value: ""});
      $scope.updateJson();

      e.preventDefault();
      return false;
    };

    $scope.remove = function(e, idx) {
      $scope.rows.splice(idx, 1);
      $scope.updateJson();

      e.preventDefault();
      return false;
    };

    $scope.updateJson = function(e) {
      var r = [];
      for (var i=0; i<$scope.rows.length; i++) {
        r.push({key: $scope.rows[i].key, value: $scope.rows[i].value});
      }
      $scope.keyvalue = JSON.stringify(r);
    };

    var inp = $("input[name=keyvalue]");
    $scope.rows = JSON.parse(inp.val());
    $scope.updateJson();

  })
;

