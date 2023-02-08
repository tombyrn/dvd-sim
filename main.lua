-- set specifications of window
love.window.setMode(800, 600, {resizable=true, centered=true, minwidth=400, minheight=200})
love.window.setTitle('DVD')

-- define our colors for drawing the dvd logo
colors = {}
colors[0] = {1,1,0,1} --yellow
colors[1] = {0,1,1,1} --cyan
colors[2] = {1,0,0,1} --red
colors[3] = {1,0,1,1} --pink
colors[4] = {0.5,0,1,1} --violet
colors[5] = {0,0,1,1} --darkblue
colors[6] = {0,1,0,1} --green
colors[7] = {1,0.5,0,1} --orange
colors[8] = {1,1,1,1} --white
colors[9] = {0,0,0,1} --black

bg_color = colors[9] --set default background color to black
dvd_color = colors[8] --set default dvd color to white

-- load the dvd logo image
dvd_logo = love.graphics.newImage("dvd.png")
dvd_width = dvd_logo:getWidth() --width in pixels of the png file
dvd_height = dvd_logo:getHeight() --height in pixels of the png file


--LOVE2D LOAD--
-- called once when the program is run, then whenever the user hits the spacebar
love.load = function()
    
    -- get the screen_height and screen_width of the window
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()
    
    -- create a new world
    world = love.physics.newWorld(0, 0)
    world:setCallbacks(bump) --set the collsion handler (bump called on startOfContact)
    
    -- create the four boundary objects for collision detection
    top_bound = {}
    top_bound.body = love.physics.newBody(world, screen_width/2, 0, 'static') --create a new body in the world at (x,y)
    top_bound.shape = love.physics.newRectangleShape(screen_width, 0) --create a new shape of screen_width and screen_height
    top_bound.fixture = love.physics.newFixture(top_bound.body, top_bound.shape) --attach the body and shape together

    bottom_bound = {}
    bottom_bound.body = love.physics.newBody(world, screen_width/2, screen_height, 'static')
    bottom_bound.shape = love.physics.newRectangleShape(screen_width, 0)
    bottom_bound.fixture = love.physics.newFixture(bottom_bound.body, bottom_bound.shape)

    left_bound = {}
    left_bound.body = love.physics.newBody(world, 0, screen_height/2, 'static')
    left_bound.shape = love.physics.newRectangleShape(0, screen_height)
    left_bound.fixture = love.physics.newFixture(left_bound.body, left_bound.shape)

    right_bound = {}
    right_bound.body = love.physics.newBody(world, screen_width, screen_height/2, 'static')
    right_bound.shape = love.physics.newRectangleShape(0, screen_height)
    right_bound.fixture = love.physics.newFixture(right_bound.body, right_bound.shape)

    -- create the bouncing dvd logo 
    dvd_object = {}
    dvd_object.body = love.physics.newBody(world, screen_width/2, screen_height/2, 'dynamic') --set body type to 'dyanmic' so it can move
    dvd_object.body:setLinearVelocity(love.math.random(100, 200)*one_or_negative_one(), love.math.random(100, 200)*one_or_negative_one()) --set the speed/direction randomly
    dvd_object.shape = love.physics.newRectangleShape(dvd_width, dvd_height)
    dvd_object.fixture = love.physics.newFixture(dvd_object.body, dvd_object.shape)
    dvd_object.fixture:setRestitution(1) --set the object to not lose momentum on collision
    dvd_object.fixture:setFriction(0) --zero out friction so it doesn't slow down on collision
    dvd_object.fixture:setUserData(dvd_logo) --associate variable to fixture so it can be retrieved later
    
end

--LOVE2D DRAW--
-- called each frame, controls whats painted on the window
love.draw = function()

    -- draw black background
    love.graphics.setColor(bg_color)
    love.graphics.polygon('fill', 0, 0, screen_width, 0, screen_width, screen_height, 0, screen_height)
    -- draw boundaries
    love.graphics.polygon('line', top_bound.body:getWorldPoints(top_bound.shape:getPoints()))
    love.graphics.polygon('line', bottom_bound.body:getWorldPoints(bottom_bound.shape:getPoints()))
    love.graphics.polygon('line', left_bound.body:getWorldPoints(left_bound.shape:getPoints()))
    love.graphics.polygon('line', right_bound.body:getWorldPoints(right_bound.shape:getPoints()))

    -- draw dvd logo
    love.graphics.setColor(dvd_color)
    love.graphics.draw(dvd_object.fixture:getUserData(), dvd_object.body:getX()- (dvd_width/2), dvd_object.body:getY()-(dvd_height/2), 0)

end

--LOVE2D UPDATE--
-- called constantly
love.update = function(dt)

    -- updates the state of the world
    world:update(dt) --without this it would be like time is frozen
    
end

--LOVE2D KEYPRESSED--
-- input handler
love.keypressed = function(pressed_key, scancode)

    if pressed_key == 'escape' then --exit 
        love.event.quit()
    elseif pressed_key == 'space' then --reset
        love.load()
    elseif scancode == "b" then --set background black
        bg_color = {0,0,0,1}
    elseif scancode == "w" then --set background white
        bg_color = {1,1,1,1}
    elseif scancode == "m" then --minimize window
        love.window.minimize()
    end

end

--LOVE2D RESIZE--
-- window resize handler, called whenever user resizes window
love.resize = function()
    love.load()
end

-- collision handler (called on start of contact)
bump = function()
    
    -- chooses a random color that is not the same as the current color
    color_seed = love.math.random(0, 7)
    if dvd_color == colors[color_seed] then
        bump()
    else
        dvd_color = colors[color_seed]
    end

end

-- returns either a 1 or a negative 1 (for randomizing direction)
one_or_negative_one = function()
    i = love.math.random()
    if i > 0.5 then
        return 1
    else 
        return -1
    end 
end