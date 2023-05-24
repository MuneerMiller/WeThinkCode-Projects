def crop_circle(length):
    print("Crop circles - 4 circles")
    for i in range(4):
        print("* Move Forward "+str(length))
        move_circle()

def move_square(size):
    print("Moving in a square of size "+str(size))
    for i in range(4):
        degrees = 90
        print("* Move Forward "+str(size))
        print("* Turn Right "+str(degrees)+" degrees")

def move_circle():
    print("Moving in a circle")
    length = 1
    degrees = 1
    for i in range(360):
        print("* Move Forward "+str(length))
        print("* Turn Right "+str(degrees)+" degrees")

def move_rectangle(length , width ):
    print("Moving in a rectangle of "+str(length)+" by "+str(width))
    for i in range(2):
        degrees = 90
        print("* Move Forward "+str(length))
        print("* Turn Right "+str(degrees)+" degrees")
        print("* Move Forward "+str(width))
        print("* Turn Right "+str(degrees)+" degrees")


def dancing_square(length):
    print("Square dancing - 3 squares of size 20")
    for i in range(3):
        print("* Move Forward "+str(length))
        move_square(length)

"""I defined the lengths and sizes in the 'move()' function to accomodate functions that call these lengths and sizes"""


def move():
    size = 10
    width = 10
    length = 20
    move_square(size)
    move_rectangle(length , width)
    move_circle()
    dancing_square(length)
    crop_circle(length)


def robot_start():
    move()


if __name__ == "__main__":
    robot_start()
