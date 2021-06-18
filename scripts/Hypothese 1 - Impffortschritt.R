# --- -------------------------------------------------------------------------------------
# --- Hypothese 1
# --- Reiche Länder schreiten bei den COVID-19 Impfungen schneller voran als ärmere Länder.
# ---
# --- V1  Mai 2021, M.Markovic
# ---
# --- Libraries: ggplot2
# ---
# --- Data: OWID COVID 19
# ---
# --- Links
# --- https://github.com/owid/covid-19-data/tree/master/public/data
# --- 
# ---
# --- -------------------------------------------------------------------------------------

# PACKAGES installieren, falls nicht vorhanden
if(!"ggplot2" %in% rownames(installed.packages())) install.packages("ggplot2")

# Packages laden
library("ggplot2")

# Set WORKING Directory
setwd(choose.dir())

