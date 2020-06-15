-- Michael Gubesch
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
WALL = 0
WALL_VALID = 0

--set size
function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end
sounds = {
    ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
}
--set map
map = {}
map.offset = 20
map.width = WINDOW_WIDTH
map.height = WINDOW_HEIGHT

--set ball
ball = {}
ball.x = WINDOW_WIDTH
ball.y = WINDOW_HEIGHT
ball.vel = {}
ball.vel.x = 3
ball.vel.y = 1
ball.height = 30
ball.width = 30

--player right
a = {}
a.width = 10
a.height = 80
a.y = map.height/2
a.x = map.width-map.offset-10

--player left
b = {}
b.width = 10
b.height = 80
b.y = map.height/2
b.x = map.offset

--player bottom
c = {}
c.width = 120
c.height = 10
c.x = map.width/2
c.y = map.height-map.offset-10

--player top
d = {}
d.width = 120
d.height = 10
d.x = map.width/2
d.y = map.offset

--score
a.score = 0
b.score = 0
c.score = 0
d.score = 0

scoreFont = love.graphics.newFont(45)

function love.update()
	ball.x = ball.x + ball.vel.x
	ball.y = ball.y + ball.vel.y

	--map boundaries
	if ball.x >= (map.width + map.offset) - ball.width then -- into right
		b.score = b.score + 1
    c.score = c.score + 1
    d.score = d.score + 1
    sounds['score']:play()
		ball:reset(-1)
	end
	if ball.x <= map.offset then                           -- into left
		a.score = a.score + 1
    c.score = c.score + 1
    d.score = d.score + 1
    sounds['score']:play()
		ball:reset(1)
	end
  if ball.y >= (map.height + map.offset) - ball.width then -- into top
    b.score = b.score + 1
    d.score = d.score + 1
    a.score = a.score + 1
    sounds['score']:play()
    ball:reset(-1)
  end
  if ball.y <= map.offset then                           -- into bottom
    a.score = a.score + 1
    b.score = b.score + 1
    c.score = c.score + 1
    sounds['score']:play()
    ball:reset(1)
  end
  xxx = -1
  yyy = -1
	--bounce at the wall if one exists
  --love.graphics.rectangle("line", WINDOW_WIDTH/2-map.offset, WINDOW_HEIGHT/2-map.offset, a.width*4, a.width*4)
    if WALL == 1 and ball.y <= WINDOW_HEIGHT/2-4*map.offset+a.width*16 and ball.x <= WINDOW_WIDTH/2-4*map.offset+a.width*16 and ball.y >= WINDOW_HEIGHT/2-5*map.offset-10 and ball.x >= WINDOW_WIDTH/2-map.offset*5-10 then
      xx = math.random(0,9)
      yy = math.random(0,9)
      if xx > 4 then
        xxx = 1
      end
      if yy > 4 then
        yyy = 1
      end
      if WALL_VALID == 1 then
        sounds['wall_hit']:play()
        ball:bounce(xxx,yyy)
      end
    end


	--paddles bounces for the players
	if ball.x > a.x - ball.width and ball.y <= a.y + a.height and ball.y >= a.y - ball.height then   --right
		ball:bounce(-1, 1)
      sounds['paddle_hit']:play()
      WALL_VALID = 1
		ball.x = ball.x - 10
	end
	if ball.x < b.x + 5 and ball.y <= b.y + b.height and ball.y >= b.y - ball.height then --left
		ball:bounce(-1, 1)
      sounds['paddle_hit']:play()
      WALL_VALID = 1
		ball.x = ball.x + 10
	end
  if ball.y > c.y - ball.height and ball.x <= c.x + c.width and ball.x >= c.x - ball.width then --bottom
    ball:bounce(1, -1)
      sounds['paddle_hit']:play()
      WALL_VALID = 1
    ball.y = ball.y - 10
  end
  if ball.y < d.y + 5 and ball.x <= d.x + d.width and ball.x >= d.x - ball.width then --top
    ball:bounce(1, -1)
      sounds['paddle_hit']:play()
      WALL_VALID = 1
    ball.y = ball.y + 10
  end

	--keys for the players
    if love.keyboard.isDown("down") and a.y + a.height < map.height - map.offset then
		a.y = a.y + 4
    end
    if love.keyboard.isDown("up") and a.y > map.offset then
		a.y = a.y - 4
    end
    if love.keyboard.isDown("s") and b.y + b.height < map.height - map.offset then
		b.y = b.y + 4
    end
    if love.keyboard.isDown("w") and b.y > map.offset then
    b.y = b.y - 4
    end
    if love.keyboard.isDown("m") and c.x + c.width < map.width - map.offset then
		c.x = c.x + 6
    end
    if love.keyboard.isDown("n") and c.x > map.offset then
    c.x = c.x - 6
    end
    if love.keyboard.isDown("v") and d.x + d.width < map.width - map.offset then
		d.x = d.x + 6
    end
    if love.keyboard.isDown("c") and d.x > map.offset then
    d.x = d.x - 6
    end
end

--reverse x or y with minus to bounce in x or y direction
function ball:bounce(x, y)
		self.vel.x = x * self.vel.x
		self.vel.y = y * self.vel.y
end

--reset after loose
function ball:reset(x)
--  ball.x = WINDOW_WIDTH / 2 - map.offset
  --ball.y = WINDOW_HEIGHT / 2 - map.offset
WALL_VALID = 0
WALL = 0
--ballSpeed = 650
ballDirection = math.rad(math.random(10, 100))
ballSpeed = math.rad(math.random(1, 60))

--ball.vel.x = math.cos(ballDirection) * ballSpeed *-1*x
--ball.vel.y = math.sin(ballDirection) * ballSpeed

	ball.x = WINDOW_WIDTH/2-map.offset
	ball.y = WINDOW_HEIGHT/2-map.offset
	ball.vel = {}
	ball.vel.x = ballDirection*x
	ball.vel.y = ballSpeed
	ball.height = 30
	ball.width = 30
end

function love.draw()
  random = math.random(1,10000)
  --love.graphics.print(random, 40, 40)
  if random > 9990 then
    WALL = 1
  end
	love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
	love.graphics.rectangle("line", map.offset, map.offset, map.width-map.offset*2, map.height-map.offset*2)
  if WALL == 1 then
    love.graphics.rectangle("line", WINDOW_WIDTH/2-map.offset*4, WINDOW_HEIGHT/2-map.offset*4, a.width*16, a.width*16)
  end

	--draw players paddles
	love.graphics.rectangle("fill", a.x, a.y, a.width, a.height)
	love.graphics.rectangle("fill", b.x, b.y, b.width, b.height)
  love.graphics.rectangle("fill", c.x, c.y, c.width, c.height)
  love.graphics.rectangle("fill", d.x, d.y, d.width, d.height)

  --draw the score
	love.graphics.setFont(scoreFont)

	--draw score
  love.graphics.print("   "..d.score, WINDOW_WIDTH/2-map.offset, 40)
	love.graphics.print(b.score .. " - " .. a.score, WINDOW_WIDTH/2-map.offset, 80)
  love.graphics.print("   "..c.score, WINDOW_WIDTH/2-map.offset, 120)
end
