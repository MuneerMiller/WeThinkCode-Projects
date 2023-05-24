# TODO: Step 1 - get shape (it can't be blank and must be a valid shape!)

def get_shape():
    shape = (input("Shape?: ")).lower()
    while shape != "pyramid" and shape != "square" and shape != "triangle" and shape\
        != "diamond" and shape != "rhombus" and shape != "inverted triangle":
        shape = input("Shape?: ") 
    return shape

# TODO: Step 1 - get height (it must be int!)
def get_height():
    height = (input("Height?: "))
    while height.isdigit() == False or int(height) > 80:
        height = (input("Height?:"))
    return int(height)


# TODO: Step 2
def draw_pyramid(height, outline):
    if (outline == True):
        for i in range(1,height+1):
            for j in range(1,2*height):
                if i==height or i+j==height+1 or j-i==height-1:
                    print("*",end="")
                elif i==height and j!=2:
                    print("*",end="")
                elif j - i > height - 1:
                    pass
                else:
                    print(end=" ")
            print()
    else:
        for i in range(1, height+1):
            print(" " * (height - i)+ "*" *(2 * i - 1))
        return False


# TODO: Step 3
def draw_square(height, outline):
    if(outline == True):
        for i in range(height):
            for j in range(height):
                if i == 0 or i == height-1 or j == 0 or j == height-1:
                    print("*", end = "")
                else:
                    print(" ", end = "")
            print("")
    else:
        for i in range(1,height+1):
            print("*" *height)

# TODO: Step 4
def draw_triangle(height, outline):
    if (outline == True):
        for i in range(height):
            for j in range (i+1):
                if j == 0 or i == (height-1) or i == j:
                    print ("*", end = "")
                else:
                    print(end=" ")
            print()
    else:
        for i in range(1, height+1):
            print("*" *i)

#step 6, more shapes

def draw_diamond(height, outline):
    if (outline == True):
        for i in range(1, height+1):
            for j in range(1,height-i+1):
                print(" ", end="")
            for j in range(1, 2*i):
                if j==1 or j==2*i-1:
                    print("*", end="")
                else:
                    print(" ", end="")
            print()

        for i in range(height-1,0, -1):
            for j in range(1,height-i+1):
                print(" ", end="")
            for j in range(1, 2*i):
                if j==1 or j==2*i-1:
                    print("*", end="")
                else:
                    print(" ", end="")
            print()
    else:
        for i in range(height):
            print(" "*(height-i), "*"*(i*2+1))
        for i in range(height-2, -1, -1):
            print(" "*(height-i), "*"*(i*2+1))

def draw_rhombus(height, outline):
    if (outline == True):
        for i in range (1, height + 1):
            for j in range (1, height - i + 1):
                print(end=" ")
            if i == 1 or i == height:
                for j in range (1, height + 1):
                    print("*", end="")
            else:
                for j in range (1, height+1):
                    if (j == 1 or j == height):
                        print("*", end="")
                    else: 
                        print(end=" ")
            print()          
    else:
        for i in range (1, height + 1):
            for j in range (1, height - i + 1):
                print (end=" ")
            for j in range (1, height + 1):
                print ("*", end="")
            print()

def draw_inverted_triangle (height, outline):
    if (outline == True):
        for i in range (0, height):
            for j in range (0, height):
                if i == 0 or j == (height - 1) or j == i:
                    print("*", end="")
                else:
                    print(end=" ")
            print()
    else:
        for i in range (height, 0, -1): 
            print((height-i) * ' ' + i * '*') 

# TODO: Steps 2 to 4, 6 - add support for other shapes
def draw(shape, height, outline):
        if shape == "pyramid":
            draw_pyramid(height, outline)
        if shape == "square":
            draw_square(height, outline)
        if shape == "triangle":
            draw_triangle(height, outline)
        if shape == "diamond":
            draw_diamond(height, outline)
        if shape == "rhombus":
            draw_rhombus(height, outline)
        if shape == "inverted triangle":
            draw_inverted_triangle(height, outline)

# TODO: Step 5 - get input from user to draw outline or solid
def get_outline():
    user_input_outer = input("Outline only? (y/N): ")
    if user_input_outer == "y":
        return True
    else:
        return False

if __name__ == "__main__":
    shape_param = get_shape()
    height_param = get_height()
    outline_param = get_outline()
    draw(shape_param, height_param, outline_param)