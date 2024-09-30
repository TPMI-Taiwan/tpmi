library(ggplot2)
library(auctestr)
library(ggpubr)

## draw Figure 6
prsinput = read.csv('Fig6_data.csv', header = T)
prsg1 = prsinput[which(prsinput$Group=='Group1'), ]
prsg1$prs.type = apply(prsg1[,c('PRS','Type')],  MARGIN = 1, function(x) paste(x, collapse = ':', sep = ":"))
prsg1$PRS = factor(prsg1$PRS, levels = c('PRSmix','LDPred2'))
prsg1$AUC.se = apply(prsg1[,c("AUC","case","control")], MARGIN = 1, function(x) se_auc(x[1], x[2], x[3]))
prsg1$Phenotype = factor(prsg1$Phenotype, levels = rev(prsg1$Phenotype[1:27]))
g1 = ggplot(prsg1)+
  geom_col(position="dodge", aes(fill=  prs.type, y = value, x= Phenotype, group=PRS)) +
  geom_point(position = position_dodge(width = 1), aes(y=(AUC-0.5)/1, x = Phenotype,  group=PRS, color=PRS), size=1.5)+
  geom_errorbar(aes(ymin=(AUC-1.96*AUC.se-0.5)/1, ymax=(AUC+1.96*AUC.se-0.5)/1, x = Phenotype,  group=PRS, color=PRS ), width=.2,
                position=position_dodge(1)) +
  scale_fill_manual(values = c("lightgray", "darkred", "lightgray","darkblue"),
                    labels= c("heritability", "LDPred2", "PRSmix+",'')) +
  scale_y_continuous(name = expression(paste("heritability (",h^2, ") and correlation (", r^2,")")), sec.axis = sec_axis(~ .*1 +0.5, name = "AUC"), limits = c(0,.25))+
  scale_color_manual(values = c( "blue", "red" ), labels = c('PRSmix+','LDPred2'))+
  theme(legend.position = "none", panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  ylab("") +
  xlab("") + 
  coord_flip()+
  guides(fill = guide_legend(override.aes = list(fill = c('lightgray', 'darkred', 'darkblue','white'), colour=c("white","white","white","white")), 
                             title="bar"),
         color = guide_legend(title='AUC'))

prsg2 = prsinput[which(prsinput$Group=='Group2'), ]
prsg2$prs.type = apply(prsg2[,c('PRS','Type')],  MARGIN = 1, function(x) paste(x, collapse = ':', sep = ":"))
prsg2$PRS = factor(prsg2$PRS, levels = c('PRSmix','LDPred2'))
prsg2$AUC.se = apply(prsg2[,c("AUC","case","control")], MARGIN = 1, function(x) se_auc(x[1], x[2], x[3]))
prsg2$Phenotype = factor(prsg2$Phenotype, levels = rev(prsg2$Phenotype[1:17]))
g2 = ggplot(prsg2)+
  geom_col(position="dodge", aes(fill=  prs.type, y = value, x= Phenotype, group=PRS)) +
  geom_point(position = position_dodge(width = 1), aes(y=(AUC-0.5)/2, x = Phenotype,  group=PRS, color=PRS), size=1.5)+
  geom_errorbar(aes(ymin=(AUC-1.96*AUC.se-0.5)/2, ymax=(AUC+1.96*AUC.se-0.5)/2, x = Phenotype,  group=PRS, color=PRS ), width=.2,
                position=position_dodge(1)) +
  scale_fill_manual(values = c("lightgray", "darkred", "lightgray","darkblue"),
                    labels= c("heritability", "LDPred2", "PRSmix+",'')) +
  scale_y_continuous(name = expression(paste("heritability (",h^2, ") and correlation (", r^2,")")), sec.axis = sec_axis(~ .*2 +0.5, name = "AUC"), limits = c(0,.15))+
  scale_color_manual(values = c( "blue", "red" ), labels = c('PRSmix+','LDPred2'))+
  theme(legend.position = "none", panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  ylab("") +
  xlab("") + 
  coord_flip()+
  guides(fill = guide_legend(override.aes = list(fill = c('lightgray', 'darkred', 'darkblue','white'), colour=c("white","white","white","white")), 
                             title="bar"),
         color = guide_legend(title='AUC'))

prsg3 = prsinput[which(prsinput$Group=='Group3'), ]
prsg3$prs.type = apply(prsg3[,c('PRS','Type')],  MARGIN = 1, function(x) paste(x, collapse = ':', sep = ":"))
prsg3$PRS = factor(prsg3$PRS, levels = c('PRSmix','LDPred2'))
prsg3$AUC.se = apply(prsg3[,c("AUC","case","control")], MARGIN = 1, function(x) se_auc(x[1], x[2], x[3]))
prsg3$Phenotype = factor(prsg3$Phenotype, levels = rev(prsg3$Phenotype[1:13]))
g3 = ggplot(prsg3)+
  geom_col(position="dodge", aes(fill=  prs.type, y = value, x= Phenotype, group=PRS)) +
  geom_point(position = position_dodge(width = 1), aes(y=(AUC-0.5)/1.5, x = Phenotype,  group=PRS, color=PRS), size=1.5)+
  geom_errorbar(aes(ymin=(AUC-1.96*AUC.se-0.5)/1.5, ymax=(AUC+1.96*AUC.se-0.5)/1.5, x = Phenotype,  group=PRS, color=PRS ), width=.2,
                position=position_dodge(1)) +
  scale_fill_manual(values = c("lightgray", "darkred", "lightgray","darkblue"),
                    labels= c("heritability", "LDPred2", "PRSmix+",'')) +
  scale_y_continuous(name = expression(paste("heritability (",h^2, ") and correlation (", r^2,")")), sec.axis = sec_axis(~ .*1.5 +0.5, name = "AUC"), limits = c(0,.26))+
  scale_color_manual(values = c( "blue", "red" ), labels = c('PRSmix+','LDPred2'))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  ylab("") +
  xlab("") + 
  coord_flip()+
  guides(fill = guide_legend(override.aes = list(fill = c('lightgray', 'darkred', 'darkblue','white'), colour=c("white","white","white","white")), 
                             title="bar"),
         color = guide_legend(title='AUC'))

png('Fig6.png', height = 8, width = 16, units = 'in', res = 300)
ggarrange(g1, g2, g3,
          labels = c("A", "B", "C"),
          ncol = 3, nrow = 1, widths = c(1.25,1,1), common.legend = T, legend = 'right')
dev.off()

## draw Figure S2
prsother = read.csv('FigS2_data.csv', header = T)

prsother$Phenotype = factor(prsother$Phenotype, levels = rev(prsother$Phenotype[1:75]))
prsother$AUC.se = apply(prsother[,c("AUC","case","control")], MARGIN = 1, function(x) se_auc(x[1], x[2], x[3]))
prsother$prs.type = apply(prsother[,c('PRS','Type')],  MARGIN = 1, function(x) paste(x, collapse = ':', sep = ":"))
png('FigS2.png', height = 7, width = 14, units = 'in', res = 300)
ggplot(prsother)+
  geom_col(position="dodge", aes(fill=  prs.type, y = value, x= Phenotype, group=PRS)) +
  geom_point(position = position_dodge(width = 1), aes(y=(AUC-0.5)/1, x = Phenotype, color='red'), size=1.5)+
  geom_errorbar(aes(ymin=(AUC-1.96*AUC.se-0.5)/1, ymax=(AUC+1.96*AUC.se-0.5)/1, x = Phenotype,  color='red' ), width=.2,
                position=position_dodge(1)) +
  scale_fill_manual(values = c("lightgray", "darkred"),
                    labels= c("heritability", "LDPred2")) +
  scale_y_continuous(name = expression(paste("heritability (",h^2, ") and correlation coefficient (", r^2,")")), sec.axis = sec_axis(~ .*1 +0.5, name = "AUC"), limits = c(0,.35))+
  scale_color_manual(values = c( "red" ), labels = c('LDPred2'))+
  scale_x_discrete(guide = guide_axis(angle = 50)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  ylab("") +
  xlab("") + 
  guides(fill = guide_legend(override.aes = list(fill = c('lightgray', 'darkred')), 
                             title=expression(paste("bar"))),
         color = guide_legend(title='AUC'))
dev.off()
