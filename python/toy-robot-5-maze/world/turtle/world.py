import turtle
from maze import obstacles


turtle.pencolor("black")
turtle.speed(5)
turtle.getscreen()._root.attributes('-topmost', 1)

turtle.penup()
turtle.forward(100)
turtle.left(90)
turtle.pendown()

for i in range(2):
    turtle.forward(200)
    turtle.left(90)
    turtle.forward(200)
    turtle.left(90)
    turtle.forward(200)


#Making blocks
obs = obstacles.get_obstacles()
for wii in obs:
    turtle.penup()
    turtle.goto(wii)
    turtle.pendown()

    turtle.begin_fill()
    for i in range(4):
        turtle.fillcolor("black")
        turtle.forward(4)
        turtle.left(90)
    turtle.end_fill()


turtle.penup()
turtle.goto(0,0)
turtle.pendown()

# variables tracking position and direction
position_x = 0
position_y = 0
directions = ['forward', 'right', 'back', 'left']
current_direction_index = 0

# area limit vars
min_y, max_y = -200, 200
min_x, max_x = -100, 100


def show_position(robot_name):
    print(' > '+robot_name+' now at position ('+str(position_x)+','+str(position_y)+').')


def is_position_allowed(new_x, new_y):
    """
    Checks if the new position will still fall within the max area limit
    :param new_x: the new/proposed x position
    :param new_y: the new/proposed y position
    :return: True if allowed, i.e. it falls in the allowed area, else False
    """

    return min_x <= new_x <= max_x and min_y <= new_y <= max_y


def update_position(steps, robot_name):
    """
    Update the current x and y positions given the current direction, and specific nr of steps
    :param steps:
    :return: True if the position was updated, else False
    """

    global position_x, position_y
    new_x = position_x
    new_y = position_y

    if directions[current_direction_index] == 'forward':
        new_y = new_y + steps
    elif directions[current_direction_index] == 'right':
        new_x = new_x + steps
    elif directions[current_direction_index] == 'back':
        new_y = new_y - steps
    elif directions[current_direction_index] == 'left':
        new_x = new_x - steps

    if obstacles.is_path_blocked(position_x, position_y, new_x, new_y):
        print(robot_name+ ": Sorry, there is an obstacle in the way.")
        blocked = True
        return True

    if is_position_allowed(new_x, new_y):
        position_x = new_x
        position_y = new_y
        turtle.goto(new_x, new_y)
        return True
    return False


def do_right_turn(robot_name):

    global current_direction_index
    """
    Do a 90 degree turn to the right
    :param robot_name:
    :return: (True, right turn output text)
    """

    current_direction_index += 1
    if current_direction_index > 3:
        current_direction_index = 0
    turtle.right(90)

    return True, ' > '+robot_name+' turned right.'


def do_left_turn(robot_name):

    global current_direction_index
    """
    Do a 90 degree turn to the left
    :param robot_name:
    :return: (True, left turn output text)
    """

    current_direction_index -= 1
    if current_direction_index < 0:
        current_direction_index = 3
    turtle.left(90)

    return True, ' > '+robot_name+' turned left.'
