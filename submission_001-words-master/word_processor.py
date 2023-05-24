import string

def split(delimiters, text):
    """
    Splits a string using all the delimiters supplied as input string
    :param delimiters:
    :param text: string containing delimiters to use to split the string, e.g. `,;? `
    :return: a list of words from splitting text using the delimiters
    """

    import re
    regex_pattern = '|'.join(map(re.escape, delimiters))
    return re.split(regex_pattern, text, 0)

def convert_to_word_list(text):
    '''
    creating a list then filter out all spaces, commas, semi-colons, question marks and points using lambda and spliting the text
    also coverts text to lowercase
    '''
    #text = 'These are indeed interesting, an obvious understatement, times. What say you?'
    word = list(filter(lambda word: word != "", split(' ,;?.', text.lower())))
    print(word)
    return word


def words_longer_than(length, text):
    '''
    using list comprehension to find the length of the text and spliting it in lowercase
    '''
    #text = 'These are indeed interesting, an obvious understatement, times. What say you?'
    word = [i for i in split(' ,;.?', text.lower()) if len(i) >= length]
    #print(word)
    return word


def words_lengths_map(text):
    '''
    making a list of the word length and filtering it out as step 1
    then getting the length of the word within word lengths
    sorting out the word list
    creating a dictionary comprehension to count the word list and using the word list as the value of the key   
    '''
    #text = 'These are indeed interesting, an obvious understatement, times. What say you?'
    word_lengths = list(filter(lambda word: word ,split(" .,;?",text.lower())))
    word_list = [len(word) for word in word_lengths]
    word_list.sort()
    my_dict = {key: word_list.count(key) for key in word_list}
    #print(my_dict)
    return my_dict


def letters_count_map(text):
    '''
    creating a list of the alphabet using ascii
    making a dictionary and counting the amount of letters in the text
    '''
    #text = 'These are indeed interesting, an obvious understatement, times. What say you?'
    alpha_list = list(string.ascii_lowercase)
    my_dict = dict((word, text.lower().count(word)) for word in alpha_list)
    #print(my_dict)
    return my_dict


def most_used_character(text):
    '''
    returning None for an empty string
    using ascii for the alphabet as in step 4
    creating a dictionary to count the amount of letters as in step 4
    using the max function to find the max amount of letters that is used most
    '''
    #text = 'These are indeed interesting, an obvious understatement, times. What say you?'
    if text == '':
        return None
    else: 
        alpha = string.ascii_lowercase
        my_dict = dict((word, text.lower().count(word)) for word in alpha)
        key_max = max(my_dict, key = lambda word: my_dict[word])
        #print(key_max)
        return key_max

if __name__ in '__main__':
    convert_to_word_list("text")
    words_longer_than(10, "text")
    words_lengths_map("text")
    letters_count_map("text")
    most_used_character("text")