# Project : Memory Game
# Date    : 2018/09/06
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"
load "guilib.ring"

size = 8
limit = 5
nScore = 0
bsumold = 0
bsumnew = 1
buttonold = newlist(size,size)
buttonnew = newlist(size,size)
LayoutButtonRow = list(size+2)
winwidth = 0
winheight = 0

app = new qApp {
          StyleFusion()
          win = new qWidget() {
                  setWindowTitle('Memory Game')
                  setgeometry(100,100,600,600)
                  setminimumwidth(300)
                  setminimumheight(300)
                  setmaximumwidth(600)
                  setmaximumheight(600)
                  move(490,100) 
                  winwidth = win.width()
                  winheight = win.height()
                  setstylesheet('background-color:white')
                  fontsize = 10 + (winheight/25)
                  fontsize2 = 8 + (winheight/70)
                  for n = 1 to size
                       for m = 1 to size
                            buttonold[n][m] = new QPushButton(win) {
                                                       setFont(new qFont("Verdana",fontsize,100,0))
                                                       setstylesheet('background-color:gray')
                                                       setclickevent("pplay(" + string(n) + "," + string(m) + ")")
                                                       }
                       next
                  next
                  for n = 1 to size
                       for m = 1 to size
                            buttonnew[n][m] = 0
                       next
                  next
                  for n = 1 to size+2
		       LayoutButtonRow[n] = new QHBoxLayout() {
                                                        setSpacing(3) }
                  next
                  for n = 1 to size
                       for m = 1 to size
                            LayoutButtonRow[n].AddWidget(buttonold[m][n])
                            win.show()
                       next
                  next
                  playerscore = new QLabel(win) {
                                      setGeometry(0,8*floor(winheight/10),winwidth,floor(winheight/10))
                                      setFont(new qFont("Verdana",fontsize2,100,0))
                                      setalignment(Qt_AlignHCenter | Qt_AlignVCenter)
                                      settext("Play Score:")
                                      show()
                                      }
                  newgame  = new QPushButton(win) {
                                     setGeometry(0,9*floor(winheight/10),winwidth,floor(winheight/10))
                                     setFont(new qFont("Verdana",fontsize2,100,0))
                                     setstylesheet("background-color:violet")
                                     settext("New Game")
                                     setclickevent("pbegin()")
                                     show()
                                     }
                  LayoutButtonRow[size+1].AddWidget(playerscore)
                  LayoutButtonRow[size+2].AddWidget(newgame)
                  LayoutButtonMain = new QVBoxLayout() {
                                               setSpacing(3)
                                               for n = 1 to size+2
                                                    AddLayout(LayoutButtonRow[n])
                                                    win.show()
                                               next }
		  win.setLayout(LayoutButtonMain)
                  win.show()
                  pbegin()  
         }
    exec()
}

func pbegin() 
       nScore = 0
       bsumold = 0
       bsumnew = 0
       playerscore.settext("Play Score:")
       buttonnew = newlist(size,size)
       for n = 1 to limit
            rx = random(size-1)+1
            ry = random(size-1)+1
            buttonnew[rx][ry] = 1
       next
       for n = 1 to size
            for m = 1 to size
                 buttonold[n][m] {setstylesheet('background-color:gray')
                                          setenabled(true)}
            next
       next
       for n = 1 to size
            for m = 1 to size
                 if buttonnew[n][m] = 1
                    bsumold = bsumold + 1
                    buttonold[n][m].setstylesheet('background-color:orange')
                    buttonold[n][m].show()
                 ok
             next
        next
        see nl
        app.processevents()
        sleep(3)
        for n = 1 to size
             for m = 1 to size
                  if buttonnew[n][m] = 1
                     buttonold[n][m] {setstylesheet('background-color:gray')}
                  ok
              next
         next

func pplay(n,m) 
       if buttonnew[n][m] = 1
          nScore = nScore + 1
          bsumnew = bsumnew + 1
          buttonold[n][m] {setstylesheet('background-color:orange')
                                   setenabled(false)}
          if bsumold = bsumnew and bsumold != 0 and bsumnew != 0
             msgBox("You won!")
          ok
       else
          nScore = nScore - 1
          buttonold[n][m] {setstylesheet('background-color:white')
                                   setenabled(false)}
       ok
       playerscore.settext("Play Score: " + nScore)

func msgBox(text) {
	mb = new qMessageBox(win) {
	        setWindowTitle('Memory Game')
	        setText(text)
                setstandardbuttons(QMessageBox_Yes | QMessageBox_No | QMessageBox_Close) 
                result = exec()
                win { if result = QMessageBox_Yes pbegin() ok } 
	        }
        }
