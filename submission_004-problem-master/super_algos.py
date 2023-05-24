def find_min(element):
    """TODO: complete for step 1"""
    for i in element:
        if i == " " or type(i) != int:
            return -1
    if len(element) == 0:
        return -1

    if len(element) == 1:
        return element[0]

    elif element[0] > element[1]:
        del element[0]
        return find_min(element)

    elif element[0] < element[1]:
        del element[1]
        return find_min(element)
    elif element[0] == element[1]:
        del element[1]
        return find_min(element)


def sum_all(element):
    """TODO: complete for Step 2"""
    for i in element:
        if i == "" or type(i) != int:
            return -1
    if len(element) == 0:
        return -1
    if len(element) == 1:
        return element[0]
    else:
        return element[0] + sum_all(element[1:])


def find_possible_strings(character_set, n):
    """TODO: complete for Step 3"""
    for i in character_set:
        if i == "" or type (i) != str:
            return []
    if n == 1:
        return character_set
    else:
        liis = []
        for i in character_set:
            for j in find_possible_strings(character_set, n -1):
                liis.append(i + j)
        return liis


if __name__ == '__main__':
    element = [58,3,6,8,9,3,11]
    print(find_min(element))
    my_list = []
    print(sum_all(my_list))
    character_set = ['a','b']
    print(find_possible_strings(character_set, 2))

