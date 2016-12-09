from sys import argv

script, filename, target_essid = argv

essid = []
address = []
quality = []

with open(filename) as openfileobject:
    for line in openfileobject:
        element = line.split()
        if element == []:
            break
        elif element[0] == "Cell":
            address.append(element[-1])
        elif element[0].startswith("Quality"):
            quality.append(element[0].split("=")[1].split('/')[0])
        elif element[0].startswith("ESSID"):
            essid.append(element[0].split('"')[1])

address2 = []
quality2 = []
for i, j in enumerate(essid):
    if j == target_essid:
        address2.append(address[i])
        quality2.append(quality[i])

print address2[quality2.index(max(quality2))]
