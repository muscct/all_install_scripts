from subprocess import call
from _thread import start_new_thread
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib import style

# Here, the only new import is the matplotlib.animation as animation. This is the module that will allow us to animate the figure after it has been shown.

# Next, we'll add some code that you should be familiar with if you're following this series:

animations = []

def plotSomething(nameOfTheThing, bashCommandToGetTheThing, refreshRate, numberOfMeasurements):
    global animations

    style.use('fivethirtyeight')

    fig = plt.figure()
    ax1 = fig.add_subplot(1,1,1)
    ax1 = fig.add_subplot(1,1,1)
    tempLog = nameOfTheThing + '.log'
    getAndLogCommand = bashCommandToGetTheThing + ' >> ' + tempLog + ' && echo "$(tail --lines ' + str(numberOfMeasurements) + ' ' + tempLog + ')" > ' + tempLog
    totalRuntime = 0

    def animate(i):
        nonlocal totalRuntime
        nonlocal refreshRate
        totalRuntime += refreshRate 
        call(getAndLogCommand, shell=True)
        graphData = open(tempLog, 'r+')
        lines = graphData.read().split('\n')
        # print("lines:", lines)
        lines = list(filter(lambda l: len(l) > 0, lines))
        numLines = int(len(lines))
        xs = []
        ys = []
        for (index, line) in enumerate(lines):
            xs.append(totalRuntime - ( (numLines - index) * refreshRate))
            ys.append(float(line))
        ax1.clear()
        ax1.set_ylim((0, 100))
        ax1.plot(xs, ys)

    animations.append(animation.FuncAnimation(fig, animate, interval=refreshRate))

    plt.show()

start_new_thread ( plotSomething, ("CPU", "bash getCpu.sh", 10, 10) )

# plotSomething("CPU", """top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'""", 10, 10)
# plotSomething("CPU2", "bash getCpu.sh", 10, 10)
# plotSomething("CPU", "top -bn1 | grep \"Cpu(s)\" | sed \"s/.*, *\([0-9.]*\)%* id.*/\1/\" | awk '{print 100 - $1}'", 10, 10)

