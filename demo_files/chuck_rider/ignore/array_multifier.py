tb = [54, 0,55,54,61,   
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
66, 0,64,66,61, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0,
54, 0,55,54,61, 0,66, 0,64]

expander = lambda i: [i, 300] if i > 0 else [0,0]
tkm = [expander(i) for i in tb]

print(tkm)