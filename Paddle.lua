Paddle = Class{};

function Paddle:init(x,y,width,height,keyup,keydown)
    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height;
    self.keyup = keyup;
    self.keydown = keydown;
    self.speed = 200;
end

function Paddle:update(dt)
    if love.keyboard.isDown(self.keyup) then
        self.y = math.max( 0, self.y + -self.speed * dt);
    end
    if love.keyboard.isDown(self.keydown) then
        self.y = math.min( VIRTUAL_HEIGHT - 55, self.y + self.speed * dt);
    end
end

function Paddle:render()
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height);
end