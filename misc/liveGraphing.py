from subprocess import call
from _thread import start_new_thread
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib import style

def getLogFileName(name):
    return name + ".log"

def getCommand(name, command): 
    logFileName = getLogFileName(name)
    return command + ' >> ' + logFileName + ' && echo "$(tail --lines ' + str(numberOfMeasurements) + ' ' + logFileName + ')" > ' + logFileName

refreshRate = 10
numberOfMeasurements = 10

style.use('fivethirtyeight')

fig = plt.figure()
graphObjects = [
    {
        'axis': fig.add_subplot(1,2,1),
        'name': "CPU",
        'logFile': getLogFileName("CPU"),
        'command': getCommand("CPU", "bash getCpu.sh"),
        'low': 0,
        'high': 100
    },
    {
        'axis': fig.add_subplot(1,2,2),
        'name': "Power",
        'logFile': getLogFileName("Power"),
        'command': getCommand("Power", "bash getPower.sh"),
        'low': 0,
        'high': 1800
    }
]

totalRuntime = 0

def animate(i):
    global totalRuntime
    global refreshRate
    global graphObjects
    totalRuntime += refreshRate 
    for go in graphObjects:
        call(go['command'], shell=True)
        goData = open(go['logFile'], 'r')
        lines = goData.read().split('\n')
        goData.close()
        lines = list(filter(lambda l: len(l) > 0, lines))
        numLines = int(len(lines))
        xs = []
        ys = []
        for (index, line) in enumerate(lines):
            xs.append(totalRuntime - ( (numLines - index) * refreshRate))
            ys.append(float(line))
        go['axis'].clear()
        go['axis'].set_ylim((go['low'], go['high']))
        go['axis'].plot(xs, ys)

animation = animation.FuncAnimation(fig, animate, interval=refreshRate)

plt.show()

# start_new_thread ( plotSomething, ("CPU", "bash getCpu.sh", 10, 10) )

# plotSomething("CPU", """top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'""", 10, 10)
# plotSomething("CPU2", "bash getCpu.sh", 10, 10)
# plotSomething("CPU", "top -bn1 | grep \"Cpu(s)\" | sed \"s/.*, *\([0-9.]*\)%* id.*/\1/\" | awk '{print 100 - $1}'", 10, 10)

