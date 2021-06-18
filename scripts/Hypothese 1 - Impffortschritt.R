# --- -------------------------------------------------------------------------------------
# --- Hypothese 1
# --- Reiche Länder schreiten bei den COVID-19 Impfungen schneller voran als ärmere Länder.
# ---
# --- V3  15.06.2021, M.Markovic
# ---
# --- Libraries: readxl, ggplot2, gganimate, psych
# ---
# --- Data: OWID COVID-19
# ---
# --- Links
# --- https://github.com/owid/covid-19-data/tree/master/public/data
# ---
# --- -------------------------------------------------------------------------------------

# PACKAGES installieren, falls nicht vorhanden
if(!"readxl" %in% rownames(installed.packages())) install.packages("readxl")
if(!"ggplot2" %in% rownames(installed.packages())) install.packages("ggplot2")
if(!"gganimate" %in% rownames(installed.packages())) install.packages("gganimate")
if(!"psych" %in% rownames(installed.packages())) install.packages("psych")

# Packages laden
library("readxl")
library("ggplot2")
library("gganimate")
library("psych")

# Set WORKING Directory
setwd(choose.dir())

# Impffortschritt anhand der Stichprobe untersuchen
# Stichprobe laden
Stichprobe <- read_excel("2021_06_01_owid-covid-data_NZ.xlsx")
View(Stichprobe)

# ------------------------------------------------
# --- Deskriptive Statistik
# ------------------------------------------------

# Boxplot erstellen, um die Verteilung der Daten zwischen den Kontinenten festzustellen
# pro HDI-Level
boxplot(Stichprobe$people_fully_vaccinated_per_hundred~Stichprobe$hdi_level,
        ylab="People Fully Vaccinated per Hundred", xlab="HDI-Level",
        main="Verteilung vollständig Geimpfte pro HDI_Level")

ggplot(Stichprobe, aes(y=people_fully_vaccinated_per_hundred, 
                       group=hdi_level, 
                       x=hdi_level)) +
  stat_boxplot(geom='errorbar', width=0.5) +
  geom_boxplot(fill=c("cyan", "darkred", "darkorange", "blue")) +
  labs(x= "HDI-Level", y="Anteil vollständig Geimpfte (in %)",
       title="Verteilung vollständig Geimpfte pro HDI-Level")

# Deskriptive Statistik für HDI-Level Gruppen (Median, Quantile, usw.)
describeBy(Stichprobe$people_fully_vaccinated_per_hundred, group = Stichprobe$hdi_level)

# pro Kontinent
boxplot(Stichprobe$people_fully_vaccinated_per_hundred~Stichprobe$continent,
        ylab="People Fully Vaccinated per Hundred", xlab="Kontinente",
        main="Verteilung vollständig Geimpfte pro Kontinent")

ggplot(Stichprobe, aes(y= people_fully_vaccinated_per_hundred,
                       group= continent,
                         x= continent)) +
  stat_boxplot(geom='errorbar', width=0.5) +
  geom_boxplot(fill=c("coral", "yellow4", "mediumseagreen", "cornflowerblue", "darkorchid1")) +
  labs(x= "Kontinent", y="Anteil vollständig Geimpfte (in %)",
       title="Verteilung vollständig Geimpfte pro Kontinent")

# Deskriptive Statistik für Kontinente Gruppen (Median, Quantile, usw.)
describeBy(Stichprobe$people_fully_vaccinated_per_hundred, group = Stichprobe$continent)


# ------------------------------------------------
# --- Schliessende Statistik mittels Non-Linearer Regression
# ------------------------------------------------

# Punktdiagramm erstellen, um den Fortschritt grafisch darzustellen, aufgeteilt pro Continent
ggplot(Stichprobe) +
  aes(x = `people_fully_vaccinated_per_hundred`,
      y = `human_development_index`,
      color = continent) +
  labs(x= "Anteil vollständig Geimpfte (in %)", y= "HDI-Level",
      title = "Weltweiter Impffortschritt",
      subtitle = "Basierend auf der Stichprobe") +
  geom_point(size = 4)

# Annahme Non-Linearer Regression. Polynominale Regression wird erstellt
ggplot(Stichprobe) +
  aes(x = `people_fully_vaccinated_per_hundred`,
      y = `human_development_index`)+
  labs(x= "Anteil vollständig Geimpfte (in %)", y= "HDI-Level",
      title = "Weltweiter Impffortschritt",
      subtitle = "Basierend auf der Stichprobe") +
  geom_point(size = 4)+
  stat_smooth(method = lm, formula = y ~ log(x))

# Güte des Modells berechnen, um die Hypothese zu beantworten
modelx <- lm(formula = Stichprobe$human_development_index
             ~ log(Stichprobe$people_fully_vaccinated_per_hundred))

summary(modelx)
# --- R-Quadrat = 0.7252
# --- p-value: < 2.2e-16
