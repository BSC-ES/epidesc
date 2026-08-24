---
title: 'epidesc: An R package for computing epidemiological descriptors to characterise infectious disease transmission patterns'
tags:
  - R
  - epidemiology
  - infectious diseases
  - time series
  - surveillance
authors:
  - name: Raquel Martins Lana
    orcid: 0000-0002-7573-1364
    corresponding: true
    affiliation: "1, 2"
  - name: Carles Milà Garcia
    orcid: 0000-0003-0470-0760
    corresponding: true
    affiliation: 1
  - name: Diego Ricardo Xavier
    orcid: 0000-0001-5259-7732
    affiliation: 2
  - name: Iasmim Ferreira de Almeida
    orcid: 0000-0002-9334-4093
    affiliation: "2, 3"
  - name: Cláudia Torres Codeço
    orcid: 0000-0003-1174-178X
    affiliation: 4
  - name: Daniela Sophie Lührsen
    orcid: 0009-0002-6340-5964
    affiliation: 1
  - name: Christovam Barcellos
    orcid: 0000-0002-1161-2753
    affiliation: 2
  - name: Rachel Lowe
    orcid: 0000-0003-3939-7343
    affiliation: "1, 5"
affiliations:
  - name: Barcelona Supercomputing Center, Spain
    index: 1
    ror: 05sd8tv96
  - name: Climate and Health Observatory, ICICT/Fiocruz, Brazil
    index: 2
    ror: 04jhswv08
  - name: Getúlio Vargas Foundation, Brazil
    index: 3
    ror: 01evzkn27
  - name: Scientific Computing Program, Fiocruz, Brazil
    index: 4
    ror: 04jhswv08
  - name: Catalan Institution for Research & Advanced Studies (ICREA), Spain
    index: 5  
date: 21 August 2026
bibliography: paper.bib
---

# Summary

The R package `epidesc` provides a standardised pipeline for computing
epidemiological descriptors (epi-descriptors) from weekly case count
time series of infectious diseases. These epi-descriptors characterise
the transmission dynamics, by quantifying the magnitude, duration, and
temporal patterns of cases at a spatial unit, enabling the
classification of areas into distinct transmission patterns (e.g.,
persistent, epidemic, episodic, outbreaks, trends). The workflow
requires three steps: formatting temporal data into epidemiological
year-week identifiers, selecting descriptors and their parameters from a
built-in catalogue, and computing descriptors for each spatial unit and
epidemiological year. `epidesc` is designed for researchers and public
health professionals working on infectious disease surveillance, early
warning systems, and spatial epidemiology.

# Statement of need

Climate-sensitive diseases such as dengue, malaria, and leptospirosis
exhibit heterogeneous transmission dynamics across space and time,
driven by climatic, demographic, and socioeconomic factors
[@deAlmeida2022; @Alcayna2025]. Studies have demonstrated that the
spatio-temporal diffusion of dengue is conditioned by population
mobility, vector distribution, and local social and environmental
characteristics, producing distinct epidemic patterns even at the
neighbourhood scale [@Xavier2017]. Understanding and classifying these
dynamics is essential for designing targeted surveillance strategies and
allocating resources efficiently. Inspired by the epi-features
calculated for influenza curves conceived by [@Tabataba2017], 
@deAlmeida2022 proposed a set of 13 epi-descriptors to
characterise dengue transmission patterns in Brazilian municipalities,
demonstrating their utility for clustering areas into persistent,
epidemic, and episodic transmission categories. However, the original
analysis relied on custom scripts that were not packaged for reuse by
the broader research community.

`epidesc` addresses this gap by encapsulating the epi-descriptors
computation methodology into a modular and flexible R package. The
target audience includes epidemiologists, data scientists, and public
health analysts who need to systematically characterise disease
transmission patterns from routine notification data. The package
facilitates the reproduction and extension of epi-descriptors, allows
comparative patterns across diseases and geographies, and supports the
development of public health interventions tailored to local
transmission patterns.

# State of the field

Several R packages support epidemiological time series analysis. Early
tools like `surveillance` [@Meyer2017] and `EpiEstim` [@Cori2013]
established standard frameworks for outbreak detection and real-time
reproduction number ($R_t$) estimation. Accelerated by the COVID-19
pandemic, the wider Epiverse-TRACE software initiative has significantly
expanded this toolkit. Modern packages include `EpiNow2` [@Abbott2026]
for Bayesian estimation of infection trajectories and $R_t$ under
reporting delays, `incidence2` [@Taylor2024] for computing and
visualising incidence curves, and specialized tools such as
`epiparameter` [@Lambert2025] for epidemiological parameter
extraction. Outside the R ecosystem, `EpiViewer` [@Thorve2018]
provides a web-based framework for exploring, comparing, and organising
epidemiological time series, with built-in computation of general
epidemic features such as peak timing and magnitude, cumulative counts,
and first take-off time. `Epipoi` is an useful epidemiological time
series analysis tool for detecting trends, seasonality, anomalies and
spatial patterns [@Alonso2012]. It was developed and compiled in
MATLAB but its last version is outdated. However, none of these packages
provide a dedicated framework for computing the specific set of temporal
descriptors needed to characterise and classify disease transmission
patterns at a spatial unit.

The novelty of `epidesc` lies in its focus on descriptive features of
epidemic time series rather than on mechanistic modelling or outbreak
detection. By computing indicators such as the maximum duration of
consecutive weeks with at least x cases, the proportion of weeks
exceeding this threshold, and the frequency of case-free periods,
`epidesc` enables a data-driven classification of transmission patterns.
This approach complements existing tools and is particularly relevant
for diseases with strong seasonality and spatial heterogeneity, such as
dengue in tropical settings. Furthermore, `epidesc` is designed to
accommodate the addition of new descriptors from the research community.

# Software design

`epidesc` is structured as a standard R package following CRAN
conventions, with comprehensive documentation via roxygen2
[@Wickham2026], unit tests using testthat [@Wickham2011], and a
vignette demonstrating the complete workflow. The package depends on
lubridate [@Grolemund2011] for date manipulation and nseq
[@Saldanha2024] for efficient run-length encoding operations on time
series.

`epidesc` is available on CRAN
[10.32614/CRAN.package.epidesc](10.32614/CRAN.package.epidesc) and the
development version can be accessed at
<https://github.com/BSC-ES/epidesc>. The software architecture follows a
three-step pipeline (\autoref{fig:fig1}):

![Schematic pipeline of the `epidesc` package. Input data containing weekly case counts with spatial and temporal identifiers are processed across three stages: date formatting with epiyearweek(), descriptor selection via desc_list(), and computation with desc_year(), producing epidemiological descriptors per spatial unit and epidemiological year.\label{fig:fig1}](figure.png){ width=100% }

**Input data:** As input, `epidesc` requires a dataframe containing
epidemiological line-list data. This dataframe must include at least 3
columns: weekly case counts, a spatial identifier and a date.   
**Step 1 — Date formatting:** the function epiyearweek() converts Date 
vectors into epidemiological year-week identifiers (format yyyyww), 
supporting both ISO weeks (starting Monday) and epidemiological 
weeks (starting Sunday).      
**Step 2 — Descriptor specification:** users select descriptors from a
built-in catalogue accessible via desc_list(), specifying parameters
such as the minimum number of consecutive weeks or the case threshold.
The catalogue currently includes 11 epi-descriptors organised into four
classes (Table 1).       
**Step 3 — Computation:** the main function desc_year()
computes all specified epi-descriptors by spatial unit and
epidemiological year.     
**Output:** `epidesc` provides an object that stores
selected epi-descriptors calculated by year or epidemiological year and
spatial unit identifier.    

Table 1- Epi-descriptors included in `epidesc` v0.1.0.

| Class | Function | Description | Parameters |
|------------------|------------------|------------------|------------------|
| Peak | Ap | Maximum number of cases (peak) - amplitude |  |
| Peak | Tp | Week where the maximum peak occurred - time |  |
| Period with cases | Cnf | Frequency of periods of consecutive n weeks or longer with at least x cases | n, x |
| Period with cases | Cmax | Maximum duration in consecutive weeks with at least x cases | x |
| Period with cases | Cmed | Median duration in consecutive weeks with at least x cases | x |
| Period with cases | Isof | Number of weeks with isolated cases |  |
| Period with cases | p | Proportion of weeks with at least x cases | x |
| Period without cases | Cwf | Frequency of periods of at least n consecutive weeks without cases | n |
| Period without cases | Cwmax | Maximum duration in consecutive weeks without cases |  |
| Period without cases | Cwmed | Median duration in consecutive weeks without cases |  |
| Incidence | Inc | Annual incidence per p population | p |

With the exception of incidence rate calculations, the epi-descriptors
do not require population estimates for the spatial unit of analysis.
This facilitates their application in settings where population data are
incomplete or not regularly updated, a common limitation at fine spatial
scales and particularly relevant in resource-constrained settings.

The desc_year() function performs input validation by checking the
regularity of the time series, identifying duplicate time points within
spatial units, and verifying that population data are provided when
incidence descriptor is requested. If the spatio-temporal grid is
incomplete, the function issues a warning. Epi-descriptors are
calculated only for complete epidemiological years; if an
epidemiological year has missing weeks or case records, the
corresponding descriptors are returned as NA. Week 53, when present, is
optionally handled by equally distributing its cases between weeks 52 of
the same year and 01 of the next year, ensuring consistent 52-week years
for descriptor calculation. This behaviour is controlled by the argument
collapse53, which is TRUE by default. A minimal usage example is as
follows:

``` r
library(epidesc)
data("dengueRio")

# step 1: date formatting
dengue <- dengueRio
dengue$yearweek <- epiyearweek(dengue$date, start = "Sunday")

# step 2: descriptor specification
descriptors <- list(
  Ap = list(fun = "Ap"),
  Cnf3 = list(fun = "Cnf", n = 3, x = 5),
  Inc = list(fun = "Inc", p = 100000)
)

# step 3: computation of epi-descriptors
res <- desc_year(
  data = dengue,
  cases = "cases",
  time = "yearweek",
  space = "muni_code",
  pop = "pop",
  sweek = 41,
  descriptors = descriptors
)
```

The package includes a sample dataset (dengueRio) containing weekly
dengue cases for municipalities in the state of Rio de Janeiro
(2017–2022), enabling users to explore the functionality immediately
after installation.

# Research impact statement

The methodological framework implemented in `epidesc` was originally
developed and applied in @deAlmeida2022, which
classified 1,823 Brazilian municipalities into four distinct dengue
transmission patterns (persistent, epidemic, episodic/epidemic, and
episodic) using data from 2010 to 2019. That study demonstrated the
association between transmission patterns, population size, and climate,
providing evidence for the existence of a critical community size for
persistent dengue transmission. The classification framework has
implications for the design of differentiated surveillance protocols and
the achievement of World Health Organization goals for neglected
tropical disease elimination.

By packaging this methodology into `epidesc`, we enable its application
to other diseases (e.g., Zika, chikungunya, malaria), other geographies,
and longer time periods. The package is currently being used within the
Global Health Resilience (GHR) group at the Barcelona Supercomputing
Center in Spain and at the Oswaldo Cruz Foundation (Fiocruz) in Brazil
for ongoing research on climate-sensitive disease dynamics and early
warning systems. The open-source availability of `epidesc` facilitates
reproducibility and encourages community contributions of additional
descriptors.

# Future developments and call for contributions

In future versions of the package, we intend to expand the range of
epi-descriptors to include methodologies to characterise the seasonality
of the disease. Furthermore, we call for contributions to extend the
list of supported epi-descriptors and welcome any suggestions either via
Github issues [https://github.com/BSC-ES/epidesc/issues](https://github.com/BSC-ES/epidesc/issues) 
or by sending an email to the corresponding authors.

# AI usage disclosure

AI tools were used to code-review the package (in addition to human code
review), to assist with unit testing and support in English review.

# Author contributions

RML, IFA, and CTC conceived and implemented epi-descriptors and curated
the data demo. CMG developed the R package. RML, CMG, and DSL
contributed to package design. RML, CMG, DSL, and DRX conducted tests
and package validation. RML, CMG, IFA, DSL, DRX and RL reviewed package
GitHub repository. RML and DRX wrote the manuscript. All authors
reviewed the final manuscript version.

# Conflict of interest

We declare we have no competing interests.

# Acknowledgements

Raquel M. Lana is funded by the European Union (Marie Sklodowska-Curie
Actions, grant agreement 101109642).

Diego Ricardo Xavier and Raquel M. Lana acknowledge the project CNPq
445194/2024-3 - Development of Indicators for the Detection and
Characterization of Anomalies in Climate-Sensitive Tropical Diseases in
Brazil.

Rachel Lowe, Claudia T. Codeço and Christovam Barcellos acknowledge the
Wellcome Trust HARMONIZE 224694/Z/21/Z.

Rachel Lowe and Claudia T. Codeço acknowledge the Wellcome Trust
IDExtremes 226069/Z/22/Z.

Iasmim Ferreira de Almeida acknowledges the Wellcome Trust (Mosqlimate
226088/Z/22/Z) and the Coordenação de Aperfeiçoamento de Pessoal de
Nível Superior (CAPES, Finance Code 001).

Christovam Barcellos and Diego Ricardo Xavier acknowledge the financial
support from CNPq (process 444665/2023-4) and the Pasteur Network
(Climate–Health Observatory Accelerator Project).

Daniela Lührsen was supported by the Barcelona Supercomputing Center
AI4Science Fellowship programme funded by the Recovery and Resilience
Mechanism-Next Generation as part of the Spanish Ministry's Recovery,
Transformation and Resilience Plan.

# References


