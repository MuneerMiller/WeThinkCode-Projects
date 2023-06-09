"""
TODO: You can either work from this skeleton, or you can build on your solution for Toy Robot 3 exercise.
"""

"""list of valid command names"""
valid_commands = ['off', 'help', 'replay', 'forward', 'back', 'right', 'left', 'sprint']
move_commands = valid_commands[3:]

"""variables tracking position and direction"""
position_x = 0
position_y = 0
directions = ['forward', 'right', 'back', 'left']
current_direction_index = 0

"""area limit""" 
min_y, max_y = -200, 200
min_x, max_x = -100, 100

"""command history"""
history = []


def get_robot_name():
    name = input("What do you want to name your robot? ")
    
    while len(name) == 0:
        name = input("What do you want to name your robot? ")
    return name


def add_to_history(command):
    """
    Adds command to history list of commands
    """
    history.append(command)


def get_command(robot_name):
    """
    asks for a command, and validate as well
    returns valid command
    """

    prompt = ''+robot_name+': What must I do next? '
    command = input(prompt)
    
    while len(command) == 0 or not valid_command(command):
        output(robot_name, "Sorry, I did not understand '"+command+"'.")
        command = input(prompt)

    return command.lower()


def do_help():
    """
    Provides help information to user, listing all the valid commands 
    """
    return True, """I can understand these commands:
OFF  - Shut down robot
HELP - provide information about commands
FORWARD - move forward by specified number of steps, e.g. 'FORWARD 10'
BACK - move backward by specified number of steps, e.g. 'BACK 10'
RIGHT - turn right by 90 degrees
LEFT - turn left by 90 degrees
SPRINT - sprint forward according to a formula
REPLAY - replays all movement commands from history [FORWARD, BACK, RIGHT, LEFT, SPRINT]
"""


def do_forward(robot_name, steps):
    """
    Moves the robot forward
    """
    
    if update_position(steps):
        return True, ' > '+robot_name+' moved forward by '+str(steps)+' steps.'
    
    else:
        return True, ''+robot_name+': Sorry, I cannot go outside my safe zone.'


def show_position(robot_name):
    """
    Prints the position of the user input
    """
    print(' > '+robot_name+' now at position ('+str(position_x)+','+str(position_y)+').')


def do_back(robot_name, steps):
    """
    Moves the robot forward
    """

    if update_position(-steps):
        return True, ' > '+robot_name+' moved back by '+str(steps)+' steps.'
    
    else:
        return True, ''+robot_name+': Sorry, I cannot go outside my safe zone.'


def do_right_turn(robot_name):
    """
    Do a 90 degree turn to the right
    """
    global current_direction_index

    current_direction_index += 1
    
    if current_direction_index > 3:
        current_direction_index = 0

    return True, ' > '+robot_name+' turned right.'


def do_left_turn(robot_name):
    """
    Does a 90 degree turn to the left
    """
    global current_direction_index

    current_direction_index -= 1
    
    if current_direction_index < 0:
        current_direction_index = 3

    return True, ' > '+robot_name+' turned left.'


def do_sprint(robot_name, steps):
    """
    Sprints the robot, let it go forward steps + (steps-1) + (steps-2) + .. + 1 number of steps, in iterations
    """

    if steps == 1:
        return do_forward(robot_name, 1)
    
    else:
        (do_next, command_output) = do_forward(robot_name, steps)
        print(command_output)
        return do_sprint(robot_name, steps - 1)


def valid_command(command):
    """
    Checks if robot can understand the command
    """

    (command_name, arg1) = split_command_input(command)

    if command_name.lower() == 'replay':
        
        if len(arg1.strip()) == 0:
            return True
        
        elif (arg1.lower().find('silent') > -1 or arg1.lower().find('reversed') > -1) and len(arg1.lower().replace('silent', '').replace('reversed','').strip()) == 0:
            return True
        
        else:
            range_args = arg1.replace('silent', '').replace('reversed','')
            
            if is_int(range_args):
                return True
            
            else:
                range_args = range_args.split('-')
                return is_int(range_args[0]) and is_int(range_args[1]) and len(range_args) == 2
    
    else:
        return command_name.lower() in valid_commands and (len(arg1) == 0 or is_int(arg1))


def split_command_input(command):
    """
    Splits string at first space character, to get command, as well as argument for command
    """
    args = command.split(' ', 1)
    if len(args) > 1:
        return args[0], args[1]
    return args[0], ''


def is_int(value):
    """
    Tests if the string value is an integer
    """
    try:
        int(value)
        return True
    except ValueError:
        return False


def output(name, message):
    print(''+name+": "+message)


def is_position_allowed(new_x, new_y):
    """
    Checks if the new position still falls within area limit
    """

    return min_x <= new_x <= max_x and min_y <= new_y <= max_y


def update_position(steps):
    """
    Update the current positions given the direction, and specific numberr of steps
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

    if is_position_allowed(new_x, new_y):
        position_x = new_x
        position_y = new_y
        return True
    return False


def get_commands_history(reverse, relativeStart, relativeEnd):
    """
    Retrieve the commands from history list, already breaking them up into tuples
    """

    commands_to_replay = [(name, args) for (name, args) in list(map(lambda command: split_command_input(command), history)) if name in move_commands]
    
    if reverse:
        commands_to_replay.reverse()

    range_start = len(commands_to_replay) + relativeStart if (relativeStart is not None and (len(commands_to_replay) + relativeStart) >= 0) else 0
    range_end = len(commands_to_replay) + relativeEnd if  (relativeEnd is not None and (len(commands_to_replay) + relativeEnd) >= 0 and relativeEnd > relativeStart) else len(commands_to_replay)
    return commands_to_replay[range_start:range_end]


def do_replay(robot_name, arguments):
    """
    Replays history commands
    """

    silent = arguments.lower().find('silent') > -1
    reverse = arguments.lower().find('reversed') > -1
    range_args = arguments.lower().replace('silent', '').replace('reversed', '')

    range_start = None
    range_end = None

    if len(range_args.strip()) > 0:
        
        if is_int(range_args):
            range_start = -int(range_args)
        
        else:
            range_args = range_args.split('-')
            range_start = -int(range_args[0])
            range_end = -int(range_args[1])

    commands_to_replay = get_commands_history(reverse, range_start, range_end)

    for (command_name, command_arg) in commands_to_replay:
        (do_next, command_output) = call_command(command_name, command_arg, robot_name)
        
        if not silent:
            print(command_output)
            show_position(robot_name)

    return True, ' > '+robot_name+' replayed ' + str(len(commands_to_replay)) + ' commands' + (' in reverse' if reverse else '') + (' silently.' if silent else '.')


def call_command(command_name, command_arg, robot_name):
    if command_name == 'help':
        return do_help()
    
    elif command_name == 'forward':
        return do_forward(robot_name, int(command_arg))
    
    elif command_name == 'back':
        return do_back(robot_name, int(command_arg))
    
    elif command_name == 'right':
        return do_right_turn(robot_name)
    
    elif command_name == 'left':
        return do_left_turn(robot_name)
    
    elif command_name == 'sprint':
        return do_sprint(robot_name, int(command_arg))
    
    elif command_name == 'replay':
        return do_replay(robot_name, command_arg)
    return False, None


def handle_command(robot_name, command):
    """
    Handles a command by asking different functions to handle a command
    """

    (command_name, arg) = split_command_input(command)

    if command_name == 'off':
        return False
    else:
        (do_next, command_output) = call_command(command_name, arg, robot_name)

    print(command_output)
    show_position(robot_name)
    add_to_history(command)

    return do_next


def robot_start():
    """Starting point"""

    global position_x, position_y, current_direction_index, history

    robot_name = get_robot_name()
    output(robot_name, "Hello kiddo!")

    position_x = 0
    position_y = 0
    current_direction_index = 0
    history = []

    command = get_command(robot_name)
    while handle_command(robot_name, command):
        command = get_command(robot_name)

    output(robot_name, "Shutting down..")


if __name__ == "__main__":
    robot_start()

