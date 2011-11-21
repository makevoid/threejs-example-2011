# setup

container = $ "#container"
renderer = new THREE.WebGLRenderer()


width = $(window).width()
heigth = $(window).height()
aspect = width / heigth
                                   # view_angle, aspect,  near, far 
camera = new THREE.PerspectiveCamera 45, aspect,  1, 10000
scene = new THREE.Scene()
camera.position.z = 3000
renderer.setSize width, heigth
container.append renderer.domElement

controls_enabled = false
# controls_enabled = true

if controls_enabled
  clock = new THREE.Clock()
  controls = new THREE.FirstPersonControls(camera)
  controls.lookSpeed = 0.1
  controls.movementSpeed = 1000

# draw



random_choose = (array) ->
  rand_order = ->
    Math.round(Math.random()) - 0.5
  array.sort rand_order
  array[0]

add_sphere = (scene) ->
  # color = $.xcolor.random()
  color = random_choose $.xcolor.tetrad('#FF6666')
  sphereMaterial = new THREE.MeshLambertMaterial { color: color.getInt() }
  radius = 30
  segments = 16
  rings = 16
  geom = new THREE.SphereGeometry(radius, segments, rings)
  sphere = new THREE.Mesh( geom, sphereMaterial )
  
  geom =  new THREE.Geometry()
  geom.vertices.push(  new THREE.Vertex( new THREE.Vector3(1,2,3)))
  geom.vertices.push(  new THREE.Vertex( new THREE.Vector3(1,3,9)))
  geom.vertices.push(  new THREE.Vertex( new THREE.Vector3(2,4,12)))
  cube_geom = new THREE.CubeGeometry(50,50,50)
  
  basicMaterial = new THREE.MeshBasicMaterial({color: color.getInt()})
  line = new THREE.Line geom, basicMaterial
  
  cube = new THREE.Mesh cube_geom, basicMaterial
  
  scene.add sphere
  # scene.add line  
  # scene.add cube
  sphere
  # cube
  # line

spheres_count = 100
spheres_count--
spheres   = []
positions = []
saved_pos = []

window.spheres = spheres

# draw_spheres
for i in [0..spheres_count]
  spheres[i] = add_sphere(scene)

gen_positions = ->
  for i in [0..spheres_count]
    rand = -> Math.random()
    position = {}
    position.x = 100*(rand()-0.5)
    position.y = 100*(rand()-0.5)
    position.z = 100*(rand()-0.5)
    position

positions = gen_positions()


# apply positions
for i in [0..spheres_count]
  spheres[i].position.x = positions[i].x
  spheres[i].position.y = positions[i].y
  spheres[i].position.z = positions[i].z

new_pos = gen_positions()



forward = true

tween = new TWEEN.Tween(new_pos[0]).to(positions[0], 800)
tween.delay(0)
tween.easing TWEEN.Easing.Quadratic.EaseInOut
# tween.easing TWEEN.Easing.Linear.EaseNone
tween.onUpdate (amount) ->
  set_pos = (axis) ->
    for i in [0..spheres_count]
      delta = new_pos[i][axis] + positions[i][axis] 
      delta = delta / 1000
      if forward 
        spheres[i].position[axis] += delta * amount
      else
        spheres[i].position[axis] -= delta * amount
   
  for i in [0..spheres_count]    
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
  pointLight.position.x = 10
  pointLight.position.y = 50
  pointLight.position.z = 130
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