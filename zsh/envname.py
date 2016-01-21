""" Print the name of the current virtual environment """

import sys
import os.path
import re

def find_python_dir():
    path = sys.executable
    return os.path.dirname(path)


def find_activate(path):
    # Returns the path for activate.csh - it is easier to get the prompt from the csh file, compared to the sh or bat file
    activate_path = os.path.join(path, 'activate.csh')
    if not os.path.isfile(activate_path):
        return None  # No activate virtual env
    return activate_path


def find_prompt_csh(path):
    if not path.endswith('activate.csh'):
        raise ValueError("This function only works on activate.csh files")

    prefix = 'set env_name = "'
    with open(path, 'r') as inf:
        for line in inf:
            line = line.strip()
            if line.startswith(prefix):
                return line[len(prefix):-1]


def clean_prompt(prompt):
    prompt = prompt.strip()
    if prompt[0] in ('(', '[', '{') and prompt[-1] in (')', ']', '}'):
        return prompt[1:-1]
    return prompt


def get_virtenv_prompt():
    dir = find_python_dir()
    activate = find_activate(dir)
    if not activate:
        return ""

    prompt = find_prompt_csh(activate)
    prompt = clean_prompt(prompt)
    return '[' + prompt + ']'


if __name__=='__main__':
    print(get_virtenv_prompt())
