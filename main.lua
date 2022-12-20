push = require 'push';
Class = require 'class';

require 'Paddle';
require 'Ball';

WINDOW_HEIGHT = 720;
WINDOW_WIDTH = 1280;

VIRTUAL_WIDTH = 1280;
VIRTUAL_HEIGHT = 720;

message = "Hello Pong";

player1Score = 0;
player2score = 0;

collision = 'no';

--Debugowanie piłki t - włącz y - wyłącz, Uruchomienie w trybie debugowania u - włącz i - wyłącz
function love.load()
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = true,
        vsync = true})
    font = love.graphics.newFont(20);
    love.graphics.setFont(font);
    math.randomseed(os.time());

    ball = Ball(VIRTUAL_WIDTH/2,VIRTUAL_HEIGHT/2,20,20);
    paddle1 = Paddle(40,VIRTUAL_HEIGHT/2 - 25,15,50,'up','down');
    paddle2 = Paddle(VIRTUAL_WIDTH - 55,VIRTUAL_HEIGHT/2 - 25,15,50,'w','s');
    gameState = 'start';
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit();
    end
    if key == 'enter' or key == 'return' then
        if gameState == 'play' then
            gameState = 'start';
        else
            gameState = 'play';
            ball:reset();
        end
    end
    if key == 't' then
        gameState = 'debug';
    end
    if key == 'y' then
        gameState = 'start';
    end
    if key == 'u' then
        gameState = 'startDebug';
        ball:reset();
    end
    if key == 'i' then
        gameState = 'start'
    end
end

function love.update(dt)
    paddle1:update(dt);
    paddle2:update(dt);
    if gameState == 'play' or gameState == 'startDebug' then
        ball:update(dt);
        if ball:colides(paddle1) then
            ball.dx = -ball.dx * 1.03;
            ball.x = paddle1.x + paddle1.width + 5;

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150);
            else
                ball.dy = math.random(10, 150);
            end
        end

        if ball.x <= 0 then
            player1Score = player1Score + 1;
            ball:reset();
        end
        if ball.x >= VIRTUAL_WIDTH then
            player2score = player2score + 1;
            ball:reset();
        end

        if ball:colides(paddle2) then
            ball.dx = -ball.dx * 1.03;
            ball.x = paddle2.x - paddle2.width - 4;

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150);
            else
                ball.dy = math.random(10, 150);
            end
        end

        if ball.y <= 0 then
            ball.y = 0;
            ball.dy = -ball.dy;
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4;
            ball.dy = -ball.dy;
        end

        if gameState == 'startDebug' then
            if(ball:colides(paddle1) or ball:colides(paddle2)) then
                collision = 'yes';
            else
                collision = 'no';
            end
        end
    end
    if gameState == 'debug' then
        if love.keyboard.isDown('a') then
            ball.x = ball.x - 1;
        end
        if love.keyboard.isDown('d') then
            ball.x = ball.x + 1;
        end
        if(ball:colides(paddle1) or ball:colides(paddle2)) then
            collision = 'yes';
        else
            collision = 'no';
        end
    end
end

function love.draw()
    line = 30;

    --Text
    love.graphics.printf(message,0,line,VIRTUAL_WIDTH,'center');
    love.graphics.printf(player2score,VIRTUAL_WIDTH - 160,line,VIRTUAL_WIDTH);
    love.graphics.printf(player1Score,140,line,VIRTUAL_WIDTH);
    
    --Paddles
    paddle1:render();
    paddle2:render();

    --Ball
    ball:render();
    love.graphics.printf(gameState,0,line,VIRTUAL_HEIGHT,'left');
    --Debug
    if gameState == 'debug' or gameState == 'startDebug' then
        love.graphics.printf(collision,line + 20,line,VIRTUAL_WIDTH,'left');
        love.graphics.printf(love.timer.getFPS(),0,line + 40,VIRTUAL_WIDTH,'left');
        love.graphics.printf(ball.x,0,line + 60,VIRTUAL_WIDTH,'left');
        love.graphics.printf(ball.y,0,line + 80,VIRTUAL_WIDTH,'left');
        love.graphics.printf(ball.dx,0,line + 100,VIRTUAL_WIDTH,'left');
        love.graphics.printf(ball.dy,0,line + 120,VIRTUAL_WIDTH,'left');
    end
end 