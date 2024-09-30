library(karyoploteR)
mg <- read.table("mygenome.txt",header=T)
geno <- toGRanges("mygenome.txt")

pp <- getDefaultPlotParams(plot.type=3)
pp$ideogramlateralmargin=0.005
pp$ideogramheight=0
pp$data1height=150
pp$data2height=150
pp$data1inmargin=8
pp$data2inmargin=8
 
kp <- plotKaryotype(plot.type=3, genome=geno , plot.params = pp, labels.plotter = NULL)
kpRect(kp, chr='1', x0=0, x1=1e10, y0=0.49, y1=0.51, col="white", data.panel="all", border=NA)
kpAddChromosomeNames(kp, yoffset=-165, cex=1)
kpAxis(kp, ymin=0, ymax=60, numticks = 4, cex=1, r0=0, r1=0.9)
kpAxis(kp, ymin=0, ymax=60, numticks = 4, cex=1, r0=0, r1=0.9, data.panel = 2)
kpAddLabels(kp, labels="Number of independent variant-trait associations",label.margin = 0.038, srt=90)
 

### input file contains: "chromosome" "position" "p" "logp" "transp" "prob" "color" "phecode"

# phecode
phe <- read.table("finemapping.info.for_kp.phecode.sort.m.txt",header=T)
phe$pos <- as.integer(phe$position/10000000)*10000000
frq_all <- as.data.frame(table(phe[,c('chromosome','pos')]))
color <- unique(phe$color[which(!is.na(phe$color))])
max(frq_all$Freq)
 
for (chr in 1:22) {
        n <- as.integer(mg$end[which(mg$chr==chr)]/10000000)
        tmp <- data.frame(col1=seq(0,n*10000000,10000000))
        colnames(tmp)[1] <- "pos"
        peak <- tmp
        peak$cum_y0 <- 0
        for (c in color) {
            qq <- as.data.frame(table(phe[which(phe$color==c & phe$chromosome==chr),c('pos')]))
            if(length(row.names(qq))!=0)
            {
                m <- merge(tmp,qq,by.x='pos',by.y='Var1',all.x=T)
                m$Freq[which(is.na(m$Freq))] <- 0
                z <- as.data.frame(m)
                z$x0 <- as.integer(z$pos)
                z$x1 <- as.integer(z$pos)+10000000
                z$y0 <- peak$cum_y0
                z$y1 <- z$y0 + z$Freq/60
                kpRect(kp, chr=chr, x0=z$x0, x1=z$x1, y0=z$y0, y1=z$y1,col=c, r0=0, r1=0.9)
                peak$cum_y0 <- peak$cum_y0 + z$Freq/60
            }
        }
}

# qt
phe <- read.table("finemapping.info.for_kp.qt.sort.m.txt",header=T)
phe$pos <- as.integer(phe$position/10000000)*10000000
frq_all <- as.data.frame(table(phe[,c('chromosome','pos')]))
color <- unique(phe$color[which(!is.na(phe$color))])
max(frq_all$Freq)
 
for (chr in 1:22) {
        n <- as.integer(mg$end[which(mg$chr==chr)]/10000000)
        tmp <- data.frame(col1=seq(0,n*10000000,10000000))
        colnames(tmp)[1] <- "pos"
        peak <- tmp
        peak$cum_y0 <- 0
        for (c in color) {
            qq <- as.data.frame(table(phe[which(phe$color==c & phe$chromosome==chr),c('pos')]))
            if(length(row.names(qq))!=0)
            {
                m <- merge(tmp,qq,by.x='pos',by.y='Var1',all.x=T)
                m$Freq[which(is.na(m$Freq))] <- 0
                z <- as.data.frame(m)
                z$x0 <- as.integer(z$pos)
                z$x1 <- as.integer(z$pos)+10000000
                z$y0 <- peak$cum_y0
                z$y1 <- z$y0 + z$Freq/60
                kpRect(kp, chr=chr, x0=z$x0, x1=z$x1, y0=z$y0, y1=z$y1,col=c, data.panel = 2, r0=0, r1=0.9)
                peak$cum_y0 <- peak$cum_y0 + z$Freq/60
            }
        }
}
 
cat <-c("Circulatory system","Dermatologic","Digestive","Endocrine/metabolic","Genitourinary","Hematopoietic","Infectious diseases","Mental disorders","Musculoskeletal","Neoplasms","Neurological","Respiratory","Sense organs","Symptoms")
clr <- c("#F8766D","#E58700","#C99800","#A3A500","#6BB100","#00BA38","#00BF7D","#00BCD8","#00B0F6","#619CFF","#B983FF","#E76BF3","#FD61D1","#FF67A4")
legend(legend=cat, fill=clr, cex=1, bty="n", horiz=FALSE, ncol=7, x=0.1, y=1.05)
 
cat2 <-c("Anthropometric","Circulation","Hematological","Kidney","Liver","Metabolic")
clr2 <- c("#FF796C","#FF81C0","#FAC205","#15B01A","#06C2AC","#069AF3")
legend(legend=cat2, fill=clr2, cex=1, bty="n", horiz=TRUE, x=0.2, y=-0.02)
