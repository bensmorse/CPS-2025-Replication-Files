library(sandwich)
library(lmtest)
library(zoo)
library(Matching)
library(plm)
library(plyr)
library(AER)
library(mlogit)
library(lattice)
library(texreg)
library(RColorBrewer)
library(foreign)


# Set working directory 

setwd ("C:\\Users\\BenMorse\\Dropbox\\1. Research\\CP_Liberia\\Data\\liberia")


# FIGURE 1 Effects on Hypothesized Mechanisms
	###############
	# Note:  Figure 1 is constructed from "figure1_mechanisms_plot.csv". 
  #       "figure1_mechanisms_plot.csv" has to be constructed manual by reformatting / transposing "figure1_mechanisms.csv",
  #       which is produced in "LIB_MK4_07_data_analysis_code.do", so that there are three columns: varnames, ate, and se
  #       start with figure1_mechanisms.csv, transpose data, rename columns, and save with _plot suffix
	###############


out<-read.csv("07_Results\\figure1_mechanisms_plot.csv")
labs<-c("Familiarity w/ police", "Knowledge of law","Perceptions of police intentions","Norms supporting cooperation",
        "Perceptions of police capacity","Perceptions of police responsiveness","Contributions to community coproduction",
        "Support for mob violence","Knowledge of watch group rules")


pdf("07_Results\\figure1_mechanisms.pdf")
	
par(mar=c(3,0,0,0),font=1)	
	
	# empty plot
	plot(x=c(), y=c(), ylim=c(.75,12.3), xlim=c(-.96, .4), yaxt="n", xaxt="n",frame.plot=FALSE,xlab="", ylab="",family="serif") # family="times"
	lines(x=c(0,0),y=c(-.1,12.3),lty=2,col="black")

	# COSTS OF COOPERATION
	text("Costs of cooperation", x=-.5,y=12, col="black",cex=1.25, pos=4, family = "serif", font=2) 
	# plot CIs 		
		lines(x=c(out[1,2]-1.96*out[1,3],out[1,2]+1.96*out[1,3]),y=c(11,11), col="gray", lwd=2)
		lines(x=c(out[2,2]-1.96*out[2,3],out[2,2]+1.96*out[2,3]),y=c(10,10), col="gray", lwd=2)
		lines(x=c(out[3,2]-1.96*out[3,3],out[3,2]+1.96*out[3,3]),y=c(9,9), col="gray", lwd=2)
		lines(x=c(out[4,2]-1.96*out[4,3],out[4,2]+1.96*out[4,3]),y=c(8,8), col="gray", lwd=2)
	# plot point estimates 
		points(x=out[1,"ate"],y=11, pch=16, col="black",cex=1.25)  
		points(x=out[2,"ate"],y=10, pch=16, col="black",cex=1.25)  
		points(x=out[3,"ate"],y=9, pch=16, col="black",cex=1.25)  
		points(x=out[4,"ate"],y=8, pch=16, col="black",cex=1.25)  
	# plot labels
		text(labs[1], x=-1,y=11, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[2], x=-1,y=10, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[3], x=-1,y=9, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[4], x=-1,y=8, col="black",cex=1.25, pos=4, family = "serif") 
	
	# BENEFITS OF COOPERATION
	text("Benefits of cooperation", x=-.5,y=7, col="black",cex=1.25, pos=4, family = "serif", font=2) 
	# plot CIs 		
		lines(x=c(out[5,2]-1.96*out[5,3],out[5,2]+1.96*out[5,3]),y=c(6,6), col="gray", lwd=2)
		lines(x=c(out[6,2]-1.96*out[6,3],out[6,2]+1.96*out[6,3]),y=c(5,5), col="gray", lwd=2)

	# plot point estimates 
		points(x=out[5,"ate"],y=6, pch=16, col="black",cex=1.25)  
		points(x=out[6,"ate"],y=5, pch=16, col="black",cex=1.25)  
	# plot labels
		text(labs[5], x=-1,y=6, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[6], x=-1,y=5, col="black",cex=1.25, pos=4, family = "serif") 
	
	# COPRODUCTION
	
	text("Community coproduction", x=-.5,y=4, col="black",cex=1.25, pos=4, family = "serif", font=2) 
	# plot CIs 		
		lines(x=c(out[7,2]-1.96*out[7,3],out[7,2]+1.96*out[7,3]),y=c(3,3), col="gray", lwd=2)
		lines(x=c(out[8,2]-1.96*out[8,3],out[8,2]+1.96*out[8,3]),y=c(2,2), col="gray", lwd=2)
		lines(x=c(out[9,2]-1.96*out[9,3],out[9,2]+1.96*out[9,3]),y=c(1,1), col="gray", lwd=2)

	# plot point estimates 
		points(x=out[7,"ate"],y=3, pch=16, col="black",cex=1.25)  
		points(x=out[8,"ate"],y=2, pch=16, col="black",cex=1.25)  
		points(x=out[9,"ate"],y=1, pch=16, col="black",cex=1.25)  
	# plot labels
		text(labs[7], x=-1,y=3, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[8], x=-1,y=2, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[9], x=-1,y=1, col="black",cex=1.25, pos=4, family = "serif") 
	
	#Axis
	axis(1,labels=c("-.3","-.15", "0",".15", ".3"),at=c(-.3,-.15,0,.15,.3), las=FALSE, tick=TRUE, cex.axis = 1.25, family = "serif")
	
dev.off()



# FIGURE 2 Effects on coproduction indices disaggregated by component variables
###############
# Note:  Figure 2 is constructed from "figure2_coproduction_plot.csv". 
#       "figure2_coproduction_plot.csv" has to be constructed manual by reformatting / transposing "figure2_coproduction.csv",
#       which is produced in "LIB_MK4_07_data_analysis_code.do", so that there are three columns: varnames, ate, and se
#       start with figure2_coproduction_plot.csv, transpose data, rename columns, and save with _plot suffix
###############


out<-read.csv("07_Results\\figure2_coproduction_plot.csv")
labs<-c("Seen security mtg past month","Attended meeting past month","Seen patrol past month","Attended patrol past month","Gave food/tea past month","Town has Watch Forum?","Forum patrols at night?","Forum meets regularly?","Forum registered w/ police?","Attempted rape?","Armed robbery?","Burglary?","Weapons prohibited","Physical harm prohibited","Must avoid risks & danger","Checkpoints prohibited","Only operate in home community","Can perform citizens' arrest")

pdf("07_Results\\figure2_coproduction.pdf")

	
par(mar=c(3,0,0,0),font=1)	
	
	# empty plot
	plot(x=c(), y=c(), ylim=c(.75,21.3), xlim=c(-.58, .25), yaxt="n", xaxt="n",frame.plot=FALSE,xlab="", ylab="",family="serif") # family="times"
	lines(x=c(0,0),y=c(-.1,6.5),lty=2,col="black")
	lines(x=c(0,0),y=c(7.5,10.5),lty=2,col="black")
	lines(x=c(0,0),y=c(11.5,20.5),lty=2,col="black")

	# COMMUNITY COORDINATION & COLLECTIVE ACTION
	text("Community coordination & collective action", x=-.25,y=21, col="black",cex=1.25, pos=4, family = "serif", font=2) 
	# plot CIs 		
		lines(x=c(out[1,2]-1.96*out[1,3],out[1,2]+1.96*out[1,3]),y=c(20,20), col="gray", lwd=2)
		lines(x=c(out[2,2]-1.96*out[2,3],out[2,2]+1.96*out[2,3]),y=c(19,19), col="gray", lwd=2)
		lines(x=c(out[3,2]-1.96*out[3,3],out[3,2]+1.96*out[3,3]),y=c(18,18), col="gray", lwd=2)
		lines(x=c(out[4,2]-1.96*out[4,3],out[4,2]+1.96*out[4,3]),y=c(17,17), col="gray", lwd=2)
		lines(x=c(out[5,2]-1.96*out[5,3],out[5,2]+1.96*out[5,3]),y=c(16,16), col="gray", lwd=2)
		lines(x=c(out[6,2]-1.96*out[6,3],out[6,2]+1.96*out[6,3]),y=c(15,15), col="gray", lwd=2)
		lines(x=c(out[7,2]-1.96*out[7,3],out[7,2]+1.96*out[7,3]),y=c(14,14), col="gray", lwd=2)
		lines(x=c(out[8,2]-1.96*out[8,3],out[8,2]+1.96*out[8,3]),y=c(13,13), col="gray", lwd=2)
		lines(x=c(out[9,2]-1.96*out[9,3],out[9,2]+1.96*out[9,3]),y=c(12,12), col="gray", lwd=2)
	
	# plot point estimates 
		points(x=out[1,"ate"],y=20, pch=16, col="black",cex=1.25)  
		points(x=out[2,"ate"],y=19, pch=16, col="black",cex=1.25)  
		points(x=out[3,"ate"],y=18, pch=16, col="black",cex=1.25)  
		points(x=out[4,"ate"],y=17, pch=16, col="black",cex=1.25)  
		points(x=out[5,"ate"],y=16, pch=16, col="black",cex=1.25)  
		points(x=out[6,"ate"],y=15, pch=16, col="black",cex=1.25)  
		points(x=out[7,"ate"],y=14, pch=16, col="black",cex=1.25)  
		points(x=out[8,"ate"],y=13, pch=16, col="black",cex=1.25)  
		points(x=out[9,"ate"],y=12, pch=16, col="black",cex=1.25)  
	
	# plot labels
		text(labs[1], x=-.6,y=20, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[2], x=-.6,y=19, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[3], x=-.6,y=18, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[4], x=-.6,y=17, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[5], x=-.6,y=16, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[6], x=-.6,y=15, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[7], x=-.6,y=14, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[8], x=-.6,y=13, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[9], x=-.6,y=12, col="black",cex=1.25, pos=4, family = "serif") 


		
	
	# MOB VIOLENCE JUSTIFIED RESPONSE TO
	text("Mob violence a justified response to:", x=-.25,y=11, col="black",cex=1.25, pos=4, family = "serif", font=2) 
	# plot CIs 		
		lines(x=c(out[10,2]-1.96*out[10,3],out[10,2]+1.96*out[10,3]),y=c(10,10), col="gray", lwd=2)
		lines(x=c(out[11,2]-1.96*out[11,3],out[11,2]+1.96*out[11,3]),y=c(9,9), col="gray", lwd=2)
		lines(x=c(out[12,2]-1.96*out[12,3],out[12,2]+1.96*out[12,3]),y=c(8,8), col="gray", lwd=2)

	# plot point estimates 
		points(x=out[10,"ate"],y=10, pch=16, col="black",cex=1.25)  
		points(x=out[11,"ate"],y=9, pch=16, col="black",cex=1.25)  
		points(x=out[12,"ate"],y=8, pch=16, col="black",cex=1.25)  
	
	# plot labels
		text(labs[10], x=-.6,y=10, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[11], x=-.6,y=9, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[12], x=-.6,y=8, col="black",cex=1.25, pos=4, family = "serif") 
	
	
	# KNOWLEDGE OF RULES GOVERNING LOCAL SECURITY	
	text("Knowledge of rules governing local security", x=-.25,y=7, col="black",cex=1.25, pos=4, family = "serif", font=2) 
	# plot CIs 		
		lines(x=c(out[13,2]-1.96*out[13,3],out[13,2]+1.96*out[13,3]),y=c(6,6), col="gray", lwd=2)
		lines(x=c(out[14,2]-1.96*out[14,3],out[14,2]+1.96*out[14,3]),y=c(5,5), col="gray", lwd=2)
		lines(x=c(out[15,2]-1.96*out[15,3],out[15,2]+1.96*out[15,3]),y=c(4,4), col="gray", lwd=2)
		lines(x=c(out[16,2]-1.96*out[16,3],out[16,2]+1.96*out[16,3]),y=c(3,3), col="gray", lwd=2)
		lines(x=c(out[17,2]-1.96*out[17,3],out[17,2]+1.96*out[17,3]),y=c(2,2), col="gray", lwd=2)
		lines(x=c(out[18,2]-1.96*out[18,3],out[18,2]+1.96*out[18,3]),y=c(1,1), col="gray", lwd=2)

		
	# plot point estimates 
		points(x=out[13,"ate"],y=6, pch=16, col="black",cex=1.25)  
		points(x=out[14,"ate"],y=5, pch=16, col="black",cex=1.25)  
		points(x=out[15,"ate"],y=4, pch=16, col="black",cex=1.25)  
		points(x=out[16,"ate"],y=3, pch=16, col="black",cex=1.25)  
		points(x=out[17,"ate"],y=2, pch=16, col="black",cex=1.25)  
		points(x=out[18,"ate"],y=1, pch=16, col="black",cex=1.25)  
	
	# plot labels
		text(labs[13], x=-.6,y=6, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[14], x=-.6,y=5, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[15], x=-.6,y=4, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[16], x=-.6,y=3, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[17], x=-.6,y=2, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[18], x=-.6,y=1, col="black",cex=1.25, pos=4, family = "serif") 
	
	#Axis
	axis(1,labels=c("-.2","-.1", "0",".1", ".2"),at=c(-.2,-.1,0,.1,.2), las=FALSE, tick=TRUE, cex.axis = 1.25, family = "serif")
	
dev.off()




# FIGURE 3 Effects on primary outcomes
###############
# Note:  Figure 3 is constructed from "figure3_primaryoutcomes_plot.csv". 
#       "figure3_primaryoutcomes_plot.csv" has to be constructed manual by reformatting / transposing "figure3_primaryoutcomes.csv",
#       which is produced in "LIB_MK4_07_data_analysis_code.do", so that there are three columns: varnames, ate, and se
#       start with figure3_primaryoutcomes_plot.csv, transpose data, rename columns, and save with _plot suffix
###############



out<-read.csv("07_Results\\figure3_primaryoutcomes_plot.csv")
labs<-c("Willingness to report crimes","Crime tips & information sharing","Willingness to report police misconduct","Incidence of crime","Perceptions of security","Satisfaction with police performance","Incidence of mob violence")

# add in adjusted p-value
out<-cbind(out,round(p.adjust(out[,"pvalue"],"BH"), digits=2))



pdf("07_Results\\figure3_primaryoutcomes.pdf")

par(mar=c(3,0,1,0),font=1)	
	
	# empty plot
	plot(x=c(), y=c(), ylim=c(.75,9.3), xlim=c(-.96, .4), yaxt="n", xaxt="n",frame.plot=FALSE,xlab="", ylab="",family="serif") # family="times"
	lines(x=c(0,0),y=c(-.1,8.5),lty=2,col="black")

	# COOPERATION WITH POLICE
	text("Cooperation with police", x=-.5,y=9, col="black",cex=1.25, pos=4, family = "serif", font=2) 
	# plot CIs 		
		lines(x=c(out[1,2]-1.96*out[1,3],out[1,2]+1.96*out[1,3]),y=c(8,8), col="gray", lwd=2)
		lines(x=c(out[2,2]-1.96*out[2,3],out[2,2]+1.96*out[2,3]),y=c(7,7), col="gray", lwd=2)
		lines(x=c(out[3,2]-1.96*out[3,3],out[3,2]+1.96*out[3,3]),y=c(6,6), col="gray", lwd=2)
	# plot point estimates 
		points(x=out[1,"ate"],y=8, pch=16, col="black",cex=1.25)  
		points(x=out[2,"ate"],y=7, pch=16, col="black",cex=1.25)  
		points(x=out[3,"ate"],y=6, pch=16, col="black",cex=1.25)  
	# plot labels
		text(labs[1], x=-1,y=8, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[2], x=-1,y=7, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[3], x=-1,y=6, col="black",cex=1.25, pos=4, family = "serif") 
	# plot pvalues
		text(out[1,5], x=.29,y=8, col="black",cex=1.25, pos=4, family = "serif") 
		text(out[2,5], x=.29,y=7, col="black",cex=1.25, pos=4, family = "serif") 
		text(out[3,5], x=.29,y=6, col="black",cex=1.25, pos=4, family = "serif") 
		
	
	# SECURITY
	text("Security", x=-.4,y=5, col="black",cex=1.25, pos=4, family = "serif", font=2) 
	# plot CIs 		
		lines(x=c(out[4,2]-1.96*out[4,3],out[4,2]+1.96*out[4,3]),y=c(4,4), col="gray", lwd=2)
		lines(x=c(out[5,2]-1.96*out[5,3],out[5,2]+1.96*out[5,3]),y=c(3,3), col="gray", lwd=2)
		lines(x=c(out[6,2]-1.96*out[6,3],out[6,2]+1.96*out[6,3]),y=c(2,2), col="gray", lwd=2)
		lines(x=c(out[7,2]-1.96*out[7,3],out[7,2]+1.96*out[7,3]),y=c(1,1), col="gray", lwd=2)

	# plot point estimates 
		points(x=out[4,"ate"],y=4, pch=16, col="black",cex=1.25)  
		points(x=out[5,"ate"],y=3, pch=16, col="black",cex=1.25)  
		points(x=out[6,"ate"],y=2, pch=16, col="black",cex=1.25)  
		points(x=out[7,"ate"],y=1, pch=16, col="black",cex=1.25)  
	
	# plot labels
		text(labs[4], x=-1,y=4, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[5], x=-1,y=3, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[6], x=-1,y=2, col="black",cex=1.25, pos=4, family = "serif") 
		text(labs[7], x=-1,y=1, col="black",cex=1.25, pos=4, family = "serif") 
	
	# plot pvalues
		text(out[4,5], x=.29,y=4, col="black",cex=1.25, pos=4, family = "serif") 
		text(out[5,5], x=.29,y=3, col="black",cex=1.25, pos=4, family = "serif") 
		text(out[6,5], x=.29,y=2, col="black",cex=1.25, pos=4, family = "serif") 
		text(out[7,5], x=.29,y=1, col="black",cex=1.25, pos=4, family = "serif") 
		
	#Axis
	axis(1,labels=c("-.3","-.15", "0",".15", ".3"),at=c(-.3,-.15,0,.15,.3), las=FALSE, tick=TRUE, cex.axis = 1.25, family = "serif")
	
	# adjusted p-value heading
	
	text("Adj. p-val", x=.235,y=9, col="black",cex=1.25, pos=4, family = "serif") 
	
	
dev.off()



