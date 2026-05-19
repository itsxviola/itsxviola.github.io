function download() {

  // get all cubes
  ALL_CUBES = [];

  for (var i = 0; i<r.Ha.length; i++) {
    // note: r.Ha are all objects in the scene

    var color = r.Ha[i].color;
    var matrix = r.Ha[i].transform.matrix;
    ALL_CUBES.push([color, matrix]);

  }


  // create JSON object
  var out = {};
  out['cubes'] = ALL_CUBES;
  out['camera'] = r.camera.view;

  // from https://stackoverflow.com/a/30800715
  var dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(out));

  var downloadAnchorNode = document.createElement('a');
  downloadAnchorNode.setAttribute("href",     dataStr);
  downloadAnchorNode.setAttribute("download", "scene.json");
  document.body.appendChild(downloadAnchorNode); // required for firefox
  downloadAnchorNode.click();
  downloadAnchorNode.remove();

}

function upload(scene) {

  var req = new XMLHttpRequest();
  req.responseType = 'json';
  req.open('GET', scene, true);
  req.onload  = function() {
    loaded = req.response;

    // parse cubes
    for (var cube in loaded['cubes']) {

      cube = loaded['cubes'][cube];

      color = cube[0];
      matrix = cube[1];

      loaded_cube = new X.cube();
      loaded_cube.color = color;
      loaded_cube.transform.matrix = new Float32Array(Object.values(matrix));
      loaded_cube.lengthX = loaded_cube.lengthY = loaded_cube.lengthZ = CUBE_SIDELENGTH;

      r.add(loaded_cube);

    }

    // restore camera
    r.camera.view = new Float32Array(Object.values(loaded['camera']));


  };
  req.send(null);
  
}

