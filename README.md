# epidesc <img src="inst/figures/logo_BSC.png" align="right" width="16%"/>

<!-- badges: start -->

[![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html) [![R-CMD-check](https://github.com/BSC-ES/epidesc/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/BSC-ES/epidesc/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

## Overview

<img src="inst/figures/epidesc.png" align="right" width="20%"/>

The R package **epidesc** provides the tools to easily compute a series of epidemiological indicators to characterise different transmission profiles of infectious diseases. The work is based on the publication '*How heterogeneous is the dengue transmission profile in Brazil? A study in six Brazilian states*' (<https://doi.org/10.1371/journal.pntd.0010746>) published in PLoS Neglected Tropical Diseases by Iasmim Ferreira de Almeida, Raquel Martins Lana and Cláudia Torres Codeço in 2022.

The **epidesc** pipeline to compute the indicators is as follows:

-   Formatting dates in *epiyearweek* format.
-   Choosing descriptors and its parameters from the catalogue.
-   Compute descriptors.

Before computing the descriptors, ensure the data meet the following requirements:

-   The input data has to be a data.frame with the cases and spatiotemporal identifiers.
-   The data needs to be weekly with dates in Date format.
-   If an incidence descriptor is required, the population at risk also needs to be provided.

To find out more, please see the package vignette by typing `vignette("epidesc")`.

## Included descriptors

The current version of the package includes the following descriptors:

``` r
library("epidesc")
knitr::kable(desc_list())
```

| class | fun | description | param1 | param2 |
|:--------------|:--------------|:--------------|:--------------|:--------------|
| Peak | Ap | Maximum cases peak - amplitude |  |  |
| Peak | Tp | Week where the maximum peak occurred - time |  |  |
| Period with cases | Cnf | Frequency of periods of consecutive 'n' weeks or longer with at least 'x' cases | n | x |
| Period with cases | Cmax | Maximum duration in consecutive weeks with at least 'x' cases | x |  |
| Period with cases | Cmed | Median duration in consecutive weeks with at least 'x' cases | x |  |
| Period with cases | Isof | Number of weeks with isolated cases |  |  |
| Period with cases | p | Proportion of weeks with at least 'x' cases | x |  |
| Period without cases | Cwf | Frequency of periods of consecutive weeks with at least 'n' weeks without cases. | n |  |
| Period without cases | Cwmax | Maximum duration in consecutive weeks without cases |  |  |
| Period without cases | Cwmed | Median duration in consecutive weeks without cases |  |  |
| Incidence | Inc | Annual incidence rate per 'p' population | p |  |

## Contributions

If you woud like to contribute a new descriptor to `epidesc`, please open an issue with your idea or get in touch with Raquel Martins Lana ([raquel.lana\@bsc.es](mailto:raquel.lana@bsc.es), [raquelmlana\@gmail.com](mailto:raquelmlana@gmail.com)) or Carles Milà ([carles.milagarcia\@bsc.es](mailto:carles.milagarcia@bsc.es)) to discuss its inclusion.

## Installation

`epidesc` is available on CRAN and can be installed as follows:

``` r
install.packages("epidesc")
```

You can install the development version of `epidesc` as follows:

``` r
pak::pak("https://github.com/BSC-ES/epidesc.git")
```

## Package authors

[**Raquel Martins Lana, PhD**](https://www.bsc.es/martins-lana-raquel) <a href="https://orcid.org/0000-0002-7573-1364" style="margin-left: 15px;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" alt="ORCID" style="width: 16px; height: 16px;"/></a>\
Barcelona Supercomputing Center (BSC)

[**Carles Milà, PhD**](https://www.bsc.es/mila-garcia-carles) <a href="https://orcid.org/0000-0003-0470-0760" style="margin-left: 15px;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" alt="ORCID" style="width: 16px; height: 16px;"/></a>\
Barcelona Supercomputing Center (BSC)

**Iasmin Ferreira de Almeida, PhD** <a href="https://orcid.org/0000-0002-9334-4093" style="margin-left: 15px;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" alt="ORCID" style="width: 16px; height: 16px;"/></a>\
Getulio Vargas Foundation (FGV)

**Claudia Torres Codeço, PhD** <a href="https://orcid.org/0000-0003-1174-178X" style="margin-left: 15px;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" alt="ORCID" style="width: 16px; height: 16px;"/></a>\
Oswaldo Cruz Foundation (Fiocruz)

[**Daniela Lührsen, MSc**](https://www.bsc.es/luhrsen-daniela-sofie) <a href="https://orcid.org/0009-0002-6340-5964" style="margin-left: 15px;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" alt="ORCID" style="width: 16px; height: 16px;"/></a>\
Barcelona Supercomputing Center (BSC)

**Diego Ricardo Xavier Silva, PhD** <a href="https://orcid.org/0000-0001-5259-7732" style="margin-left: 15px;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" alt="ORCID" style="width: 16px; height: 16px;"/></a>\
Oswaldo Cruz Foundation (Fiocruz)

**Christovam Barcellos, PhD** <a href="https://orcid.org/0000-0002-1161-2753" style="margin-left: 15px;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" alt="ORCID" style="width: 16px; height: 16px;"/></a>\
Oswaldo Cruz Foundation (Fiocruz)

[**Rachel Lowe, PhD**](https://www.bsc.es/lowe-rachel) <a href="https://orcid.org/0000-0003-3939-7343" style="margin-left: 15px;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" alt="ORCID" style="width: 16px; height: 16px;"/></a>\
Barcelona Supercomputing Center (BSC)\
Catalan Institution for Research & Advanced Studies (ICREA)

### Acknowledgments

Raquel M. Lana is funded by the European Union (Marie Sklodowska-Curie Actions, grant agreement 101109642).

Diego Ricardo Xavier and Raquel M. Lana acknowledge the project CNPq 445194/2024-3 - Development of Indicators for the Detection and Characterization of Anomalies in Climate-Sensitive Tropical Diseases in Brazil.

Rachel Lowe, Claudia T. Codeço and Christovam Barcellos acknowledge the Wellcome Trust HARMONIZE 224694/Z/21/Z.

Rachel Lowe and Claudia T. Codeço acknowledge the Wellcome Trust IDExtremes 226069/Z/22/Z.

Iasmim Almeida acknowledges the Wellcome Trust (Mosqlimate 226088/Z/22/Z) and the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior (CAPES, Finance Code 001).

Daniela Lührsen was supported by the Barcelona Supercomputing Center AI4Science Fellowship programme funded by the Recovery and Resilience Mechanism-Next Generation as part of the Spanish Ministry's Recovery, Transformation and Resilience Plan.
