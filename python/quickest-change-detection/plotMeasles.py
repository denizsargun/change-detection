# plot US measles data vs time for each state or aggregate
import os
import pandas
from tabulate import tabulate
import matplotlib.pyplot as plt
import datetime

def saturday(year,week):
    # return the datetime object for saturday for given year and week
    firstDay = datetime.datetime(year,1,1)
    diff = (5-firstDay.weekday())%7 # saturday is 5th day of the week
    firstSaturday = firstDay+datetime.timedelta(days=diff)
    return firstSaturday+datetime.timedelta(weeks=week-1)

def measlesYearly():
    path = "/home/denizsargun/Downloads/github/change-detection/health data/measles/yearly data/"
    files = os.listdir(path)
    dic = {} # {date: total number of measles cases in US on the week ending with date}
    for file in files:
        fp = open(path + file, 'r')
        line = 1
        while line:
            try:
                line = fp.readline()
                if "Measles" in line:
                    l = line.split(",")
                    year = int(l[1])
                    week = int(l[2])
                    try:
                        reports = int(l[3])
                    except:
                        reports = 0
                    time = saturday(year,week)
                    dic[time] = reports
            except:
                break
    return pandas.DataFrame.from_dict(dic,orient='index').rename(columns={0:"reports"})

def measlesWeekly():
    path = "/home/denizsargun/Downloads/github/change-detection/health data/measles/weekly data/"
    files = os.listdir(path)
    dic = {} # {date: total number of measles cases in US on the week ending with date}
    for file in files:
        l = file.split("-")
        year = int(l[2])
        week = int(l[3][1:3])
        time = saturday(year,week)
        fp = open(path + file, 'r')
        flag = 1
        while flag:
            try:
                line = fp.readline()
                if "Total" in line:
                    flag = 0
                    l = line.split("\t")
                    try:
                        reports1 = int(l[5])
                    except:
                        reports1 = 0
                    try:
                        reports2 = int(l[9])
                    except:
                        reports2  = 0
                    dic[time] = reports1+reports2
            except:
                break
    return pandas.DataFrame.from_dict(dic,orient='index').rename(columns={0:"reports"})

# def measlesWeekly():
#     path = "/home/denizsargun/Downloads/github/change-detection/health data/measles/weekly data/"
#     files = os.listdir(path)
#     dic = {} # {date: total number of measles cases in US on the week ending with date}
#     colNames = ["Reporting Area",
#                 "Malaria current week",
#                 "Malaria previous 52 weeks maximum",
#                 "Malaria cummulative YTD for 2019",
#                 "Malaria cummulative YTD for 2018",
#                 "Measles; Indigenous current week",
#                 "Measles; Indigenous previous 52 weeks maximum",
#                 "Measles; Indigenous cummulative YTD for 2019",
#                 "Measles; Indigenous cummulative YTD for 2018",
#                 "Measles; Imported current week",
#                 "Measles; Imported previous 52 weeks maximum",
#                 "Measles; Imported cummulative YTD for 2019",
#                 "Measles; Imported cummulative YTD for 2018",
#                 "dummy"]
#         dTypes = {"Measles; Indigenous current week" : "float64",
#                   "Measles; Imported current week" : "float64"}
#     for file in sorted(files):
#         fp = open(path+file, 'r')
#         l = file.split("-")
#         year = int(l[2])
#         week = int(l[3][1:])
#         line = fp.readline()
#         skipRows = 1
#         while "tab delimited data:" not in line:
#             line = fp.readline()
#             skipRows += 1
#         nRows = 0
#         while "Total" not in line:
#             line = fp.readline()
#             nRows += 1
#         naValues = ["NA","-","U","N","NN","NP","NC"]
#         df = pandas.read_csv(path+file, sep='\t', lineterminator='\n', skiprows=skipRows, nrows=nRows, header=None,
#                              names=colNames, dtype=dTypes, na_values=naValues)
#         df = df.drop(columns=["dummy"])
#         df = df.fillna(0)
#         totalRow = df.loc[df['Reporting Area'] == "Total"]
#         reports = totalRow.iloc[0]["Measles; Indigenous current week"]+totalRow.iloc[0]["Measles; Imported current week"]
#         # print(df.shape)
#         # print(tabulate(df, headers='keys', tablefmt='psql'))

def vaccineTrends():
    import pandas
    # vaccine web search trends retrieved from Google Trends
    path = "/home/denizsargun/Downloads/github/change-detection/health data/vaccine/vaccine web search trends 2004-2019.csv"
    df = pandas.read_csv(path,skiprows=2,na_values="<1").fillna(0)
    df.index = pandas.to_datetime(df["Month"]+"-15", format="%Y-%m-%d")
    df.index.names = ['date']
    df["trends"] = df[list(df.columns)].sum(axis=1)
    return df[["trends"]]

def measlesVsTrends(measlesDf,trendsDf):
    fig, ax1 = plt.subplots()
    color = 'tab:red'
    ax1.set_xlabel('date',fontsize=20)
    ax1.set_ylabel('weekly reported measles cases', color=color, fontsize=20)
    measlesDf.plot(ax=ax1, color=color, linewidth=5)
    ax1.tick_params(axis='y', labelcolor=color)
    ax1.set_ylim(bottom=0)
    ax1.grid(b=True, which="major")

    ax2 = ax1.twinx()
    color = 'tab:blue'
    ax2.set_ylabel('anti-vaccine search trends', color=color, fontsize=20)
    trendsDf.plot(ax=ax2, color=color, linewidth=5,linestyle=":")
    ax2.tick_params(axis='y', labelcolor=color)
    ax2.set_ylim(bottom=0)

    # fig.tight_layout()  # otherwise the right y-label is slightly clipped
    # plt.show()
    fig.savefig("/home/denizsargun/Downloads/github/change-detection/health data/measles/measlesReportsAndVaccineSearchTrends.png", bbox_inches='tight',dpi=300)

measlesDfs = [measlesYearly(),measlesWeekly()]
measlesDf = pandas.concat(measlesDfs)
trendsDf = vaccineTrends()
measlesVsTrends(measlesDf,trendsDf)