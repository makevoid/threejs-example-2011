# setup

container = $ "#container"
renderer = new THREE.WebGLRenderer()


width = $(window).width()
heigth = $(window).height()
aspect = width / heigth
                                   # view_angle, aspect,  near, far 
camera = new THREE.PerspectiveCamera 45, aspect,  0.1, 10000
scene = new THREE.Scene()
camera.position.z = 3000
renderer.setSize width, heigth
container.append renderer.domElement


# draw



random_choose = (array) ->
  rand_order = ->
    Math.round(Math.random()) - 0.5
  array.sort rand_order
  array[0]

add_sphere = (scene) ->
  # color = $.xcolor.random()
  color = random_choose $.xcolor.tetrad('#FF0000')
  sphereMaterial = new THREE.MeshLambertMaterial { color: color.getInt() }
  radius = 50
  segments = 16
  rings = 16
  sphere = new THREE.Mesh( new THREE.SphereGeometry(radius, segments, rings), sphereMaterial)
  scene.add sphere
  sphere

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
    position.x = 200*(rand()-0.5)
    position.y = 200*(rand()-0.5)
    position.z = 200*(rand()-0.5)
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
  
render = ->
  renderer.render scene, camera  

set_light()
anim()

render()