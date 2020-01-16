import os
import pandas
import numpy
from tabulate import tabulate
import matplotlib.pyplot as plt

def getChangePoints(labels):
    firstDiff = [j - i for i, j in zip(labels[:-1], labels[1:])]
    index = [i+1 for i, e in enumerate(firstDiff) if e != 0]
    return index

def plotActivity(path):
    files = os.listdir(path)
    files.sort()
    colNames = ['samp', # sample
                'xacc', # x acceleration
                'yacc', # y acceleration
                'zacc', # z acceleration
                'labl'] # label
    labelNames = ['Working at Computer',
                  'Standing Up, Walking and Going up\down stairs',
                  'Standing',
                  'Walking',
                  'Going Up\Down Stairs',
                  'Walking and Talking with Someone',
                  'Talking while Standing']
    # it = 3
    for file in files:
        if file.endswith(".csv"):
            df = pandas.read_csv(path + file, header=None, names=colNames)
            df = df.reset_index()
            changePoints = getChangePoints(df['labl'].values.tolist())
            points = [0]+changePoints
            df['acc'] = (df['xacc']**2+df['yacc']**2+df['zacc']**2)**(1/2)
            # print(tabulate(df.head(3), headers='keys', tablefmt='psql'))
            for i in range(len(points)-1):
                try:
                    df.iloc[points[i]:points[i+1]].plot(x='index',y='acc',ax=ax,label=labelNames[df['labl'].iloc[points[i]]-1])
                except:
                    ax = df.iloc[points[i]:points[i+1]].plot(x='index', y='acc',label=labelNames[df['labl'].iloc[points[i]]-1])
            ax.grid(b=True, which='both')
            plt.xlim(left=0)
            plt.legend(loc='upper right',prop={'size': 6})
            del ax
            # plt.savefig("/home/denizsargun/Downloads/github/change-detection/human activity data/sample.png",bbox_inches='tight', dpi=1000)
    plt.show()

def getEmpDist(path,labl):
    # get the 100-binned uniform distribution corresponding to the empirical distribution of acceleration given label = 1,2,...,7
    if labl not in range(1,8):
        print('label out of range')
        return
    files = os.listdir(path)
    colNames = ['samp', # sample
                'xacc', # x acceleration
                'yacc', # y acceleration
                'zacc', # z acceleration
                'labl'] # label
    frames = []
    for file in files:
        if file.endswith(".csv"):
            df = pandas.read_csv(path + file, header=None, names=colNames)
            dfLabl = df[df.labl==labl]
            frames += [dfLabl]
    dfLablConc = pandas.concat(frames)
    dfLablConc['acc'] = (dfLablConc['xacc'] ** 2 + dfLablConc['yacc'] ** 2 + dfLablConc['zacc'] ** 2) ** (1 / 2)
    # df = df.sort_values(by=['labl','acc'])
    # print(df['labl'].value_counts())
    # print(tabulate(df.head(5), headers='keys', tablefmt='psql'))
    # df.plot(x='index',y='acceleration')
    numBins = 100
    accLablConc = dfLablConc['acc'].tolist()
    accLablConcSort = sorted(accLablConc)
    l = len(accLablConcSort)
    d = l/numBins
    r = l%numBins
    print(l,d,r)
    inds = range(0,l,d)
    # hist, bin_edges = numpy.histogram(a=df['acc'].tolist(),bins=numBins)
    # pmf = hist/sum(hist)
    # repPoints = [] # conditional means
    # for i in range(numBins):
    #     dumm = df[(df.acc>= bin_edges[i])&
    #               (df.acc<bin_edges[i+1])]
    #     print(bin_edges[:2])
    #     print(tabulate(dumm.head(5), headers='keys', tablefmt='psql'))
    #     repPoints[i] = dumm['acc'].mean()
    # return pmf, repPoints

path = "/home/denizsargun/Downloads/github/change-detection/human activity data/Activity Recognition from Single Chest-Mounted Accelerometer/"
# plotActivity(path)
getEmpDist(path,1)
# print(pmf)