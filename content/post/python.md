---
date: 2022-08-22T11:13:32-04:00
description: "Using Python to query and visualize Wikidata about Black artists in Philadelphia"
featured_image: "/python-programming-language.png"
tags: [python]
title: "Visualizing Wikidata with Python"
---

For this project, we used Python to run SPARQL queries against Wikidata and turn the results into interactive visualizations. The main tools are [SPARQLWrapper](https://sparqlwrapper.readthedocs.io/) for querying and [Plotly](https://plotly.com/python/) for visualization.

## Setup

The notebooks were built in Google Colab, so setup is minimal:

```python
from SPARQLWrapper import SPARQLWrapper, JSON
import pandas as pd

sparql = SPARQLWrapper("https://query.wikidata.org/sparql")
```

## Running a Query

After defining a SPARQL query string (see the [SPARQL post](/post/sparql/) for examples), you send it to Wikidata and convert the JSON response into a pandas DataFrame:

```python
sparql.setQuery(query_string)
sparql.setReturnFormat(JSON)
results = sparql.query().convert()

df = pd.json_normalize(results['results']['bindings'])
```

The resulting DataFrame has columns like `artistLabel.value`, `occupationLabel.value`, etc. -- one column per SPARQL variable, with Wikidata's JSON structure flattened out.

## Cleaning the Data

The raw DataFrame usually needs some cleanup:

- **Rename columns** to drop the `.value` suffixes
- **Handle duplicates** -- artists with multiple occupations or residences appear in multiple rows. Use `groupby` with string aggregation to collapse them
- **Parse dates** -- birth/death dates come as ISO strings and need trimming to just the year

## Visualization

We used Plotly to build interactive charts from the cleaned data -- bar charts of occupation distributions, maps of birthplaces using geocoded coordinates, and breakdowns of which museum collections hold the most works. The notebooks include the full visualization code with outputs.

## Notebooks

All notebooks are available in the [wikidata repository](https://github.com/artvizphilly/wikidata):

- **Querying_and_Visualizing_Wikidata.ipynb** -- Full analysis with SPARQL queries and Plotly visualizations
- **Wikidata_SPARQL_Queries.ipynb** -- Reference guide for query syntax
- **querying_and_visualizing_wikidata.py** -- Standalone script version (no Jupyter needed)

For a deeper discussion of the analysis, see the Scholars Studio blog post: [Visualizing Wikidata: Using Python to Analyze Identity and Representation](https://sites.temple.edu/tudsc/2022/01/24/visualizing-wikidata-using-python-to-analyze-identity-and-representation-in-wikidata-about-black-art-exhibitions/).
