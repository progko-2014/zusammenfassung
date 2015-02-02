# Makefile für thesis. Mit pdflatex, bevorzugt auf
# Linux Rechnern und libreoffice installiert
PDFLATEX=pdflatex -interaction=nonstopmode
BIBTEX=bibtex
RM=rm

DRAWINGS=
INCLUDE_DRAWINGS=
IMAGES=
MAIN=master
TEXFILES=$(MAIN).tex
BIB=$(MAIN).bib
INCLUDE_BIB=#$(MAIN).bbl # Achtung spaeter nochmal manuell
TOPACK= $(BIB) $(DRAWINGS) $(IMAGES) $(TEXFILES) Makefile

$(MAIN): $(MAIN).pdf

# bewusst nicht erstes Ziel
all: bib $(MAIN).pdf

$(MAIN).pdf: $(TEXFILES) $(INCLUDE_DRAWINGS) $(INCLUDE_BIB)

# Bibliography geht nur manuell wegen bibtopic
# Nachteil: make erstellt bei jedem Durchlauf das PDF neu.
# Vorteil: Es geht auch von Anfang an, für Leute (die Mehrheit),
#          die nicht schauen.
bib: $(MAIN).bbl
$(MAIN).bbl: $(MAIN).bib $(MAIN).aux
	-$(BIBTEX) $(MAIN)

# Das erste Mal TeXen wegen Bibliographie
# Das allererste Mal ist die Bibliographie noch nicht drin.
$(MAIN).aux:
	$(PDFLATEX) $(MAIN).tex

.PHONY: clean

#RERUN = "(There were undefined |Rerun to get (cross-references|the bars))"

RERUN = "(There were undefined |Rerun to get (cross-references|the bars|outlines))"

.SUFFIXES: .odg .tex .pdf

.tex.pdf: bib
	$(PDFLATEX) $*.tex
	egrep $(RERUN) $*.log && ($(PDFLATEX) $*.tex) ; true
	egrep $(RERUN) $*.log && ($(PDFLATEX) $*.tex) ; true

clean:
	-$(RM) $(MAIN).pdf *.lof *.log *.lot *.aux *.bbl *.toc *.blg *.cb *.cb2 *.fot *.idx *.loa *.lol *.out *.brf
	-$(RM) $(INCLUDE_DRAWINGS) $(INCLUDE_BIB)

