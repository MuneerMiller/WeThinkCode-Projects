class Problem:
    def __init__(self, student_name, topic, problem_name, status):
        self.topic = topic
        self.student_name = student_name
        self.problem_name = problem_name
        self.status = status
    
    def get_status(self):
        return (F"{self} [{self.status.upper()}]")
    
    def get_details(self):
        return (self.student_name, self.topic, self.get_status())
    
    def __str__(self):
        return self.problem_name


def make_probs(topic):
    probs = []
    for i in range(1,4):
        probs.append(Problem("jack", topic ,F"Problem {i}", "started"))
    return probs


def display_problems(problems):
    print("Problems:")
    for topic, problem in problems.items():
        print(F"* {topic} : ", end="")
        print(*problem, sep=", ")


def display_topics(topics):
    print("Course Topics:")
    for t in topics:
        print(F"* {t}")


def display_progress(progress):
    print("Student Progress:")
    i = 0
    for p in progress:
        i +=1
        print(F"{i}.", end = " ")
        print(*p, sep=" - ")


def get_sort_key(line):
    key = {"RTED]":1, "ADED]":2, "ETED]":3}
    return key.get(line[-5:])


def sort(progress):
    return sorted(progress, key=lambda x: get_sort_key(x[2]))


def sort_topics(topics):
    return list(sorted(list(topics)))


def make_tuples():
    progress = []
    progress.append(Problem("Nyari", "Introduction to Python",\
        "Problem 2", "started").get_details())
    progress.append(Problem("Adam", "How to make decisions",\
        "Problem 1", "graded").get_details())
    progress.append(Problem("Jack", "How to repeat code",\
        "Problem 2", "completed").get_details())
    progress.append(Problem("Nyari", "How to make decisions", \
        "Problem 1", "graded").get_details())
    progress.append(Problem("Adam", "How to repeat code", \
        "Problem 3", "started").get_details())
    return progress


def create_outline():
    #make topics
    topics = set([
        'Introduction to Python', 'Tools of the Trade',
        'How to make decisions', 'How to repeat code',
        'How to structure data', 'Functions', 'Modules'])
    topics = sort_topics(topics)
    display_topics(topics)
    #topics = sort_topics(topics)
    #print("***********************************")
    #display_topics(topics)
    #print("***********************************")
    #make dict of toipics and problems
    problems = {topic : make_probs(topic) for topic in topics}
    display_problems(problems)
    #progress and sort
    progress = make_tuples()
    progress_sorted = sort(progress)
    display_progress(progress_sorted)
if __name__ == "__main__":
    create_outline()
