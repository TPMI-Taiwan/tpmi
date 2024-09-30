library(ggplot2)

## draw figure 7
extval = read.csv('Fig7_data.csv', header = T)
extval[which(extval$Biobank %in% c('TPMI','TWB')),'AUC.SE'] = apply(extval[which(extval$Biobank %in% c('TPMI','TWB')),c("AUC","Case",'Control')], MARGIN = 1, function(x) se_auc(x[1], x[2], x[3]))
extval$Biobank = factor(extval$Biobank, levels = c('TPMI','TWB','UKB (EAS)','All of Us (EAS)'))
extval$Phenotype = factor(extval$Phenotype, levels = c('Cancer of prostate','Viral hepatitis B','Type 2 diabetes','Hypertension','Gout','Alcoholism','Breast cancer female','Calculus of kidney','Glaucoma','Migraine'))

png("Fig7.png", width = 9, height = 5, units = "in", res = 300)
ggplot(extval[which(extval$Case>40),], aes(shape = PRS, x=Biobank, y= AUC, color=Biobank))+
  geom_point(position = position_dodge(width = 1), size=2)+
  geom_errorbar(aes(ymin=(AUC-1.96*AUC.SE), ymax=(AUC+1.96*AUC.SE), x =Biobank,color=Biobank ), width=.1,
                position=position_dodge(1))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        strip.text.x = ggplot2::element_text(size = 9, angle=90),
        axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank())+
  facet_wrap(.~Phenotype, nrow=1, strip.position = 'top')
dev.off()

## draw figure S3
extval3 = read.csv('FigS3_data.csv', header = T)
extval3[which(extval3$Biobank %in% c('TPMI')),'AUC.SE'] = apply(extval3[which(extval3$Biobank %in% c('TPMI')),c("AUC","Case",'Control')], MARGIN = 1, function(x) se_auc(x[1], x[2], x[3]))
extval3$Biobank = factor(extval3$Biobank, levels = c('TPMI', 'UKB', 'All of Us'))
extval3$Phenotype = factor(extval3$Phenotype, levels = c('Cancer of prostate','Viral hepatitis B','Type 2 diabetes','Hypertension','Gout','Alcoholism','Breast cancer female','Calculus of kidney','Glaucoma','Migraine'))
extval3$SuperPop = factor(extval3$SuperPop, levels = c("EAS", "EUR", "AFR", "SAS", "AMR"))
png("FigS3.png", width = 9, height = 5, units = "in", res = 300)
ggplot(extval3, aes(shape = Biobank, x=SuperPop, y= AUC, color=SuperPop))+
  geom_point(position = position_dodge(width = 1), size=2)+
  geom_errorbar(aes(ymin=(AUC-1.96*AUC.SE), ymax=(AUC+1.96*AUC.SE), x =SuperPop,color=SuperPop ), width=.1,
                position=position_dodge(1))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        strip.text.x = ggplot2::element_text(size = 9, angle=90),
        axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank())+
  facet_wrap(.~Phenotype, nrow=1, strip.position = 'top')
dev.off()
