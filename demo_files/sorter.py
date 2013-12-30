
selection = "47, 61, 66, 64, 57"

def sorter(selection):
    try:
        selection = selection.split(",")
        selection = [s.strip() for s in selection]
        return str(sorted(selection))[1:-1]
    except:
        return

a = sorter(selection)
print(a)

