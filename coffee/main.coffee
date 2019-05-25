# setup
container = $ "#container"
renderer = new THREE.WebGLRenderer()
# renderer.shadowMapEnabled = true;

width = $(window).width()
heigth = $(window).height()
aspect = width / heigth
                                   # view_angle, aspect,  near, far
camera = new THREE.PerspectiveCamera 45, aspect,  1, 100000
scene = new THREE.Scene()
camera.position.z = 0
renderer.setSize width, heigth
container.append renderer.domElement

controls_enabled = true

if controls_enabled
  clock = new THREE.Clock()
  controls = new THREE.FirstPersonControls(camera)
  controls.lookSpeed = 0.1
  controls.movementSpeed = 1000


random_choose = (array) ->
  rand_order = ->
    Math.round(Math.random()) - 0.5
  array.sort rand_order
  array[0]


add_cube = (scene) ->
  # color = $.xcolor.random()
  color = $.xcolor.greyfilter('#777777');
  # color = random_choose $.xcolor.tetrad('#FF6666')
  cubeMaterial = new THREE.MeshLambertMaterial { color: color.getInt() }

  cube_geom = new THREE.CubeGeometry(200,200,200)
  geom =  cube_geom
  cube = new THREE.Mesh( geom, cubeMaterial )
  basicMaterial = new THREE.MeshBasicMaterial({color: color.getInt()})
  line = new THREE.Line geom, basicMaterial

  cube = new THREE.Mesh cube_geom, basicMaterial

  scene.add cube
  cube

cubes_count = 200
cubes_count--
cubes   = []
positions = []
saved_pos = []

window.cubes = cubes

# draw_cubes
for i in [0..cubes_count]
  cubes[i] = add_cube(scene)

gen_positions = ->
  for i in [0..cubes_count]
    rand = -> Math.random()
    position = {}
    position.x = 300*(rand()-0.5)
    position.y = 300*(rand()-0.5)
    position.z = 300*(rand()-0.5)
    position

positions = gen_positions()


# apply positions
for i in [0..cubes_count]
  cubes[i].position.x = positions[i].x
  cubes[i].position.y = positions[i].y
  cubes[i].position.z = positions[i].z

new_pos = gen_positions()


forward = true

tween = new TWEEN.Tween(new_pos[0]).to(positions[0], 4000)
tween.delay(0)
tween.easing TWEEN.Easing.Quadratic.EaseInOut
# tween.easing TWEEN.Easing.Linear.EaseNone
tween.onUpdate (amount) ->
  set_pos = (axis) ->
    for i in [0..cubes_count]
      delta = new_pos[i][axis] + positions[i][axis]
      delta = delta / 1000
      if forward
        cubes[i].position[axis] += delta * amount
      else
        cubes[i].position[axis] -= delta * amount

  for i in [0..cubes_count]
    set_pos "x"
    set_pos "y"
    set_pos "z"

  render()

tween.onComplete ->
  forward = !forward
  new_pos = gen_positions()

tween.start()
tween.chain tween



anim = ->
  TWEEN.update()
  window.webkitRequestAnimationFrame(anim)


set_light = ->
  pointLight = new THREE.PointLight 0xFFFFFF
  pointLight.position.x = 300
  pointLight.position.y = 1000
  pointLight.position.z = 2300
  pointLight.castShadow = true
  scene.add pointLight

# wtf? http://fhtr.org/BasicsOfThreeJS/#7
#
# renderer.setClearColorHex(0x222222, 1.0)
# camera.lookAt scene.position

render = ->
  controls.update  clock.getDelta() if controls_enabled
  renderer.render scene, camera
  # console.log Math.round(camera.rotation.x), Math.round(camera.rotation.y), Math.round(camera.rotation.z)
  camera.rotation.x = 0
  camera.rotation.y = 0
  camera.rotation.z = 0

set_light()
anim()

render()



# // enable shadows on the renderer
# renderer.shadowMapEnabled = true;
#
# // enable shadows for a light
# light.castShadow = true;
#
# // enable shadows for an object
# litCube.castShadow = true;
# litCube.receiveShadow = true;
