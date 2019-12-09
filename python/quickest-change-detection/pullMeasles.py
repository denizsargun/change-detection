# the link has measles reports data in the US per state
# the data spans 2019 only
import requests
urlTemp = "https://wonder.cdc.gov/nndss/static/YEAR/WEEK/YEAR-WEEK-table1v.txt"
writePath = "/home/denizsargun/Downloads/github/change-detection/health data/measles/data/"
fileNameTemp = "measles-US-YEAR-WWEEK.txt"
years = [2019]
weeks = range(1,48)
for year in years:
    for week in weeks:
        weekStr = str(week).zfill(2)
        url = urlTemp.replace("YEAR",str(year)).replace("WEEK",weekStr)
        fileName = fileNameTemp.replace("YEAR",str(year)).replace("WEEK",weekStr)
        r = requests.get(url)
        file = open(writePath+fileName, 'w')
        file.write(r.text)
        file.close()

# earlier data 1996-2018