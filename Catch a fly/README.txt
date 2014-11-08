# Developer:  Jiajie Dang
# Email:  djjkobe@gmail.com
======================================
1.creat the frog at(32,4)
2.creat a fly at a random place and put it on the LED screen
3.first check the score, if the score bigger or equal than 32, game stop.else then check if there is a key pressed
(1)if is the "up" key, move the frog on spot up.
if hit the top, move the frog to (32,63), then jump to 4
(2)if is the "down" key, move the frog on spot down.
if hit the bottom, move the frog to (32,0), then jump to 4
(3)if is the "left" key,check if there is fly to the left and on the same line with the frog.
if yes, check the distance between the frog and the fly, 
if is less than 24, draw the line.score plus 1.set this fly's position to black and create two flys in left or right.then jump to 4
else jump to 4
(4)if is the "right" key,check if there is fly to the right and on the same line with the frog.
if yes, check the distance between the frog and the fly, 
if is less than 24, draw the line.score plus 1.set this fly's position to black and create two flys in left or right.then jump to 4
else jump to 4
(5)if the "b" key, game forfeited , print the message with the score.
4. move the fly
every time move a line,check if there are flies on left and right of the frog. 
if yes, move them correspondingly.
else, jump to 3
