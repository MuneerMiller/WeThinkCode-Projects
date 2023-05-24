import random

obs = []


def get_obstacles():
    global obs
    obs.clear()
    for i in range(random.randint(0, 10)):
        (x, y) = (random.randint(-100, 100), random.randint(-200, 200))
        obs.append((x, y))
    # print(obs)
    return obs


def is_position_blocked(x, y):

    global obs
    for wii in obs:
        if wii[0] <= x <= wii[0]+4 and wii[1] <= y <= wii[1]+4:
            return True
    return False


def is_path_blocked(x1, y1, x2, y2):
    if y1 > y2:
        (y1, y2) = (y2, y1)
    if x1 > x2:
        (x1, x2) = (x2, x1)

    if y1 == y2:
        for x in range(x1, x2+1):
            if is_position_blocked(x, y1):
                return True

    if x1 == x2:
        for y in range(y1, y2+1):
            if is_position_blocked(x1, y):
                return True

    return False
