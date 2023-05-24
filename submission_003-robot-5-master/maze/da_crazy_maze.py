import turtle



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


turtle.penup()
turtle.goto(0,0)
turtle.pendown()


