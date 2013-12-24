import re

line_under_cursor = "fun void so_something(dur a, dur d, dur s, float s_level, dur r){"
#line_under_cursor = "fun void so_something(dur a){"

def find_arglist(line_under_cursor):

    try:
        pattern = "(\(.*?\))"
        m = re.search(pattern, line_under_cursor)
        arg_list = m.groups(0)[0]

        # return trimmed parens.
        return arg_list[1:-1]
    except:
        print("unexpected arglist - stick it one line")
        return -1

def find_and_replace(variable):
    if "[" in variable:
        return variable.replace("[]", "")

def make_setter(line_under_cursor):

    try:
        k = find_arglist(line_under_cursor)
        left_spaces = len(line_under_cursor) - len(line_under_cursor.lstrip())
        spacing = " " * (left_spaces + 4)
        t = k.split(',')
        t = [combo.strip() for combo in t]
        sum_return = line_under_cursor + "\n"
        for combo in t:
            varname = combo.split(" ")[1]

            # if varname contains [] then the assignment operator
            # turns to @=> and the variable name is stripped of the []
            ass_op = ""
            found = find_and_replace(varname)
            if found:
                ass_op = "@"
                varname = found

            rewrite = "{0}{1} {2}=> this.{1};\n"
            sum_return += rewrite.format(spacing, varname, ass_op)
        return sum_return
    except:
        return 

print(make_setter(line_under_cursor))